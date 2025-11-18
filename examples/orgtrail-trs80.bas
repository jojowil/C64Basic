1 pe$="press <enter> to continue"
2 ph=int((rnd(0)*100)+1)
3 if ph<51 then dh=51
4 if ph>50 then dh=34
5 dim s$(4)
6 s$(1)="bang"
7 s$(2)="blam"
8 s$(3)="pow"
9 s$(4)="wham"
10 print "do you need instructions"
11 print "(yes/no)";
12 c$="yes/no"
13 input c$
14 if c$="no" then 43
15 print
16 print "this program simulates a 2,040"
17 print "mile trip over the oregon trail"
18 print "from independence, mo to"
19 print "oregon city, or in 1847."
20 print: print pe$: input ct$: print
21 print "you've saved $700 to spend for"
22 print "the trip. you will need to"
23 print "purchase the following"
24 print "supplies:"
25 print
26 print "  * oxen (spend $200-$300)"
27 print "  * food"
28 print "  * ammunition"
29 print "  * clothing"
30 print "  * misc. supplies"
31 print: print pe$: input ct$: print
32 print "you can spend all your money"
33 print "now, or save some for along"
34 print "the way"
35 print: print pe$: input ct$: print
36 rem x
37 print "whenever you have to use your"
38 print "rifle, you will be asked to"
39 print "type in a word (one that sounds"
40 print "like a gunshot). then press"
41 print "<enter> to fire."
42 print: print pe$: input ct$: print
43 d9=1
44 if d9>5 then 46
45 goto 47
46 d9=d3=m9=m=f2=f1=s4=k8=0
47 x1=-1
48 print
49 z9$="how much do you want to spend"
50 print z9$: print "on your oxen team"
51 input a
52 if a >= 200 then 55
53 print "not enough"
54 goto 50
55 if a <= 300 then 58
56 print "too much"
57 goto 50
58 print z9$: print "on food"
59 input f
60 if f >= 0 then 63
61 print "impossible"
62 goto 58
63 print z9$: print "on ammunition"
64 input b
65 if b >= 0 then 68
66 print "impossible"
67 goto 63
68 print z9$: print "on clothing"
69 input c
70 if c >= 0 then 73
71 print "impossible"
72 goto 68
73 print z9$: print "on miscellaneous supplies"
74 input m1
75 if m1 >= 0 then 78
76 print "impossible"
77 goto 73
78 t=700-a-f-b-c-m1
79 if t >= 0 then 82
80 print "you overspent--you only had": print "$700 to spend.  buy again"
81 goto 48
82 b=50*b
83 print "after all your purchases. you": print "now have ";t;" dollars left"
84 print
85 print "mon mar 29 1847"
86 print
87 goto 121
88 if m >= 2040 then 481
89 print: print pe$: input ct$: print
90 d3=d3+1
91 print
92 print "mon ";
93 if d3>10 then 95
94 on d3 goto 97, 98, 99, 100, 101, 102, 103, 104, 105, 106
95 on d3-10 goto 107, 108, 109, 110, 111, 112, 113, 114, 115, 116
96 yr$="1847"
97 print "apr 12 "yr$: goto 120
98 print "apr 26 "yr$: goto 120
99 print "may 10 "yr$: goto 120
100 print "may 24 "yr$: goto 120
101 print "jun 7 "yr$: goto 120
102 print "jun 21 "yr$: goto 120
103 print "jul 5 "yr$: goto 120
104 print "jul 19 "yr$: goto 120
105 print "aug 2 "yr$: goto 120
106 print "aug 16 "yr$: goto 120
107 print "aug 31 "yr$: goto 120
108 print "sep 13 "yr$: goto 120
109 print "sep 27 "yr$: goto 120
110 print "oct 11 "yr$: goto 120
111 print "oct 25 "yr$: goto 120
112 print "nov 8 "yr$: goto 120
113 print "nov 22 "yr$: goto 120
114 print "dec 6 "yr$: goto 120
115 print "dec 20 "yr$: goto 120
116 print "you have been on the trail too"
117 print "long--- your family dies in the"
118 print "first blizzard of winter"
119 goto 468
120 print
121 if f >= 0 then 123
122 f=0
123 if b >= 0 then 125
124 b=0
125 if c >= 0 then 127
126 c=0
127 if m1 >= 0 then 129
128 m1=0
129 if f >= 13 then 131
130 print "you'd better do some hunting or": print "buy food and soon!!!!"
131 f=int(f)
132 b=int(b)
133 c=int(c)
134 m1=int(m1)
135 t=int(t)
136 m=int(m)
137 m2=m
138 if s4=1 then 141
139 if k8=1 then 141
140 goto 146
141 t=t-20
142 if t<0 then 459
143 print "doctor's bill is $20"
144 s4=0
145 k8=s4
146 if m9=1 then 149
147 print "total mileage: ";m
148 goto 151
149 print "total mileage: 950"
150 m9=0
151 print "food: ";f
152 print "bullets: ";b
153 print "clothing: ";c
154 print "misc. supplies: ";m1
155 print "cash: $";t
156 print
157 if x1=-1 then 167
158 x1=x1*(-1)
159 print "do you want to:"
160 print "  (1) stop at the next fort"
161 print "  (2) hunt"
162 print "  (3) continue"
163 input x
164 goto 179
165 x=3
166 goto 179
167 print "do you want to:"
168 print "  (1) hunt"
169 print "  (2) continue"
170 input x
171 if x=1 then 173
172 x=2
173 x=x+1
174 if x=3 then 178
175 if b>39 then 178
176 print "tough---you need more bullets": print "to go hunting"
177 goto 167
178 x1=x1*(-1)
179 on x goto 180,204,221
180 print "enter what you wish to spend on": print "the following..."
181 print "food";
182 gosub 184
183 goto 192
184 input p
185 if p<0 then 191
186 t=t-p
187 if t >= 0 then 191
188 print "you don't have that much--keep": print "your spending down"
189 t=t+p
190 p=0
191 return
192 f=f+2/3*p
193 print "ammunition";
194 gosub 184
195 b=int(b+2/3*p*50)
196 print "clothing";
197 gosub 184
198 c=c+2/3*p
199 print "miscellaneous supplies";
200 gosub 184
201 m1=m1+2/3*p
202 m=m-45
203 goto 221
204 if b>39 then 207
205 print "tough---you need more bullets": print "to go hunting"
206 goto 159
207 m=m-45
208 gosub 537
209 if b1 <= 3 then 215
210 if 100+rnd(0)<13*b1 then 220
211 f=f+48-2*b1
212 print "nice shot--right on target--good": print "eatin' tonight!!"
213 b=b-10-3*b1
214 goto 221
215 print "right between the eyes---you"
216 print "got a big one! full bellies": print "tonight!": print
217 f=f+52+rnd(0)*6
218 b=b-10-rnd(0)*4
219 goto 221
220 print "you missed---and your dinner": print "got away.....": print
221 if f >= 13 then 223
222 goto 457
223 print "do you want to eat:"
224 print "  (1) poorly"
225 print "  (2) moderately"
226 print "  (3) well"
227 input e
228 if e>3 then 223
229 if e<1 then 223
230 e=int(e)
231 f=f-8-5*e
232 if f >= 0 then 236
233 f=f+8+5*e
234 print "you can't eat that well"
235 goto 223
236 m=m+200+(a-220)/5+10*rnd(0)
237 c1=0
238 l1=c1
239 if rnd(0)*10>((m/100-4)*(m/100-4)+72)/((m/100-4)*(m/100-4)+12)-1 then 308
240 print
241 print "riders ahead. they ";
242 s5=0
243 if rnd(0)<.8 then 246
244 print "don't ";
245 s5=1
246 print "look": print "hostile": print
247 print "tactics:"
248 print "  (1) run"
249 print "  (2) attack"
250 print "  (3) continue"
251 print "  (4) circle wagons"
252 if rnd(0)>.2 then 254
253 s5=1-s5
254 input t1
255 if t1<1 then 248
256 if t1>4 then 248
257 t1=int(t1)
258 if s5=1 then 287
259 if t1>1 then 265
260 m=m+20
261 m1=m1-15
262 b=b-150
263 a=a-40
264 goto 301
265 if t1>2 then 278
266 gosub 537
267 b=b-b1*40-80
268 if b1>1 then 271
269 print "nice shooting--- you drove them": print "off": print
270 goto 301
271 if b1 <= 4 then 276
272 print "lousy shot---you got knifed"
273 k8=1
274 print "you have to see ol' doc": print "blanchard": print
275 goto 301
276 print "kinda slow with your colt .45": print
277 goto 301
278 if t1>3 then 283
279 if rnd(0)>.8 then 299
280 b=b-150
281 m1=m1-15
282 goto 301
283 gosub 537
284 b=b-b1*30-80
285 m=m-25
286 goto 268
287 if t1>1 then 291
288 m=m+15
289 a=a-10
290 goto 301
291 if t1>2 then 295
292 m=m-5
293 b=b-100
294 goto 301
295 if t1>3 then 297
296 goto 301
297 m=m-20
298 goto 301
299 print "they did not attack"
300 goto 308
301 if s5=0 then 304
302 print: print "riders were friendly, but check": print "for possible losses": print
303 goto 308
304 print: print "riders were hostile--check for": print "loses": print
305 if b >= 0 then 308
306 print: print "you ran out of bullets and got": print "massacred by the riders": print
307 goto 468
308 d1=0
309 restore
310 r1=100*rnd(0)
311 d1=d1+1
312 if d1=16 then 420
313 read d
314 if r1>d then 311
315 data 6,11,13,15,17,22,32,35,37,42,44,54,64,69,95
316 if d1>10 then 318
317 on d1 goto 319,323,327,333,336,339,342,349,356,372
318 on d1-10 goto 375,382,387,409,414,420
319 print: print "wagon breaks down--lose time": print "and supplies fixing it": print
320 m=m-15-5*rnd(0)
321 m1=m1-8
322 goto 423
323 print: print "0x injures leg---slows you down": print "rest of trip": print
324 m=m-25
325 a=a-20
326 goto 423
327 print: print "bad luck---your daughter broke"
328 print "her arm. you had to stop and"
329 print "use supplies to make a sling.": print
330 m=m-5-4*rnd(0)
331 m1=m1-2-3*rnd(0)
332 goto 423
333 print: print "ox wanders off---spend time": print "looking for it": print
334 m=m-17
335 goto 423
336 print: print "your son gets lost---spend": print "half the day looking for him": print
337 m=m-10
338 goto 423
339 print: print "unsafe water--lose time looking": print "for clean spring": print
340 m=m-10*rnd(0)-2
341 goto 423
342 if m>950 then 402
343 print: print "heavy rains---time and supplies": print "lost": print
344 f=f-10
345 b=b-500
346 m1=m1-15
347 m=m-10*rnd(0)-5
348 goto 423
349 print: print "bandits attack": print
350 gosub 552
351 b=b-20*b1
352 if b >= 0 then 356
353 print: print "you ran out of bullets---they": print "get lots of cash": print
354 t=t/3
355 goto 357
356 if b1 <= 1 then 363
357 print: print "you got shot in the leg and": print "they took one of your oxen": print
358 k8=1
359 print: print "better have a doc look at your": print "wound": print
360 m1=m1-5
361 a=a-20
362 goto 423
363 print: print "quickest draw outside of dodge"
364 print "city!!! you got 'em!": print
365 goto 423
366 print: print "there was a fire in your wagon,": print "food and supplies damage!": print
367 f=f-40
368 b=b-400
369 m1=m1-rnd(0)*8-3
370 m=m-15
371 goto 423
372 print: print "lose your way in heavy fog,": print "time is lost": print
373 m=m-10-5*rnd(0)
374 goto 423
375 print: print "you killed a poisonous snake": print "after it bit you": print
376 b=b-10
377 m1=m1-5
378 if m1 >= 0 then 381
379 print: print "you die of snakebite since you": print "have no medicine": print
380 goto 468
381 goto 423
382 print: print "wagon gets swamped fording": print "river--lose food and clothes": print
383 f=f-30
384 c=c-20
385 m=m-20-20*rnd(0)
386 goto 423
387 print: print "wild animals attack!": print
388 gosub 552
389 if b>39 then 394
390 print: print "you were too low on bullets--"
391 print "the wolves overpowered you": print
392 k8=1
393 goto 463
394 if b1>2 then 397
395 print: print "nice shootin' pardner---they": print "didn't get much": print
396 goto 398
397 print: print "slow on the draw---they got at": print "your food and clothes": print
398 b=b-20*b1
399 c=c-b1*4
400 f=f-b1*8
401 goto 423
402 print: print "cold weather---brrrrrrr!---you"
403 if c>22+4*rnd(0) then 406
404 print "dont't ";
405 c1=1
406 print "have enough clothing to keep": print "you warm": print
407 if c1=0 then 423
408 goto 568
409 print: print "hail storm---supplies damaged": print
410 m=m-5-rnd(0)*10
411 b=b-200
412 m1=m1-4-rnd(0)*3
413 goto 423
414 if e=1 then 568
415 if e=3 then 418
416 if rnd(0)>.25 then 568
417 goto 423
418 if rnd(0)<.5 then 568
419 goto 423
420 print: print "helpful indians show you where": print "to find more food": print
421 f=f+14
422 goto 423
423 if m <= 950 then 88
424 if rnd(0)*10>9-((m/100-15)*(m/100-15)+72)/((m/100-15)*(m/100-15)+12) then 438
425 print: print "rugged mountains": print
426 if rnd(0)>.1 then 430
427 print: print "you got lost---lose valuable": print "time trying to find trail!": print
428 m=m-60
429 goto 438
430 if rnd(0)>.11 then 436
431 print: print "wagon damaged!---lose time and": print "supplies": print
432 m1=m1-5
433 b=b-200
434 m=m-20-30*rnd(0)
435 goto 438
436 print: print "the going gets slow": print
437 m=m-45-rnd(0)/.02
438 if f1=1 then 442
439 f1=1
440 if rnd(0)<.8 then 449
441 print: print "you made it safely through": print "south pass--no snow": print
442 if m<1700 then 446
443 if f2=1 then 446
444 f2=1
445 if rnd(0)<.7 then 449
446 if m>950 then 88
447 m9=1
448 goto 88
449 print: print "blizzard in mountain pass--time": print "and supplies lost": print
450 l1=1
451 f=f-25
452 m1=m1-10
453 b=b-300
454 m=m-30-40*rnd(0)
455 if c<18+2*rnd(0) then 568
456 goto 446
457 print: print "you ran out of food and starved": print "to death": print
458 goto 468
459 t=0
460 print: print "you can't afford a doctor"
461 goto 463
462 print: print "you ran out of medical supplies"
463 print "you died of ";
464 if k8=1 then 467
465 print "pneumonia..."
466 goto 468
467 print "injuries..."
468 print: print pe$: input ct$: print
469 print "dear intrepid traveler,"
470 print
471 print "we are deeply saddened that"
472 print "you didn't make it to the great"
473 print "territory of oregon. better"
474 print "luck next time."
475 print
476 print "sincerely,"
477 print
478 print "the oregon city"
479 print "chamber of commerce"
480 end
481 f9=(2040-m2)/(m-m2)
482 f=f+(1-f9)*(8+5*e)
483 print: print "you finally arrived in oregon!"
484 print: print pe$: input ct$: print
485 goto 529
486 f9=int(f9*14)
487 d3=d3*14+f9
488 f9=f9+1
489 if f9<8 then 573
490 f9=f9-7
491 if d3>124 then 495
492 d3=d3-93
493 print "jul ";d3;" 1847"
494 goto 513
495 if d3>155 then 499
496 d3=d3-124
497 print "aug ";d3;" 1847"
498 goto 513
499 if d3>185 then 503
500 d3=d3-155
501 print "sep ";d3;" 1847"
502 goto 513
503 if d3>216 then 507
504 d3=d3-185
505 print "oct ";d3;" 1847"
506 goto 513
507 if d3>246 then 511
508 d3=d3-216
509 print "nov ";d3;" 1847"
510 goto 513
511 d3=d3-246
512 print "dec ";d3;" 1847"
513 print
514 if b>0 then 516
515 b=0
516 if c>0 then 518
517 c=0
518 if m1>0 then 520
519 m1=0
520 if t>0 then 522
521 t=0
522 if f>0 then 524
523 f=0
524 print "food: ";int(f)
525 print "bullets: ";int(b)
526 print "clothing: ";int(c)
527 print "misc. supp.: ";int(m1)
528 print "cash: ";int(t)
529 print
530 print "president james k. polk sends"
531 print "you his heartiest"
532 print "congratulations and wishes you"
533 print "a prosperous life ahead at your"
534 print "new home"
535 end
536 print
537 s6=int(rnd(0)*4+1)
538 print "type "; s$(s6)
539 b3=30000
540 input c$
541 b4=(rnd(0)*100)+1
542 if b4<dh then b1=b3+0
543 if b4<dh then 545
544 b1=b3+15
545 b1=((b1-b3)*3600)
546 print
547 if b1>0 then 549
548 b1=0
549 if c$=s$(s6) then 551
550 b1=9
551 return
552 rem x
553 s6=int(rnd(0)*4+1)
554 print "type "; s$(s6)
555 b3=30000
556 input c$
557 b4=rnd(0)*100+1
558 if b4<86 then b1=b3+0
559 if b4<86 then 561
560 b1=b3+15
561 b1=((b1-b3)*3600)
562 print
563 if b1>0 then 565
564 b1=0
565 if c$=s$(s6) then 567
566 b1=9
567 return
568 if 100*rnd(0)<10+35*(e-1) then 578
569 if e=1 then e2=40/1
570 if e=2 then e2=40/4
571 if e=3 then e2=40/16
572 if 100*rnd(0)<100-(e2) then 582
573 print: print "serious illness, you must"
574 print "stop for medical attention": print
575 m1=m1-10
576 s4=1
577 goto 585
578 print: print "wild illness, medicine used": print
579 m=m-5
580 m1=m1-2
581 goto 585
582 print: print "bad illness, medicine used": print
583 m=m-5
584 m1=m1-5
585 if m1<0 then 462
586 if l1=1 then 446
587 goto 423
588 end