1 ps=828:si=112
2 for x=0 to si-1:read d:poke ps+x,d:next x
3 print"sys828"
4 data 120,169, 73,141, 20,  3,169,  3,141, 21
5 data   3, 88, 96,173,  9,220,205,171,  3,240
6 data  84,141,171,  3,169,103,141, 32,  4,169
7 data   0,141, 32,216,162,  6,169, 99,157, 73
8 data   4,202, 16,250,169,  0,162,  6,157, 33
9 data 216,157, 73,216,202, 16,247,162,  0,160
10 data   2,185,  9,220, 41,127, 72, 74, 74, 74
11 data  74,  9, 48,157, 33,  4,104, 41, 15,  9
12 data  48,232,157, 33,  4,232,136, 16,228,173
13 data  11,220, 41,128,208,  4,169,  1,208,  2
14 data 169, 16,141, 39,  4,173,  8,220, 76, 49
15 data 234,  0
30 rem set clock
40 input "am or pm (one letter)";ap$
50 if ap$<>"a" and ap$<>"p" then 40
60 ap=0:if ap$="p"then ap=128
70 input "hours  (0-12):   ";h
80 if h<0 or h>12 then 70
90 h1%=h/10:h2=h-h1%*10:h3=h1%*16+h2+ap
100 poke 56331,h3
110 input "minutes(0-59): ";m
120 if m<0 or m>59 then 110
130 m1%=m/10:m2=m-m1%*10:m3=m1%*16+m2
140 poke 56330,m3
150 input "seconds(0-59): ";s
160 if s<0 or m>59 then 150
170 s1%=s/10:s2=s-s1%*10:s3=s1%*16+s2
180 poke 56329,s3
190 rem start clock
200 poke 56328,0
210 sys 828
