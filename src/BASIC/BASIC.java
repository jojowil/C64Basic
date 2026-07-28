package BASIC;

import java.util.Scanner;
import java.util.Map;
import java.util.TreeMap;

public class BASIC {

    private static final int MAXLINENUM = 64999;

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
            "?NEXT WITHOUT FOR", // 10
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
        System.out.print(ERRORS64[code] + " ERROR");
        if (line != -1) {
            System.out.print(" in line " + line);
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
                // after LIST
                String t = l.substring(4).strip();
                if (!t.isEmpty()) {
                    // is there a range?
                    if (t.indexOf('-') != -1) {
                        String[] parts = t.split("-");
                        System.out.println(parts.length);
                        // "LIST -" produces length zero - print them all
                        if (parts.length > 0)
                            try {
                                // LIST -200 or LIST 10-50
                                if (parts.length == 2)
                                    e = Integer.parseInt(parts[1]);
                                // LIST 30 or LIST 30-
                                if (!parts[0].isEmpty())
                                    b = Integer.parseInt(parts[0]);
                            } catch (Exception ex) {
                                printError(11, -1);
                                return;
                            }
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

            case String s when s.startsWith("RUN") -> {
                CMDrun(b);
            }

            case String s when s.startsWith("CONT") -> {
                CMDcont();
            }

            case String s when s.startsWith("LOAD") -> {
                CMDload(l);
            }

            case String s when s.startsWith("SAVE") -> {
                CMDsave(l);
            }

            case String s when s.startsWith("VERIFY") -> {
                CMDverify(l);
            }

            case String s when s.startsWith("NEW") -> {
                CMDnew();
            }

            case String s when s.startsWith("CLR") -> {
                CMDclr();
            }

            default -> {

                printError(11, -1); // SYNTAX
            }
        }
    }

    private static void CMDrun(int beg) {
        if (beg > MAXLINENUM) {
            printError(11, MAXLINENUM); // SYNTAX
            return;
        } else {
            Execute ex = new Execute();
            //ex.run(beg);
        }
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

    private static void CMDclr() {

    }

    private static void CMDnew() {

    }

    private static void CMDcont() {

    }
}
