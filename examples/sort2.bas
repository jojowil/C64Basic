10 rem shell sort in c64 basic
20 l=100:rem length
30 dim a(l), h(l):?:?"randomizing the arrays"
40 r=rnd(ti):for x=1tol:r=int(rnd(1)*1000):a(x)=r:h(x)=r:next
110 ?:?"before shell sort:"
120 gosub 400:b = time:gosub 200:e = time:d=e-b
125 ?:?"after shell sort:":gosub400
135 ?:?"time was ";d/60;" seconds"
145 ?:?"before bubble sort:"
155 gosub 500:b = time:gosub 300:e = time:d=e-b
160 ?:?"after bubble sort:":gosub 500
170 ?:?"time was ";d/60;" seconds"
199 end
200 rem shell sort. g% is the gap size
205 g% = l / 2
210 if g% <= 0 then 299
215 for x = g% to l
220 t = a(x)
225 y = x
230 if y < g% then 245
231 if a(y-g%) <= t then 245
235 a(y) = a(y-g%)
240 y = y - g%:goto 230
245 a(y) = t
250 next x
255 g%=g%/2:goto 210
299 return
300 rem bubble sort
305 sw=0
310 for x=2 to l
315 if h(x) >= h(x-1) then 325
320 sw=1:t = h(x):h(x)=h(x-1):h(x-1)=t
325 next
330 if sw=1 then 305
399 return
400 for i=1 to l:print a(i);:next:?:return
500 for i=1 to l:print h(i);:next:?:return
