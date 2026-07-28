package BASIC;

public class SrcLine {
    String line;
    byte[] parsed;

    SrcLine(String line) {
        this.line = line;
        Tokenizer t = new Tokenizer(line);
        this.parsed = t.scanTokens();
    }
}
