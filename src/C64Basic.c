
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include "git-banned.h"

static unsigned char *scanTokens(int *len);

static void scanToken();

static void command();

static void number();

static void string();

static char keycode();

static char peek();

static int isDigit(char c);

static int isAlpha(char c);

static int isAtEnd();

static char advance();

static void addByteToken(char b);

static void addIntToken(int i);

static void addStrToken(const char *s);

static char petscii(char c);

static long myatol(const char *buf);

static void hexDump(const unsigned char *bytes, long length);

static void writeProgram(const char *fname, const unsigned char *program, int len);

static char *readAllBytes(const char *fname, long *len);

// Yeah, there's a lot of globals... so?
char *source;
int srcLen;
int start = 0; // start of the code section being tokenized
int current = 0; // current position >= start
int cidx = 0; // code index
int nexti; // where to put index of next tokenized line
unsigned char code[38913]; // 38911 basic byte free!
bool LINENO; // looking for a line number?

// keyword/keycode struct.
typedef struct {
    char *name;
    unsigned char val;
} Keyword;

// Set keywords and calculate length
Keyword keywords[] = {
    {"end", 0x80},
    {"for", 0x81},
    {"next", 0x82},
    {"data", 0x83},
    {"input#", 0x84},
    {"input", 0x85},
    {"dim", 0x86},
    {"read", 0x87},
    {"let", 0x88},
    {"goto", 0x89},
    {"run", 0x8a},
    {"if", 0x8b},
    {"restore", 0x8c},
    {"gosub", 0x8d},
    {"return", 0x8e},
    {"rem", 0x8f},
    {"stop", 0x90},
    {"on", 0x91},
    {"wait", 0x92},
    {"load", 0x93},
    {"save", 0x94},
    {"verify", 0x95},
    {"def", 0x96},
    {"poke", 0x97},
    {"print#", 0x98},
    {"print", 0x99},
    {"cont", 0x9a},
    {"list", 0x9b},
    {"clr", 0x9c},
    {"cmd", 0x9d},
    {"sys", 0x9e},
    {"open", 0x9f},
    {"close", 0xa0},
    {"get", 0xa1},
    {"new", 0xa2},
    {"tab(", 0xa3},
    {"to", 0xa4},
    {"fn", 0xa5},
    {"spc(", 0xa6},
    {"then", 0xa7},
    {"not", 0xa8},
    {"step", 0xa9},
    /*
    {"+",0xaa},
    {"-",0xab},
    {"*",0xac},
    {"/",0xad},
    {"↑",0xae},
    */
    {"and", 0xaf},
    {"or", 0xb0},
    /*
    {">",0xb1},
    {"=",0xb2},
    {"<",0xb3},
    */
    {"sgn", 0xb4},
    {"int", 0xb5},
    {"abs", 0xb6},
    {"usr", 0xb7},
    {"fre", 0xb8},
    {"pos", 0xb9},
    {"sqr", 0xba},
    {"rnd", 0xbb},
    {"log", 0xbc},
    {"exp", 0xbd},
    {"cos", 0xbe},
    {"sin", 0xbf},
    {"tan", 0xc0},
    {"atn", 0xc1},
    {"peek", 0xc2},
    {"len", 0xc3},
    {"str$", 0xc4},
    {"val", 0xc5},
    {"asc", 0xc6},
    {"chr$", 0xc7},
    {"left$", 0xc8},
    {"right$", 0xc9},
    {"mid$", 0xca},
    {"go", 0xcb}
};
int keywordLength = sizeof(keywords) / sizeof(keywords[0]);

// Set keycodes and calculate length
Keyword keycodes[] = {
    {"{white}", 0x05},
    {"{return}", 0x0d},
    {"{down}", 0x11},
    {"{reverse on}", 0x12},
    {"{home}", 0x13},
    {"{delete}", 0x14},
    {"{red}", 0x1c},
    {"{right}", 0x1d},
    {"{green}", 0x1e},
    {"{blue}", 0x1f},
    {"{pound}", 0x5c},
    {"{orange}", 0x81},
    {"{black}", 0x90},
    {"{up}", 0x91},
    {"{reverse off}", 0x92},
    {"{clear}", 0x93},
    {"{brown}", 0x95},
    {"{pink}", 0x96},
    {"{dark gray}", 0x97},
    {"{grey}", 0x98},
    {"{light green}", 0x99},
    {"{light blue}", 0x9a},
    {"{light gray}", 0x9b},
    {"{purple}", 0x9c},
    {"{left}", 0x9d},
    {"{yellow}", 0x9e},
    {"{cyan}", 0x9f},
    {"{pi}", 0xff}
};
int keycodeLength = sizeof(keycodes) / sizeof(keycodes[0]);


// Kickoff the token scanning!
static unsigned char *scanTokens(int *len) {
    // First two bytes are the starting address on C64
    code[cidx++] = 0x01;
    code[cidx++] = 0x08;
    nexti = cidx;
    //cidx += 2; // leave 2 bytes for address link to next line

    LINENO = true;
    while (!isAtEnd()) {
        // We are at the beginning of the next lexeme.
        start = current;
        scanToken();
    }
    // At this point, all source code has been processed.
    addIntToken(0); // null pointer at end of program.
    // return only what we need.
    *len = cidx;
    return code;
}

// Find simple tokens and predict larger ones.
static void scanToken() {
    char c = advance();
    switch (c) {
        case '+': addByteToken((char) 0xaa);
            break;
        case '-': addByteToken((char) 0xab);
            break;
        case '*': addByteToken((char) 0xac);
            break;
        case '/': addByteToken((char) 0xad);
            break;
        /*case '↑' : */
        case '^': addByteToken((char) 0xae);
            break;
        case '>': addByteToken((char) 0xb1);
            break;
        case '=': addByteToken((char) 0xb2);
            break;
        case '<': addByteToken((char) 0xb3);
            break;
        case '?': addByteToken((char) 0x99);
            break; // other form of print

        case '"': string();
            break;

        case '\n':
        case '\r':
            // mark end of tokenized line
            addByteToken(0);
            int pos = cidx - 2 + 0x0801;
            //printf("cidx = 0x%04X, pos = 0x%04x\n", cidx, pos);
            // replace previous link with new address.
            code[nexti] = (char) (pos & 0xff);
            code[nexti + 1] = (char) ((pos & 0xff00) >> 8);
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
            else addByteToken(petscii(c));
    }
}

// Build a command token
static void command() {
    //System.out.println("entered command()");
    for (int x = 0; x < keywordLength; x++) {
        const char *c = keywords[x].name;
        if (strstr(source + start, c) == source + start) {
            unsigned char op = keywords[x].val;
            //printf("Found %s, 0x%02x\n", c, op);
            addByteToken(op);
            current = start + (int) strlen(c); // adjust line
            // if it's a REM, special handling to end of line.
            if (op == 0x8f) {
                start = current;
                while (peek() != '\n') advance();
                char *s = strndup(source + start, current - start);
                addStrToken(s);
                free(s);
            }
            return; // matched a keyword, leave.
        }
    }
    // Add raw text that didn't match
    char *s = strndup(source + start, current - start);
    addStrToken(s);
    free(s);
}

// Build a number token
static void number() {
    //System.out.println("entered number()");
    while (isDigit(peek())) advance();
    char *s = strndup(source + start, current - start);
    addIntToken((int) myatol(s));
    free(s);
}

// Build a string token
static void string() {
    //System.out.println("entered string()");
    // Use a local string limited to 255 characters.
    // This is the limit of a single C64 BASIC tokenized line, so...
    char bs[256] = {0};
    int bsp = 0;
    bs[bsp++] = '"'; // remember we already saw this...

    char c = peek();
    // This is different from the Java version because we can't just replace the substring.
    while (c != '"' && !isAtEnd() && bsp < 255) {
        if (c == '\n') break; //
        if (c == '{') {
            // keycode handling is just...messy.
            char kc = keycode();
            bs[bsp++] = kc;
        } else {
            advance();
            bs[bsp++] = c;
        }
        c = peek();
    }
    bs[bsp] = 0; // end the string! possibly redundant.

    // Maybe the closing ". C64 doesn't care about missing close "
    c = peek();
    if (c != '\n' && c != '\r') {
        bs[bsp] = c;
        advance();
    }
    addStrToken(bs);
}

static char keycode() {
    //System.out.println("entered keycode()");
    int s = current;
    unsigned char kc = 0;
    while (peek() != '}' && !isAtEnd()) advance();
    advance(); // consume the }
    char *value = strndup(source + s, current - s);
    printf("%s\n", value);
    //System.out.println("found " + value);
    for (int x = 0; x < keycodeLength; x++) {
        if (strcmp(keycodes[x].name, value) == 0) {
            kc = keycodes[x].val;
            break;
        }
    }
    // Keycodes without words can be decimal values
    if (kc == 0) {
        kc = (char) (myatol(value + 1) & 0xff);
    }
    //System.out.printf("keycode() value = %s, 0x%02X%n", value, kc);
    free(value);
    return kc;
    //current = s;
}

// Look ahead.
static char peek() {
    if (isAtEnd()) return '\0';
    return source[current];
}

static int isDigit(char c) {
    return c >= '0' && c <= '9';
}

static int isAlpha(char c) {
    return (c >= 'A' && c <= 'Z') || (c >= 'a' && c < 'z');
}

static int isAtEnd() {
    return current >= srcLen;
}

static char advance() {
    return source[current++];
}

// Add token as bvte
static void addByteToken(char b) {
    //System.out.printf("Adding byte 0x%02x%n", b);
    code[cidx++] = b;
}

// Add token as int - little endian
static void addIntToken(int i) {
    //System.out.printf("Adding int 0x%04x%n", i);
    code[cidx++] = (char) (i & 0xff);
    code[cidx++] = (char) ((i & 0xff00) >> 8);
}

// Add token as string
static void addStrToken(const char *s) {
    //System.out.printf("Adding string %s%n", s);
    size_t len = strlen(s);
    for (int x = 0; x < len; x++)
        code[cidx++] = petscii(s[x]);
    //code[cidx++] = (byte)s.charAt(x);
}

// Convert to PETSCII
static char petscii(char c) {
    if (c >= 'A' && c <= 'Z') return (char) (c + 32);
    if (c >= 'a' && c <= 'z') return (char) (c - 32);
    return c;
}

// Safe atol()
static long myatol(const char *buf) {
    errno = 0;
    char *p;
    long a = strtol(buf, &p, 10); // also sets ERANGE

    // *p can be '\0' or '\n', but p cannot be buf.
    if (!((!*p || *p == '\n') && p != buf && !errno))
        errno = EINVAL;
    return a;
}

// A Sample hexdump (https://programmingby.design/algorithms/the-hex-dump/)
static void hexDump(const unsigned char *bytes, long length) {
    // we and with 0xff to mask off the bits when sign-extended.
    int st = bytes[1] * 256 + bytes[0];
    printf("%d\n", st);
    int pc = st, c = 0, x;
    char chars[10] = {0};

    for (x = 2; x < length; x++) {
        // make it pretty
        if ((pc - st) % 8 == 0) {
            // chars are built during each iteration, but
            // printed when we reach the end of the line.
            printf(" %s", chars);
            printf("\n%04X:", pc);
            c = 0;
        }
        unsigned char ch = bytes[x];
        // build the chars - only printable chars
        chars[c++] = (ch >= 32 && ch <= 127) ? ch : '.';

        printf(" %02X", bytes[x]);
        pc++;
    }

    // fix final row
    int last = (pc - st) % 8;
    chars[c] = '\0';
    if (last > 0)
        for (x = 0; x < 8 - last; x++)
            printf("   ");
    printf(" %s\n", chars);
}

static void writeProgram(const char *fname, const unsigned char *program, int len) {
    FILE *file = fopen(fname, "w");
    if (file == NULL) {
        perror("Error opening object file");
        return;
    }
    size_t bytesWritten = fwrite(program, 1, len, file);
    if (bytesWritten != len)
        perror("Error writing object file");
    fclose(file);
}

// Read a complete file into memory.
static char *readAllBytes(const char *fname, long *len) {
    // open file
    FILE *file = fopen(fname, "r");
    if (file == NULL) {
        perror("Error opening source file");
        return NULL;
    }

    // get size
    fseek(file, 0, SEEK_END);
    long fileSize = ftell(file);
    rewind(file);

    // get the mem
    char *buffer = (char *) malloc(fileSize * sizeof(char) + 1);

    // Read the entire file into the buffer
    size_t bytesRead = fread(buffer, 1, fileSize, file);
    if (bytesRead != fileSize) {
        perror("Error reading file");
        fclose(file);
        free(buffer);
        *len = 0;
        return NULL;
    }
    // add the terminator
    buffer[fileSize] = '\0';
    *len = fileSize; // be sure to note the size!
    return buffer;
}

int main(int argc, char **argv) {
    // Check for proper number of arguments
    if (argc != 3) {
        printf("\nMust provide source and object.\n");
        exit(3);
    }

    printf("%s\n", argv[1]);
    // Read the file.
    long sl;
    source = readAllBytes(argv[1], &sl);
    srcLen = (int) sl;

    // Send to Tokenizer as String.
    int pl;
    unsigned char *program = scanTokens(&pl);
    free(source);

    // Show hexdump and write the resultant program.
    hexDump(program, pl);
    writeProgram(argv[2], program, pl);
}
