import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.charset.Charset;
import java.io.IOException;
import java.nio.file.StandardOpenOption;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class C64Basic {

    private static class Tokenizer {

        private final StringBuffer source;
        static Map<String,Byte> keywords = new HashMap<>();
        static Map<String,Byte> keycodes = new HashMap<>();
        static String[] commands;
        byte[] code = new byte[38913]; // 38911 basic byte free!
        private int start = 0;
        private int current = 0;
        private int cidx = 0; // code index
        private int nexti;    // where to put index of next tokenized line
        //private int line = 1;
        private boolean LINENO; // looking for a line number?

        public Tokenizer(String source) {
            this.source = new StringBuffer(source);
            // load the HashMaps
            populateKeywords();
            populateKeycodes();

            code[cidx++] = (byte)(0x01);
            code[cidx++] = (byte)(0x08);
            nexti = cidx;
            //cidx += 2; // leave 2 bytes for address link to next line
        }

        byte[] scanTokens() {
            LINENO = true;
            while (!isAtEnd()) {
                // We are at the beginning of the next lexeme.
                start = current;
                scanToken();
            }
            addToken(0);
            // return only what we need.
            byte[] c = new byte[cidx];
            System.arraycopy(code, 0, c, 0, cidx);
            return c;
        }

        private void scanToken() {
            char c = advance();
            switch (c) {
                case '+' : addToken((byte)0xaa); break;
                case '-' : addToken((byte)0xab); break;
                case '*' : addToken((byte)0xac); break;
                case '/' : addToken((byte)0xad); break;
                case '↑' : case '^': addToken((byte)0xae); break;
                case '>' : addToken((byte)0xb1); break;
                case '=' : addToken((byte)0xb2); break;
                case '<' : addToken((byte)0xb3); break;
                case '?' : addToken((byte)0x99); break; // other form of print

                case '"': string(); break;

                case '\n' : case '\r' :
                    // mark end of line
                    addToken((byte)0);
                    int pos = cidx - 2 + 0x0801;
                    System.out.printf("cidx = 0x%04X, pos = 0x%04x%n", cidx, pos);
                    // replace previous link with new address.
                    code[nexti]   = (byte)(pos & 0xff);
                    code[nexti+1] = (byte)((pos & 0xff00) >> 8);
                    LINENO = true;
                    break; // fixup!

                // if it's not special, bring it along.
                default  :
                    if (isDigit(c) && LINENO) {
                        nexti = cidx;
                        cidx += 2; // leave room for the next pointer

                        number();
                        while(peek()==' ') advance(); // consume space(s) after line number
                        LINENO = false;
                    } else if (isAlpha(c))
                        command();
                    else addToken((byte)petscii(c));
            }
        }

        private void command() {
            //System.out.println("entered command()");
            for ( String c : commands ) {
                //System.out.println(c + " " + source.indexOf(c) + " " + start);
                if (source.indexOf(c, start) == start) {
                    byte op = keywords.get(c);
                    System.out.printf("Found %s, 0x%02x%n", c, op);
                    addToken(op);
                    current = start + c.length(); // adjust line
                    // if it's a REM, special handling to end of line.
                    if (op == (byte) 0x8f) {
                        start = current;
                        while (peek() != '\n') advance();
                        addToken(source.substring(start, current));
                    }
                    return;
                }
            }
            addToken(source.substring(start, current));
        }

        private void number() {
            //System.out.println("entered number()");
            while (isDigit(peek())) advance();
            addToken(Integer.parseInt(source.substring(start, current)));
        }

        private void string() {
            //System.out.println("entered string()");
            while (peek() != '"' && !isAtEnd()) {
                if (peek() == '\n') break; //
                if (peek() == '{')
                    keycode();
                else
                    advance();
            }

            // Maybe the closing ". C64 doesn't care about missing close "
            if (peek() != '\n' && peek() != '\r')
                advance();

            String value = source.substring(start, current);
            addToken(value);
        }

        private void keycode() {
            //System.out.println("entered keycode()");
            int s = current;
            byte kc=0;
            while (peek() != '}' && !isAtEnd()) advance();
            advance(); // consume the }
            String value = source.substring(s, current);
            //System.out.println("found " + value);
            if (keycodes.containsKey(value))
                kc = keycodes.get(value);
            else
                try {
                    kc = (byte)(Integer.parseInt(value.substring(1,value.length()-1)) & 0xff);
                } catch (NumberFormatException e) {
                    System.err.println("Invalid keycode: " + value);
                    System.exit(1);
                }
            //System.out.printf("keycode() value = %s, 0x%02X%n", value, kc);
            char c = (char)(kc & 0xff);
            source.replace(s, current, "" + c);
            current = s;
            advance(); // move past the replaced code
        }

        private char peek() {
            if (isAtEnd()) return '\0';
            return source.charAt(current);
        }

        private static boolean isDigit(char c) {
            return c >= '0' && c <= '9';
        }

        private static boolean isAlpha(char c) {
            return (c >= 'A' && c <= 'Z') || ( c >= 'a' && c < 'z');
        }

        private boolean isAtEnd() {
            return current >= source.length();
        }

        private char advance() {
            return source.charAt(current++);
        }

        private void addToken(byte b) {
            //System.out.printf("Adding byte 0x%02x%n", b);
            code[cidx++] = b;
        }

        private void addToken(int i) {
            //System.out.printf("Adding int 0x%04x%n", i);
            code[cidx++] = (byte)(i & 0xff);
            code[cidx++] = (byte)((i & 0xff00) >> 8);
        }

        private void addToken(String s) {
            //System.out.printf("Adding string %s%n", s);
            for (int x = 0; x < s.length(); x++)
                code[cidx++] = (byte)petscii(s.charAt(x));
            //code[cidx++] = (byte)s.charAt(x);
        }

        private char petscii(char c) {
            if ( c >= 'A' && c <= 'Z' ) return (char)(c + 32);
            if ( c >= 'a' && c <= 'z' ) return (char)(c - 32);
            return c;
        }

        private static void populateKeycodes() {
            keycodes.put("{white}", (byte)0x05);
            keycodes.put("{return}", (byte)0x0d);
            keycodes.put("{down}", (byte)0x11);
            keycodes.put("{reverse on}", (byte)0x12);
            keycodes.put("{home}", (byte)0x13);
            keycodes.put("{delete}", (byte)0x14);
            keycodes.put("{red}", (byte)0x1c);
            keycodes.put("{right}", (byte)0x1d);
            keycodes.put("{green}", (byte)0x1e);
            keycodes.put("{blue}", (byte)0x1f);
            keycodes.put("{pound}", (byte)0x5c);
            keycodes.put("{orange}", (byte)0x81);
            keycodes.put("{black}", (byte)0x90);
            keycodes.put("{up}", (byte)0x91);
            keycodes.put("{reverse off}", (byte)0x92);
            keycodes.put("{clear}", (byte)0x93);
            keycodes.put("{brown}", (byte)0x95);
            keycodes.put("{pink}", (byte)0x96);
            keycodes.put("{dark gray}", (byte)0x97);
            keycodes.put("{grey}", (byte)0x98);
            keycodes.put("{light green}", (byte)0x99);
            keycodes.put("{light blue}", (byte)0x9a);
            keycodes.put("{light gray}", (byte)0x9b);
            keycodes.put("{purple}", (byte)0x9c);
            keycodes.put("{left}", (byte)0x9d);
            keycodes.put("{yellow}", (byte)0x9e);
            keycodes.put("{cyan}", (byte)0x9f);
            keycodes.put("{pi}", (byte)0xff);
        }

        private static void populateKeywords(){
            keywords.put("end",(byte)0x80);
            keywords.put("for",(byte)0x81);
            keywords.put("next",(byte)0x82);
            keywords.put("data",(byte)0x83);
            keywords.put("input#",(byte)0x84);
            keywords.put("input",(byte)0x85);
            keywords.put("dim",(byte)0x86);
            keywords.put("read",(byte)0x87);
            keywords.put("let",(byte)0x88);
            keywords.put("goto",(byte)0x89);
            keywords.put("run",(byte)0x8a);
            keywords.put("if",(byte)0x8b);
            keywords.put("restore",(byte)0x8c);
            keywords.put("gosub",(byte)0x8d);
            keywords.put("return",(byte)0x8e);
            keywords.put("rem",(byte)0x8f);
            keywords.put("stop",(byte)0x90);
            keywords.put("on",(byte)0x91);
            keywords.put("wait",(byte)0x92);
            keywords.put("load",(byte)0x93);
            keywords.put("save",(byte)0x94);
            keywords.put("verify",(byte)0x95);
            keywords.put("def",(byte)0x96);
            keywords.put("poke",(byte)0x97);
            keywords.put("print#",(byte)0x98);
            keywords.put("print",(byte)0x99);
            keywords.put("cont",(byte)0x9a);
            keywords.put("list",(byte)0x9b);
            keywords.put("clr",(byte)0x9c);
            keywords.put("cmd",(byte)0x9d);
            keywords.put("sys",(byte)0x9e);
            keywords.put("open",(byte)0x9f);
            keywords.put("close",(byte)0xa0);
            keywords.put("get",(byte)0xa1);
            keywords.put("new",(byte)0xa2);
            keywords.put("tab(",(byte)0xa3);
            keywords.put("to",(byte)0xa4);
            keywords.put("fn",(byte)0xa5);
            keywords.put("spc(",(byte)0xa6);
            keywords.put("then",(byte)0xa7);
            keywords.put("not",(byte)0xa8);
            keywords.put("step",(byte)0xa9);
        /*
        keywords.put("+",(byte)0xaa);
        keywords.put("-",(byte)0xab);
        keywords.put("*",(byte)0xac);
        keywords.put("/",(byte)0xad);
        keywords.put("↑",(byte)0xae);
        */
            keywords.put("and",(byte)0xaf);
            keywords.put("or",(byte)0xb0);
        /*
        keywords.put(">",(byte)0xb1);
        keywords.put("=",(byte)0xb2);
        keywords.put("<",(byte)0xb3);
        */
            keywords.put("sgn",(byte)0xb4);
            keywords.put("int",(byte)0xb5);
            keywords.put("abs",(byte)0xb6);
            keywords.put("usr",(byte)0xb7);
            keywords.put("fre",(byte)0xb7);
            keywords.put("pos",(byte)0xb9);
            keywords.put("sqr",(byte)0xba);
            keywords.put("rnd",(byte)0xbb);
            keywords.put("log",(byte)0xbc);
            keywords.put("exp",(byte)0xbd);
            keywords.put("cos",(byte)0xbe);
            keywords.put("sin",(byte)0xbf);
            keywords.put("tan",(byte)0xc0);
            keywords.put("atn",(byte)0xc1);
            keywords.put("peek",(byte)0xc2);
            keywords.put("len",(byte)0xc3);
            keywords.put("str$",(byte)0xc4);
            keywords.put("val",(byte)0xc5);
            keywords.put("asc",(byte)0xc6);
            keywords.put("chr$",(byte)0xc7);
            keywords.put("left$",(byte)0xc8);
            keywords.put("right$",(byte)0xc9);
            keywords.put("mid$",(byte)0xca);
            keywords.put("go",(byte)0xcb);

            commands = keywords.keySet().toArray(new String[1]);
            Arrays.sort(commands, Collections.reverseOrder());
        }
    }

    private static void hexdump(byte[] bytes) {
        int start = (bytes[1] & 0xff) * 256 + (bytes[0] & 0xff);
        int pc = start;
        StringBuilder chars = new StringBuilder();
        int zeroes = 0;

        for (int x = 2; x < bytes.length; x++) {
            if ( (pc - start) % 8 == 0 ) {
                System.out.printf(" %s", chars);
                if ( zeroes >= 3 ) return;
                System.out.printf("\n%04X:", pc);
                chars.setLength(0);
            }
            char c = (char)(bytes[x] & 0xff);
            zeroes = c==0 ? zeroes + 1 : 0;
            if ( c >= 32 && c <= 127 )
                chars.append(c);
            else
                chars.append('.');
            System.out.printf(" %02X", bytes[x]);
            pc++;

        }
        System.out.println("\n");
    }

    public static void main(String[] args) throws IOException {
        byte[] bytes;

        if (args.length != 2) {
            System.out.println("Must provide source and object.");
            System.exit(3);
        }

        bytes = Files.readAllBytes(Paths.get(args[0]));

        Tokenizer tzr = new Tokenizer(new String(bytes, Charset.defaultCharset()));
        byte[] program = tzr.scanTokens();

        hexdump(program);
        Files.write(Paths.get(args[1]), program, StandardOpenOption.CREATE);
    }
}
