import java.util.Scanner;
import java.util.HashMap;
import java.util.Map;
import java.util.Arrays;
import java.util.TreeMap;
import java.util.Collections;
import java.util.EmptyStackException;

public class BASIC {

    private static final int MAXLINENUM = 64999;

    private static class GenStack<T> {
        // the top of the stack
        private Node top;
        private int size;

        private class Node {
            private T data;
            private Node next;

            private Node(T item) {
                data = item;
                next = null;
            }
        }

        public GenStack () {
            top = null;
            size = 0;
        }

        // returns the top value or exception when empty.
        public T peek() {
            if (isEmpty())
                throw new EmptyStackException();
            else
                return top.data;
        }

        // push new item on the top
        public void push(T item) {
            Node n = new Node(item);
            n.next = top;
            top = n;
            size++;
        }

        // remove item from the top and return the removed value.
        public T pop() {
            T v;
            if ( isEmpty() )
                throw new EmptyStackException();
            v = top.data;
            top = top.next;
            size--;
            return v;
        }

        // debug method to dump the contents of the stack to the screen
        public String toString() {
            Node p = top;
            String s = "";

            while ( p != null ) {
                s = s + p.data + "\n";
                p = p.next;
            }
            return s;
        }

        // method to determine if the stack is empty.
        public boolean isEmpty() {
            return top == null;
        }

        // method to return the number of frames
        public int size() {
            return size;
        }

        // main method to test the class
        public static void main(String[] args) {
            GenStack<Integer> s = new GenStack<>();

            s.push(7);
            s.push(5);
            s.push(3);
            System.out.println("Stack length is " + s.size());
            System.out.println("Stack contains:\n" + s);

            while (! s.isEmpty()) {
                System.out.println("Popped " + s.pop());
            }

            // intentially try to pop an empty stack
            try {
                System.out.println("Popped " + s.pop());
            } catch (EmptyStackException e) {
                System.out.println("That could have been bad!");
            }
        }
    }

    private static class Expr {
        public static void apply(GenStack<Character> os, GenStack<Integer> vs) {

            int	v1, v2, r;
            char	op;

            op = os.pop();
            v2 = vs.pop();
            v1 = vs.pop();

            switch (op) {

                case '+':
                    vs.push(v1 + v2);
                    break;

                case '-':
                    vs.push(v1 - v2);
                    break;

                case '/':
                    vs.push(v1 / v2);
                    break;

                case '*':
                    vs.push(v1 * v2);
                    break;

                case '%':
                    vs.push(v1 % v2);
                    break;
            }
        }

        public static int eval(String s) {

            int	x=0, num;
            GenStack<Character> ostack = new GenStack<Character>();
            GenStack<Integer> vstack = new GenStack<Integer>();
            char c;

            while ( x < s.length()) {
                c = s.charAt(x);
                switch(c) {

                    case '(':
                        ostack.push((char)c);
                        break;

                    case ')':
                        while ( ostack.peek() != '(' )
                            apply(ostack, vstack);
                        ostack.pop();
                        break;

                    case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
                        num = 0;
                        while ( x < s.length() && Character.isDigit(c) ) {
                            num = num * 10 + (c - '0');
                            x++;
                            if ( x < s.length())
                                c = s.charAt(x);
                        }
                        x--;
                        vstack.push(num);
                        break;

                    case '+', '-', '*', '/', '%':
                        if ( !ostack.isEmpty() )
                            while ( !ostack.isEmpty() && prec(ostack.peek()) >= prec(c))
                                apply(ostack, vstack);
                        ostack.push(c);
                        break;

                    case ' ', '\t': break;
                }
                x++;
            }
            while ( ! ostack.isEmpty() )
                apply(ostack, vstack);

            return vstack.pop();
        }

        public static int prec (char c) {

            switch (c) {

                case '+', '-': return(0);
                case '*', '/', '%': return(1);
                case '(': return(-1);
            }

            return (-1);
        }
    }

    private static class SrcLine {
        String line;
        byte[] parsed;

        SrcLine(String line) {
            this.line = line;
            Tokenizer t = new Tokenizer(line);
            this.parsed = t.scanTokens();
        }
    }

    private static TreeMap<Integer, SrcLine> Source;


    private static void handleLine(String line) {
        //if (line == null || line.isEmpty()) return false;
        int x = 0;
        while (x < line.length() && Character.isDigit(line.charAt(x))) x++;
        int lineNo = Integer.parseInt(line.substring(0, x));
        // empty line number - remove line from program
        if (x == line.length())
            Source.remove(lineNo);
        else if (Source.get(lineNo) != null)
            // if line exists, update the line
            Source.replace(lineNo, new SrcLine(line.substring(x).trim()));
        else
            // new line
            Source.put(lineNo, new SrcLine(line.substring(x).trim()));
    }


    private static class Program {

    }

    private static class Tokenizer {
        private StringBuffer source;
        static Map<String, Byte> keywords = new HashMap<>();
        static String[] commands;
        byte[] code = new byte[38913]; // 38911 basic byte free!
        private int start = 0; // start of the code section being tokenized
        private int current = 0; // current position >= start
        private int cidx = 0; // code index
        private int nexti;    // where to put index of next tokenized lineNo
        //private int lineNo = 1;
        private boolean LINENO; // looking for a lineNo number?

        // Tokenizer constructor
        private Tokenizer(String source) {
            this.source = new StringBuffer(source);
            // load the HashMaps
            populateKeywords();

            // First two bytes are the starting address on C64
            code[cidx++] = (byte) (0x01);
            code[cidx++] = (byte) (0x08);
            nexti = cidx;
            //cidx += 2; // leave 2 bytes for address link to next lineNo
        }

        private byte[] tokenizeLine(String line) {
            this.source = new StringBuffer(line);
            start = 0;
            current = 0;
            return scanTokens();
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
/* Removed from original code to avoid adding pointers to tokenization.

                case '\n':
                case '\r':
                    // mark end of tokenized lineNo
                    addToken((byte) 0);
                    int pos = cidx - 2 + 0x0801;
                    //System.out.printf("cidx = 0x%04X, pos = 0x%04x%n", cidx, pos);
                    // replace previous link with new address.
                    code[nexti] = (byte) (pos & 0xff);
                    code[nexti + 1] = (byte) ((pos & 0xff00) >> 8);
                    LINENO = true;
                    break; // fixup!
*/
                // if it's not special, bring it along.
                default:
                    if (isDigit(c) && LINENO) {
                        nexti = cidx;
                        cidx += 2; // leave room for the next pointer
                        number();
                        while (peek() == ' ') advance(); // consume space(s) after lineNo number
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
                    current = start + c.length(); // adjust lineNo
                    // if it's a REM, special handling to end of lineNo.
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

    private static void printError(int code, int line) {
        System.err.print(ERRORS64[code] + " ERROR");
        if (line != -1) {
            System.err.print(" in line " + line);
        }
    }

    public static void main(String[] args) {
        Source = new TreeMap<>();

        if (args.length != 0) {
            // FIXME process args
            System.out.println("\nCommand line arguments not yet implemented.\n");
        } else {
            // Interactive!
            Scanner kb = new Scanner(System.in);
            System.out.println("\nREADY.");
            while (kb.hasNext()) {
                String line = kb.nextLine().strip();
                // nothing to do with a blank line
                if (line.length() == 0) continue;

                // true == program line including line number
                if (!preProcess(line)) {
                    processCommand(line);
                    System.out.println("\nREADY.");
                } else {
                    handleLine(line);
                }
            }
        }
    }

    private static boolean preProcess(String line) {
        return line != null && !line.isEmpty() && Character.isDigit(line.charAt(0));
    }

    private static void processCommand(String line) {
        int b = -1, e = MAXLINENUM;
        String l = line.toUpperCase().strip();
        switch (l) {
            case String s when s.startsWith("LIST") -> {
                String t = l.substring(4).strip();
                if (!t.isEmpty()) {
                    if (t.indexOf('-') != -1) {
                        String[] parts = t.split("-");
                        System.out.println(parts.length);
                        System.out.println(parts);
                    } else {
                        try {
                            b = Integer.parseInt(t);
                            e = b;
                        } catch (Exception ex) {
                            printError(11, -1);
                            return;
                        }
                    }
                }
                CMDlist(b, e);
            }
            case String s when s.startsWith("RUN") -> {}
            case String s when s.startsWith("CONT") -> {}
            case String s when s.startsWith("LOAD") -> {}
            case String s when s.startsWith("SAVE") -> {}
            case String s when s.startsWith("VERIFY") -> {}
            case String s when s.startsWith("NEW") -> {}
            case String s when s.startsWith("CLR") -> {}
            default -> printError(11, -1); // SYNTAX
        }
    }

    private static void CMDrun(String line) {

    }

    private static void CMDlist(int beg, int end) {
        for (Map.Entry<Integer, SrcLine> t : Source.entrySet()) {
            int l = t.getKey();
            String s = t.getValue().line;
            if (l >= beg && l <= end) {
                System.out.println(t.getKey() + " " + t.getValue().line);
            }
        }
    }

    private static void CMDload(String fn) {

    }

    private static void CMDsave(String fn) {

    }

    private static void CMDverify(String fn) {

    }
}
