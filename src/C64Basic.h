//
// Created by William Jojo on 11/18/25.
//

#ifndef C64BASIC_C64BASIC_H
#define C64BASIC_C64BASIC_H

unsigned char* scanTokens(int *len);
void scanToken();
void command();
void number();
void string();
char keycode();
char peek();
int isDigit(char c);
int isAlpha(char c);
int isAtEnd();
char advance();
void addByteToken(char b);
void addIntToken(int i);
void addStrToken(const char *s);
char petscii(char c);
long myatol(const char* buf);
void hexDump(const unsigned char *bytes, long length);
void writeProgram(const char *fname, char *program, int len);
char* readAllBytes(const char* fname, long *len);

#endif //C64BASIC_C64BASIC_H