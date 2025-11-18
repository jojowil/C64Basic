10 rem program name - oregon        version:01/01/78
20 rem original programming by bill heinemann - 1971
30 rem support research and materials by don ravitsch,
40 rem      minnesota educational computing consortium staff
50 rem cdc cyber 70/73-26     basic 3.1
60 rem documentation booklet 'oregon' available from
61 rem    mecc support services
62 rem    2520 broadway drive
63 rem    st. paul mn 55113
80 rem
150 rem  *for the meaning of the variables used, list lines 6470-6790*
155 rem
160 print "do you need instructions (yes/no)";
170 dim c$(5)
180 rem randomize removed
190 input c$
200 if c$="no" then 690
210 print
220 print
230 rem ***instructions***
240 print "this program simulates a trip over the oregon trail from"
250 print "independence, missouri to oregon city, oregon in 1847."
260 print "your family of five will cover the 2040 mile oregon trail"
270 print "in 5-6 months --- if you make it alive."
280 print
290 print "you had saved $900 to spend for the trip, and you've just"
300 print "   paid $200 for a wagon."
310 print "you will need to spend the rest of your money on the"
320 print "   following items:"
330 print
340 print "     oxen - you can spend $200-$300 on your team"
350 print "            the more you spend, the faster you'll go"
360 print "               because you'll have better animals"
370 print
380 print "     food - the more you have, the less chance there"
390 print "               is of getting sick"
400 print
410 print "     ammunition - $1 buys a belt of 50 bullets"
420 print "            you will need bullets for attacks by animals"
430 print "               and bandits, and for hunting food"
440 print
450 print "     clothing - this is especially important for the cold"
460 print "               weather you will encounter when crossing"
470 print "               the mountains"
480 print
490 print "     miscellaneous supplies - this includes medicine and"
500 print "               other things you will need for sickness"
510 print "               and emergency repairs"
520 print
530 print
540 print "you can spend all your money before you start your trip -"
550 print "or you can save some of your cash to spend at forts along"
560 print "the way when you run low. however, items cost more at"
570 print "the forts. you can also go hunting along the way to get"
580 print "more food."
590 print "whenever you have to use your trusty rifle along the way,"
600 print "you will be told to type in a word (one that sounds like a "
610 print "gun shot). the faster you type in that word and hit the"
620 print """return"" key, the better luck you'll have with your gun."
630 print
640 print "at each turn, all items are shown in dollar amounts"
650 print "except bullets"
660 print "when asked to enter money amounts, don't use a ""$""."
670 print
680 print "good luck!!!"
690 print
700 print
710 print "how good a shot are you with your rifle?"
720 print "  (1) ace marksman,  (2) good shot,  (3) fair to middlin'"
730 print "         (4) need more practice,  (5) shaky knees"
740 print "enter one of the above -- the better you claim you are, the"
750 print "faster you'll have to be with your gun to be successful."
760 input d9
770 if d9>5 then 790
780 goto 810
790 d9=0
800 rem ***initial purchases***
810 x1=-1
820 rem lines 820-829 modified by christopher pedersen (aug 10, 2018)
821 rem for compatibility with the chipmunk basic interpreter
822 rem chipmunk basic: http://www.nicholson.com/rhn/basic/
823 d3=0
824 m9=0
825 m=0
826 f2=0
827 f1=0
828 s4=0
829 k8=0
830 print
840 print
850 print "how much do you want to spend on your oxen team";
860 input a
870 if a >= 200 then 900
880 print "not enough"
890 goto 850
900 if a <= 300 then 930
910 print "too much"
920 goto 850
930 print "how much do you want to spend on food";
940 input f
950 if f >= 0 then 980
960 print "impossible"
970 goto 930
980 print "how much do you want to spend on ammunition";
990 input b
1000 if b >= 0 then 1030
1010 print "impossible"
1020 goto 980
1030 print "how much do you want to spend on clothing";
1040 input c
1050 if c >= 0 then 1080
1060 print "impossible"
1070 goto 1030
1080 print "how much do you want to spend on miscellaneous supplies";
1090 input m1
1100 if m1 >= 0 then 1130
1110 print "impossible"
1120 goto 1080
1130 t=700-a-f-b-c-m1
1140 if t >= 0 then 1170
1150 print "you overspent--you only had $700 to spend.  buy again"
1160 goto 830
1170 b=50*b
1180 print "after all your purchases. you now have ";t;" dollars left"
1190 print
1200 print "monday march 29 1847"
1210 print
1220 goto 1750
1230 if m >= 2040 then 5430
1240 rem ***setting date***
1250 d3=d3+1
1260 print
1270 print "monday ";
1280 if d3>10 then 1300
1290 on d3 goto 1310, 1330, 1350, 1370, 1390, 1410, 1430, 1450, 1470, 1490
1300 on d3-10 goto 1510, 1530, 1550, 1570, 1590, 1610, 1630, 1650, 1670, 1690
1310 print "april 12 ";
1320 goto 1720
1330 print "april 26 ";
1340 goto 1720
1350 print "may 10 ";
1360 goto 1720
1370 print "may 24 ";
1380 goto 1720
1390 print "june 7 ";
1400 goto 1720
1410 print "june 21 ";
1420 goto 1720
1430 print "july 5 ";
1440 goto 1720
1450 print "july 19 ";
1460 goto 1720
1470 print "august 2 ";
1480 goto 1720
1490 print "august 16 ";
1500 goto 1720
1510 print "august 31 ";
1520 goto 1720
1530 print "september 13 ";
1540 goto 1720
1550 print "september 27 ";
1560 goto 1720
1570 print "october 11 ";
1580 goto 1720
1590 print "october 25 ";
1600 goto 1720
1610 print "november 8 ";
1620 goto 1720
1630 print "november 22 ";
1640 goto 1720
1650 print "december 6 ";
1660 goto 1720
1670 print "december 20 ";
1680 goto 1720
1690 print "you have been on the trail too long  ------"
1700 print "your family dies in the first blizzard of winter"
1710 goto 5170
1720 print "1847"
1730 print
1740 rem ***beginning each turn***
1750 if f >= 0 then 1770
1760 f=0
1770 if b >= 0 then 1790
1780 b=0
1790 if c >= 0 then 1810
1800 c=0
1810 if m1 >= 0 then 1830
1820 m1=0
1830 if f >= 13 then 1850
1840 print "you'd better do some hunting or buy food and soon!!!!"
1850 f=int(f)
1860 b=int(b)
1870 c=int(c)
1880 m1=int(m1)
1890 t=int(t)
1900 m=int(m)
1910 m2=m
1920 if s4=1 then 1950
1930 if k8=1 then 1950
1940 goto 1990
1950 t=t-20
1960 if t<0 then 5080
1970 print "doctor's bill is $20"
1980 rem lines 1980-1982 modified by c.d.p. for compatibility with modern basic
1981 let s4=0
1982 let k8=s4
1990 if m9=1 then 2020
2000 print "total mileage: ";m
2010 goto 2040
2020 print "total mileage: 950"
2030 m9=0
2040 rem lines 2040-2050 modified by c.d.p. for compatibility with modern basic
2041 print "food: ";f
2042 print "bullets: ";b
2043 print "clothing: ";c
2044 print "misc. supplies: ";m1
2050 print "cash: $";t
2060 if x1=-1 then 2170
2070 x1=x1*(-1)
2080 print "do you want to (1) stop at the next fort, (2) hunt, ";
2090 print "or (3) continue"
2100 input x
2110 rem if x>2 then 2150
2120 rem if x<1 then 2150
2130 rem let x=int(x)
2140 goto 2270
2150 let x=3
2160 goto 2270
2170 print "do you want to (1) hunt, or (2) continue"
2180 input x
2190 if x=1 then 2210
2200 let x=2
2210 let x=x+1
2220 if x=3 then 2260
2230 if b>39 then 2260
2240 print "tough---you need more bullets to go hunting"
2250 goto 2170
2260 x1=x1*(-1)
2270 on x goto 2290,2540,2720
2280 rem ***stopping at fort***
2290 print "enter what you wish to spend on the following"
2300 print "food";
2310 gosub 2330
2320 goto 2410
2330 input p
2340 if p<0 then 2400
2350 t=t-p
2360 if t >= 0 then 2400
2370 print "you don't have that much--keep your spending down"
2380 t=t+p
2390 p=0
2400 return
2410 f=f+2/3*p
2420 print "ammunition";
2430 gosub 2330
2440 let b=int(b+2/3*p*50)
2450 print "clothing";
2460 gosub 2330
2470 c=c+2/3*p
2480 print "miscellaneous supplies";
2490 gosub 2330
2500 m1=m1+2/3*p
2510 m=m-45
2520 goto 2720
2530 rem ***hunting***
2540 if b>39 then 2570
2550 print "tough---you need more bullets to go hunting"
2560 goto 2080
2570 m=m-45
2580 gosub 6140
2590 if b1 <= 1 then 2660
2600 if 100+rnd(1)<13*b1 then 2710
2610 f=f+48-2*b1
2620 print "nice shot--right on target--good eatin' tonight!!"
2630 b=b-10-3*b1
2640 goto 2720
2650 rem **bells in line 2660**
2660 print "right between the eyes---you got a big one!!!!"
2670 print "full bellies tonight!"
2680 f=f+52+rnd(1)*6
2690 b=b-10-rnd(1)*4
2700 goto 2720
2710 print "you missed---and your dinner got away....."
2720 if f >= 13 then 2750
2730 goto 5060
2740 rem ***eating***
2750 print "do you want to eat (1) poorly  (2) moderately"
2760 print "or (3) well";
2770 input e
2780 if e>3 then 2750
2790 if e<1 then 2750
2800 let e=int(e)
2810 let f=f-8-5*e
2820 if f >= 0 then 2860
2830 f=f+8+5*e
2840 print "you can't eat that well"
2850 goto 2750
2860 let m=m+200+(a-220)/5+10*rnd(1)
2870 rem lines 2870-2872 modified by c.d.p. for compatibility w/ chipmunk basic
2871 c1=0
2872 l1=c1
2880 rem ***riders attack***
2889 rem line 2890 modified by c.d.p. for compatibility with chipmunk basic
2890 if rnd(1)*10>((m/100-4)^2+72)/((m/100-4)^2+12)-1 then 3550
2900 print "riders ahead.  they ";
2910 s5=0
2919 rem all rnd(-1) function calls have been changed to rnd(1) by c.d.p.
2920 if rnd(1)<.8 then 2950
2930 print "don't ";
2940 s5=1
2950 print "look hostile"
2960 print "tactics"
2970 print "(1) run  (2) attack  (3) continue  (4) circle wagons"
2980 if rnd(1)>.2 then 3000
2990 s5=1-s5
3000 input t1
3010 if t1<1 then 2970
3020 if t1>4 then 2970
3030 t1=int(t1)
3040 if s5=1 then 3330
3050 if t1>1 then 3110
3060 m=m+20
3070 m1=m1-15
3080 b=b-150
3090 a=a-40
3100 goto 3470
3110 if t1>2 then 3240
3120 gosub 6140
3130 b=b-b1*40-80
3140 if b1>1 then 3170
3150 print "nice shooting---you drove them off"
3160 goto 3470
3170 if b1 <= 4 then 3220
3180 print "lousy shot---you got knifed"
3190 k8=1
3200 print "you have to see ol' doc blanchard"
3210 goto 3470
3220 print "kinda slow with your colt .45"
3230 goto 3470
3240 if t1>3 then 3290
3250 if rnd(1)>.8 then 3450
3260 let b=b-150
3270 m1=m1-15
3280 goto 3470
3290 gosub 6140
3300 b=b-b1*30-80
3310 m=m-25
3320 goto 3140
3330 if t1>1 then 3370
3340 m=m+15
3350 a=a-10
3360 goto 3470
3370 if t1>2 then 3410
3380 m=m-5
3390 b=b-100
3400 goto 3470
3410 if t1>3 then 3430
3420 goto 3470
3430 m=m-20
3440 goto 3470
3450 print "they did not attack"
3460 goto 3550
3470 if s5=0 then 3500
3480 print "riders were friendly, but check for possible losses"
3490 goto 3550
3500 print "riders were hostile--check for loses"
3510 if b >= 0 then 3550
3520 print "you ran out of bullets and got massacred by the riders"
3530 goto 5170
3540 rem ***selection of events***
3550 let d1=0
3560 restore
3570 r1=100*rnd(1)
3580 let d1=d1+1
3590 if d1=16 then 4670
3600 read d
3610 if r1>d then 3580
3620 data 6,11,13,15,17,22,32,35,37,42,44,54,64,69,95
3630 if d1>10 then 3650
3640 on d1 goto 3660,3700,3740,3790,3820,3850,3880,3960,4130,4190
3650 on d1-10 goto 4220,4290,4340,4560,4610,4670
3660 print "wagon breaks down--lose time and supplies fixing it"
3670 let m=m-15-5*rnd(1)
3680 let m1=m1-8
3690 goto 4710
3700 print "0x injures leg---slows you down rest of trip"
3710 let m=m-25
3720 let a=a-20
3730 goto 4710
3740 print "back luck---your daughter broke her arm"
3750 print "you had to stop and use supplies to make a sling"
3760 m=m-5-4*rnd(1)
3770 m1=m1-2-3*rnd(1)
3780 goto 4710
3790 print "ox wanders off---spend time looking for it"
3800 m=m-17
3810 goto 4710
3820 print "your son gets lost---spend half the day looking for him"
3830 m=m-10
3840 goto 4710
3850 print "unsafe water--lose time looking for clean spring"
3860 let m=m-10*rnd(1)-2
3870 goto 4710
3880 if m>950 then 4490
3890 print "heavy rains---time and supplies lost"
3910 f=f-10
3920 b=b-500
3930 m1=m1-15
3940 m=m-10*rnd(1)-5
3950 goto 4710
3960 print "bandits attack"
3970 gosub 6140
3980 b=b-20*b1
3990 if b >= 0 then 4030
4000 print "you ran out of bullets---they get lots of cash"
4010 t=t/3
4020 goto 4040
4030 if b1 <= 1 then 4100
4040 print "you got shot in the leg and they took one of your oxen"
4050 k8=1
4060 print "better have a doc look at your wound"
4070 m1=m1-5
4080 a=a-20
4090 goto 4710
4100 print "quickest draw outside of dodge city!!!"
4110 print "you got 'em!"
4120 goto 4710
4130 print "there was a fire in your wagon--food and supplies damage!"
4140 f=f-40
4150 b=b-400
4160 let m1=m1-rnd(1)*8-3
4170 m=m-15
4180 goto 4710
4190 print "lose your way in heavy fog---time is lost"
4200 m=m-10-5*rnd(1)
4210 goto 4710
4220 print "you killed a poisonous snake after it bit you"
4230 b=b-10
4240 m1=m1-5
4250 if m1 >= 0 then 4280
4260 print "you die of snakebite since you have no medicine"
4270 goto 5170
4280 goto 4710
4290 print "wagon gets swamped fording river--lose food and clothes"
4300 f=f-30
4310 c=c-20
4320 m=m-20-20*rnd(1)
4330 goto 4710
4340 print "wild animals attack!"
4350 gosub 6140
4360 if b>39 then 4410
4370 print "you were too low on bullets--"
4380 print "the wolves overpowered you"
4390 k8=1
4400 goto 5120
4410 if b1>2 then 4440
4420 print "nice shootin' partner---they didn't get much"
4430 goto 4450
4440 print "slow on the draw---they got at your food and clothes"
4450 b=b-20*b1
4460 c=c-b1*4
4470 f=f-b1*8
4480 goto 4710
4490 print "cold weather---brrrrrrr!---you ";
4500 if c>22+4*rnd(1) then 4530
4510 print "dont't ";
4520 c1=1
4530 print "have enough clothing to keep you warm"
4540 if c1=0 then 4710
4550 goto 6300
4560 print "hail storm---supplies damaged"
4570 m=m-5-rnd(1)*10
4580 b=b-200
4590 m1=m1-4-rnd(1)*3
4600 goto 4710
4610 if e=1 then 6300
4620 if e=3 then 4650
4630 if rnd(1)>.25 then 6300
4640 goto 4710
4650 if rnd(1)<.5 then 6300
4660 goto 4710
4670 print "helpful indians show you where to find more food"
4680 f=f+14
4690 goto 4710
4700 rem ***mountains***
4710 if m <= 950 then 1230
4719 rem line 4720 modified by c.d.p. for compatibility with chipmunk basic
4720 if rnd(1)*10>9-((m/100-15)^2+72)/((m/100-15)^2+12) then 4860
4730 print "rugged mountains"
4740 if rnd(1)>.1 then 4780
4750 print "you got lost---lose valuable time trying to find trail!"
4760 m=m-60
4770 goto 4860
4780 if rnd(1)>.11 then 4840
4790 print "wagon damaged!---lose time and supplies"
4800 m1=m1-5
4810 b=b-200
4820 m=m-20-30*rnd(1)
4830 goto 4860
4840 print "the going gets slow"
4850 m=m-45-rnd(1)/.02
4860 if f1=1 then 4900
4870 f1=1
4880 if rnd(1)<.8 then 4970
4890 print "you made it safely through south pass--no snow"
4900 if m<1700 then 4940
4910 if f2=1 then 4940
4920 f2=1
4930 if rnd(1)<.7 then 4970
4940 if m>950 then 1230
4950 m9=1
4960 goto 1230
4970 print "blizzard in mountain pass--time and supplies lost"
4980 l1=1
4990 f=f-25
5000 m1=m1-10
5010 b=b-300
5020 m=m-30-40*rnd(1)
5030 if c<18+2*rnd(1) then 6300
5040 goto 4940
5050 rem ***dying***
5060 print "you ran out of food and starved to death"
5070 goto 5170
5080 let t=0
5090 print "you can't afford a doctor"
5100 goto 5120
5110 print "you ran out of medical supplies"
5120 print "you died of ";
5130 if k8=1 then 5160
5140 print "pneumonia"
5150 goto 5170
5160 print "injuries"
5170 print
5180 print "due to your unfortunate situation, there are a few"
5190 print "formalities we must go through"
5200 print
5210 print "would you like a minister?"
5220 input c$
5230 print "would you like a fancy funeral?"
5240 input c$
5250 print "would you like us to inform your next of kin?"
5260 input c$
5270 if c$="yes" then 5310
5280 print "but your aunt sadie in st. louis is really worried about you"
5290 print
5300 goto 5330
5310 print "that will be $4.50 for the telegraph charge."
5320 print
5330 print "we thank you for this information and we are sorry you"
5340 print "didn't make it to the great territory of oregon"
5350 print "better luck next time"
5360 print
5370 print
5380 print tab(30);"sincerely"
5390 print
5400 print tab(17);"the oregon city chamber of commerce"
5409 rem 'stop' command below changed to 'end' by c.d.p.
5410 end
5420 rem ***final turn***
5430 f9=(2040-m2)/(m-m2)
5440 f=f+(1-f9)*(8+5*e)
5450 print
5460 rem **bells in lines 5470,5480**
5470 print "you finally arrived at oregon city"
5480 print "after 2040 long miles---hooray!!!!!"
5490 print "a real pioneer!"
5500 print
5510 f9=int(f9*14)
5520 d3=d3*14+f9
5530 f9=f9+1
5540 if f9<8 then 5560
5550 f9=f9-7
5560 on f9 goto 5570,5590,5610,5630,5650,5670,5690
5570 print "monday ";
5580 goto 5700
5590 print "tuesday ";
5600 goto 5700
5610 print "wednesday ";
5620 goto 5700
5630 print "thursday ";
5640 goto 5700
5650 print "friday ";
5660 goto 5700
5670 print "saturday ";
5680 goto 5700
5690 print "sunday ";
5700 if d3>124 then 5740
5710 d3=d3-93
5720 print "july ";d3;" 1847"
5730 goto 5920
5740 if d3>155 then 5780
5750 d3=d3-124
5760 print "august ";d3;" 1847"
5770 goto 5920
5780 if d3>185 then 5820
5790 d3=d3-155
5800 print "september ";d3;" 1847"
5810 goto 5920
5820 if d3>216 then 5860
5830 d3=d3-185
5840 print "october ";d3;" 1847"
5850 goto 5920
5860 if d3>246 then 5900
5870 d3=d3-216
5880 print "november ";d3;" 1847"
5890 goto 5920
5900 d3=d3-246
5910 print "december ";d3;" 1847"
5920 print
5930 rem line 5930 removed by c.d.p. for compatibility with modern basic
5940 if b>0 then 5960
5950 let b=0
5960 if c>0 then 5980
5970 let c=0
5980 if m1>0 then 6000
5990 let m1=0
6000 if t>0 then 6020
6010 let t=0
6020 if f>0 then 6040
6030 let f=0
6040 rem lines 6040-6045 modified by c.d.p. for compatibility with modern basic
6041 print "food: ";f
6042 print "bullets: ";b
6043 print "clothing: ";c
6044 print "misc. supp.: ";m1
6045 print "cash: ";t
6050 print
6060 print tab(11); "president james k. polk sends you his"
6070 print tab(17); "heartiest congratulations"
6080 print
6090 print tab(11);"and wishes you a prosperous life ahead"
6100 print
6110 print tab(22);"at your new home"
6119 rem 'stop' command below changed to 'end' by c.d.p.
6120 end
6130 rem ***shooting sub-routine***
6131 rem the method of timing the shooting (lines 6210-6240)
6132 rem will vary from system to system. for example, h-p
6133 rem users will probably prefer to use the 'enter' statement.
6134 rem if timing on the user's system is highly susceptible
6135 rem to system response time, the formula in line 6240 can
6136 rem be tailored to accommodate this by either increasing
6137 rem or decreasing the 'shooting' time recorded by the system
6140 dim s$(5)
6150 s$(1)="bang"
6160 s$(2)="blam"
6170 s$(3)="pow"
6180 s$(4)="wham"
6190 s6=int(rnd(1)*4+1)
6200 print "type "; s$(s6)
6206 rem 'clk(0)' function changed to 'timer' by c.d.p. for compatibility
6207 rem b3 = timer changed to b3 = timer + 2 by c.d.p. to make hunting...
6208 rem ...easier on modern computers. see notes from original author on
6209 rem ... on tweaking hunting difficulty
6210 b3 = timer + 2
6220 input c$
6229 rem 'clk(0)' function changed to 'timer' by c.d.p. for compatibility
6230 b1 = timer
6240 b1=((b1-b3)*3600)-(d9-1)
6250 print
6255 if b1>0 then 6260
6257 b1=0
6260 if c$=s$(s6) then 6280
6270 b1=9
6280 return
6290 rem ***illness sub-routine***
6300 if 100*rnd(1)<10+35*(e-1) then 6370
6309 rem line 6310 modified by c.d.p. for compatibility with chipmunk basic
6310 if 100*rnd(1)<100-(40/4^(e-1)) then 6410
6320 print "serious illness---"
6330 print "you must stop for medical attention"
6340 m1=m1-10
6350 s4=1
6360 goto 6440
6370 print "wild illness---medicine used"
6380 m=m-5
6390 m1=m1-2
6400 goto 6440
6410 print "bad illness---medicine used"
6420 m=m-5
6430 m1=m1-5
6440 if m1<0 then 5110
6450 if l1=1 then 4940
6460 goto 4710
6470 rem ***identification of variables in the program***
6480 rem a = amount spent on animals
6490 rem b = amount spent on ammunition
6500 rem b1 = actual response time for inputting "bang"
6510 rem b3 = clock time at start of inputting "bang"
6520 rem c = amount spent on clothing
6530 rem c1 = flag for insufficient clothing in cold weather
6540 rem c$ = yes/n0 response to questions
6550 rem d1 = counter in generating events
6560 rem d3 = turn number for setting date
6570 rem d4 = current date
6580 rem d9 = choice of shooting expertise level
6590 rem e = choice of eating
6600 rem f = amount spent on food
6610 rem f1 = flag for clearing south pass
6620 rem f2 = flag for clearing blue mountains
6630 rem f9 = fraction of 2 weeks traveled on final turn
6640 rem k8 = flag for injury
6650 rem l1 = flag for blizzard
6660 rem m = total mileage whole trip
6670 rem m1 = amount spent on miscellaneous supplies
6680 rem m2 = total mileage up through previous turn
6690 rem m9 = flag for clearing south pass in setting mileage
6700 rem p = amount spent on items at fort
6710 rem r1 = random number in choosing events
6720 rem s4 = flag for illness
6730 rem s5 = ""hostility of riders"" factor
6740 rem s6 = shooting word selector
6750 rem s$ = variations of shooting word
6760 rem t = cash left over after initial purchases
6770 rem t1 = choice of tactics when attacked
6780 rem x = choice of action for each turn
6790 rem x1 = flag for fort option
6800 end
