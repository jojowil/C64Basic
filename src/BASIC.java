import java.util.*;

public class BASIC {

    private static class Source {

    }

    private static class Program {

    }

    private static class Var {


        public void add (String name, String val) {

        }

        public void add (String name, int val) {

        }

        public void add (String name, double val) {

        }
    }

    private static class Tokenizer {
        private final StringBuffer source;
        static Map<String, Byte> keywords = new HashMap<>();
        static Map<String, Byte> keycodes = new HashMap<>();
        static String[] commands;
        byte[] code = new byte[38913]; // 38911 basic byte free!
        private int start = 0; // start of the code section being tokenized
        private int current = 0; // current position >= start
        private int cidx = 0; // code index
        private int nexti;    // where to put index of next tokenized line
        //private int line = 1;
        private boolean LINENO; // looking for a line number?

        // Tokenizer constructor
        private Tokenizer(String source) {
            this.source = new StringBuffer(source);
            // load the HashMaps
            populateKeywords();

            // First two bytes are the starting address on C64
            code[cidx++] = (byte) (0x01);
            code[cidx++] = (byte) (0x08);
            nexti = cidx;
            //cidx += 2; // leave 2 bytes for address link to next line
        }

        // Kickoff the token scanning!
        private byte[] scanTokens() {
            LINENO = true;
            while (!isAtEnd()) {
                // We are at the beginning of the next lexeme.
                start = current;
                scanToken();
            }
            // At this point, all source code has been processed.
            addToken(0); // null pointer at end of program.
            // return only what we need.
            byte[] c = new byte[cidx];
            System.arraycopy(code, 0, c, 0, cidx);
            return c;
        }

        // Find simple tokens and predict larger ones.
        private void scanToken() {
            char c = advance();
            switch (c) {
                case '+':
                    addToken((byte) 0xaa);
                    break;
                case '-':
                    addToken((byte) 0xab);
                    break;
                case '*':
                    addToken((byte) 0xac);
                    break;
                case '/':
                    addToken((byte) 0xad);
                    break;
                case '↑':
                case '^':
                    addToken((byte) 0xae);
                    break;
                case '>':
                    addToken((byte) 0xb1);
                    break;
                case '=':
                    addToken((byte) 0xb2);
                    break;
                case '<':
                    addToken((byte) 0xb3);
                    break;
                case '?':
                    addToken((byte) 0x99);
                    break; // other form of print

                case '"':
                    string();
                    break;

                case '\n':
                case '\r':
                    // mark end of tokenized line
                    addToken((byte) 0);
                    int pos = cidx - 2 + 0x0801;
                    //System.out.printf("cidx = 0x%04X, pos = 0x%04x%n", cidx, pos);
                    // replace previous link with new address.
                    code[nexti] = (byte) (pos & 0xff);
                    code[nexti + 1] = (byte) ((pos & 0xff00) >> 8);
                    LINENO = true;
                    break; // fixup!

                // if it's not special, bring it along.
                default:
                    if (isDigit(c) && LINENO) {
                        nexti = cidx;
                        cidx += 2; // leave room for the next pointer
                        number();
                        while (peek() == ' ') advance(); // consume space(s) after line number
                        LINENO = false;
                    } else if (isAlpha(c))
                        command();
                    else addToken((byte) petscii(c));
            }
        }

        // Build a command token
        private void command() {
            //System.out.println("entered command()");
            for (String c : commands) {
                //System.out.println(c + " " + source.indexOf(c) + " " + start);
                if (source.indexOf(c, start) == start) {
                    byte op = keywords.get(c);
                    //System.out.printf("Found %s, 0x%02x%n", c, op);
                    addToken(op);
                    current = start + c.length(); // adjust line
                    // if it's a REM, special handling to end of line.
                    if (op == (byte) 0x8f) {
                        start = current;
                        while (peek() != '\n') advance();
                        addToken(source.substring(start, current));
                    }
                    return; // matched a keyword, leave.
                }
            }
            // Add raw text that didn't match
            addToken(source.substring(start, current));
        }

        // Build a number token
        private void number() {
            //System.out.println("entered number()");
            while (isDigit(peek())) advance();
            addToken(Integer.parseInt(source.substring(start, current)));
        }

        // Build a string token
        private void string() {
            //System.out.println("entered string()");
            while (peek() != '"' && !isAtEnd()) {
                if (peek() == '\n') break;
                advance();
            }

            // Maybe the closing ". C64 doesn't care about missing close "
            if (peek() != '\n' && peek() != '\r')
                advance();

            String value = source.substring(start, current);
            addToken(value);
        }

        // Look ahead.
        private char peek() {
            if (isAtEnd()) return '\0';
            return source.charAt(current);
        }

        private static boolean isDigit(char c) {
            return c >= '0' && c <= '9';
        }

        private static boolean isAlpha(char c) {
            return (c >= 'A' && c <= 'Z') || (c >= 'a' && c < 'z');
        }

        private boolean isAtEnd() {
            return current >= source.length();
        }

        private char advance() {
            return source.charAt(current++);
        }

        // Add token as bvte
        private void addToken(byte b) {
            //System.out.printf("Adding byte 0x%02x%n", b);
            code[cidx++] = b;
        }

        // Add token as int - little endian
        private void addToken(int i) {
            //System.out.printf("Adding int 0x%04x%n", i);
            code[cidx++] = (byte) (i & 0xff);
            code[cidx++] = (byte) ((i & 0xff00) >> 8);
        }

        // Add token as string
        private void addToken(String s) {
            //System.out.printf("Adding string %s%n", s);
            for (int x = 0; x < s.length(); x++)
                code[cidx++] = (byte) petscii(s.charAt(x));
            //code[cidx++] = (byte)s.charAt(x);
        }

        // Convert to PETSCII
        private char petscii(char c) {
            if (c >= 'A' && c <= 'Z') return (char) (c + 32);
            if (c >= 'a' && c <= 'z') return (char) (c - 32);
            return c;
        }

        // Populate the keywords map.
        private static void populateKeywords() {
            keywords.put("end", (byte) 0x80);
            keywords.put("for", (byte) 0x81);
            keywords.put("next", (byte) 0x82);
            keywords.put("data", (byte) 0x83);
            keywords.put("input#", (byte) 0x84);
            keywords.put("input", (byte) 0x85);
            keywords.put("dim", (byte) 0x86);
            keywords.put("read", (byte) 0x87);
            keywords.put("let", (byte) 0x88);
            keywords.put("goto", (byte) 0x89);
            keywords.put("run", (byte) 0x8a);
            keywords.put("if", (byte) 0x8b);
            keywords.put("restore", (byte) 0x8c);
            keywords.put("gosub", (byte) 0x8d);
            keywords.put("return", (byte) 0x8e);
            keywords.put("rem", (byte) 0x8f);
            keywords.put("stop", (byte) 0x90);
            keywords.put("on", (byte) 0x91);
            keywords.put("wait", (byte) 0x92);
            keywords.put("load", (byte) 0x93);
            keywords.put("save", (byte) 0x94);
            keywords.put("verify", (byte) 0x95);
            keywords.put("def", (byte) 0x96);
            keywords.put("poke", (byte) 0x97);
            keywords.put("print#", (byte) 0x98);
            keywords.put("print", (byte) 0x99);
            keywords.put("cont", (byte) 0x9a);
            keywords.put("list", (byte) 0x9b);
            keywords.put("clr", (byte) 0x9c);
            keywords.put("cmd", (byte) 0x9d);
            keywords.put("sys", (byte) 0x9e);
            keywords.put("open", (byte) 0x9f);
            keywords.put("close", (byte) 0xa0);
            keywords.put("get", (byte) 0xa1);
            keywords.put("new", (byte) 0xa2);
            keywords.put("tab(", (byte) 0xa3);
            keywords.put("to", (byte) 0xa4);
            keywords.put("fn", (byte) 0xa5);
            keywords.put("spc(", (byte) 0xa6);
            keywords.put("then", (byte) 0xa7);
            keywords.put("not", (byte) 0xa8);
            keywords.put("step", (byte) 0xa9);
        /*
        keywords.put("+",(byte)0xaa);
        keywords.put("-",(byte)0xab);
        keywords.put("*",(byte)0xac);
        keywords.put("/",(byte)0xad);
        keywords.put("↑",(byte)0xae);
        */
            keywords.put("and", (byte) 0xaf);
            keywords.put("or", (byte) 0xb0);
        /*
        keywords.put(">",(byte)0xb1);
        keywords.put("=",(byte)0xb2);
        keywords.put("<",(byte)0xb3);
        */
            keywords.put("sgn", (byte) 0xb4);
            keywords.put("int", (byte) 0xb5);
            keywords.put("abs", (byte) 0xb6);
            keywords.put("usr", (byte) 0xb7);
            keywords.put("fre", (byte) 0xb8);
            keywords.put("pos", (byte) 0xb9);
            keywords.put("sqr", (byte) 0xba);
            keywords.put("rnd", (byte) 0xbb);
            keywords.put("log", (byte) 0xbc);
            keywords.put("exp", (byte) 0xbd);
            keywords.put("cos", (byte) 0xbe);
            keywords.put("sin", (byte) 0xbf);
            keywords.put("tan", (byte) 0xc0);
            keywords.put("atn", (byte) 0xc1);
            keywords.put("peek", (byte) 0xc2);
            keywords.put("len", (byte) 0xc3);
            keywords.put("str$", (byte) 0xc4);
            keywords.put("val", (byte) 0xc5);
            keywords.put("asc", (byte) 0xc6);
            keywords.put("chr$", (byte) 0xc7);
            keywords.put("left$", (byte) 0xc8);
            keywords.put("right$", (byte) 0xc9);
            keywords.put("mid$", (byte) 0xca);
            keywords.put("go", (byte) 0xcb);

            commands = keywords.keySet().toArray(new String[1]);
            Arrays.sort(commands, Collections.reverseOrder());
        }
    }

    /* These are the original C64 errors.
     * It seems that ?REDO FROM START and
     * ?EXTRA IGNORED are handled by INPUT.
     * ?FILE DATA and ?STRING TOO LONG are
     * handled by INPUT#, but are in the table.
     * NOTE: ?FILE DATA is also seen as
     * ?BAD DATA in certain documents.
     */
    static String[] ERRORS64 = {
            "?STOP KEY DETECTED", // 0
            "?TOO MANY FILES", // 1
            "?FILE OPEN", // 2
            "?FILE NOT OPEN", // 3
            "?FILE NOT FOUND", // 4
            "?DEVICE NOT PRESENT", // 5
            "?NOT INPUT FILE", // 6
            "?NOT OUTPUT FILE", // 7
            "?MISSING FILENAME", // 8
            "?ILLEGAL DEVICE NUMBER", // 9
            "?NEXT WITH FOR", // 10
            "?SYNTAX", // 11
            "?RETURN WITHOUT GOSUB", // 12
            "?OUT OF DATA", // 13
            "?ILLEGAL QUANTITY", // 14
            "?OVERFLOW", // 15
            "?OUT OF MEMORY", // 16
            "?UNDEF'D STATEMENT", // 17
            "?BAD SUBSCRIPT", // 18
            "?REDIM'D ARRAY", // 19
            "?DIVISION BY ZERO", // 20
            "?ILLEGAL DIRECT", // 21
            "?TYPE MISMATCH", // 22
            "?STRING TOO LONG", // 23
            "?FILE DATA", // 24
            "?FORMULA TOO COMPLEX", // 25
            "?CAN'T CONTINUE", // 26
            "?UNDEF'D FUNCTION", // 27
            "?VERIFY", // 28
            "?LOAD", // 29
            "?BREAK", // 30
    };

    public static void main(String[] args) {

        if (args.length != 0) {
            // FIXME process args
            System.out.println("\nCommand line arguments not yet implemented.\n");
        } else {
            // Interactive!
            Scanner kb = new Scanner(System.in);
            System.out.println("\nREADY.");

            while (kb.hasNext()) {
                String line = kb.nextLine().strip();

                // true == program line including line number
                if (!preProcess(line)) {
                    processCommand(line);
                } else {
                    addLine(line);
                }
                System.out.println("\nREADY.");
            }
        }
    }

    private static void doError(int e) {
        System.out.println(( e < 0 || e > ERRORS64.length ) ? "?UNKNOWN" : ERRORS64[e] + " ERROR");
    }

    private static boolean preProcess(String line) {
        return line != null && !line.isEmpty() && Character.isDigit(line.charAt(0));
    }

    private static void processCommand(String line) {

    }

    private static void addLine(String line) {

    }

    private void CMDrun(String line) {

    }

    private void CMDlist(int beg, int end) {

    }

    private void CMDload(String fn) {

    }

    private void CMDsave(String fn) {

    }

    private void CMDverify(String fn) {

    }
}
