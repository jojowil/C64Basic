import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.charset.Charset;
import java.io.IOException;
import java.nio.file.StandardOpenOption;

public class C64Basic {

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
