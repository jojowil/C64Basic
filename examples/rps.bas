100 ? rnd(-ti)
110 w=0 : a$ = "" : cc = 0
120 print "{clear}{white}{reverse on}rock, paper, scissors{reverse off}"
125 print : print
130 print "press:"
140 print "1. rock"
150 print "2. paper"
160 print "3. scissors"
170 print : print
180 op$(1) = "rock"
190 op$(2) = "paper"
200 op$(3) = "scissors"
210 print "press the number of your choice"
220 get a$ : if a$ = "" or val(a$) > 3 then 220
230 print "i choose"
240 cc=int(rnd(1)*3)+1
250 print op$(cc)
260 print "{up}{up}{right}{right}{right}{right}{right}{right}{right}{right} you chose"
270 print "{right}{right}{right}{right}{right}{right}{right}{right} "op$(val(a$))
275 print : print
280 print "so the winner is ...";
290 if val(a$)=cc then print "a draw" : goto 350
300 if val(a$)=1 and cc=3 then w=1
310 if val(a$)=2 and cc=1 then w=1
320 if val(a$)=3 and cc=2 then w=1
330 if w=1 then print "you!"
340 if w=0 then print "me!"
345 print : print
350 print "{reverse on}play again? (y/n){reverse off}"
360 get p$ : if p$ <> "y" and p$ <> "n" then 360
370 if p$ <> "n" then 110
380 print "goodbye, thanks for playing"
