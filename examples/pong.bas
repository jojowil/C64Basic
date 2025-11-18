1000 rem state initialization
1005 b=1024:rem base screen memory
1010 x=0
1015 y%=rnd(0)*23+1
1020 y=y%
1030 dx=1
1040 dy=1
1050 p=10
1100 print chr$(147)
2000 rem ball movement
2010 poke ((y*40)+x)+b,32
2020 x=x+dx
2030 y=y+dy
2031 if (x=0) and (y<p) then goto 3000
2032 if (x=0) and (y>(p+4)) then goto 3000
2040 if x=40 then dx=-1
2050 if x=40 then x=38
2060 if x<1 then dx=1
2070 if x<1 then x=1
2080 if y=25 then dy=-1
2090 if y=25 then y=23
2100 if y<0 then dy=1
2110 if y<0 then y=1
2200 poke ((y*40)+x)+b,81
2500 rem moving a paddle
2510 k$=""
2520 k=0
2530 get k$
2540 if k$<>"" then k=asc(k$)
2550 if k=145 then p=p-1
2560 if k=17 then p=p+1
2561 if p<0 then p=0
2562 if p>20 then p=20
2570 if p>0 then poke ((p-1)*40)+b,32
2571 poke ((p+0)*40)+b,160
2572 poke ((p+1)*40)+b,160
2573 poke ((p+2)*40)+b,160
2574 poke ((p+3)*40)+b,160
2575 poke ((p+4)*40)+b,160
2576 if p<20 then poke ((p+5)*40)+b,32
2580 goto 2000
3000 rem game over
3010 print chr$(147);
3020 s=0
3030 s=s+1
3040 print "               game over"
3050 if s<25 then goto 3030
3060 print chr$(147)
