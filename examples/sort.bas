10 rem shell sort in c64 basic
20 l=20:rem length
30 dim a(l)
100 rem populate the array
105 for x=1tol:read d:a(x)=d:next
110 ?:?"before shell sort:"
115 for x=1 to l:print a(x);:next:print
120 b = time:gosub 200:e = time:d=e-b
125 ?:?"after shell sort:"
130 for x=1 to l:print a(x);:next:print
135 ?:?"time was ";d/60;" seconds"
140 restore:for x=1tol:read d:a(x)=d:next
145 ?:?"before bubble sort:"
150 for x=1 to l:print a(x);:next:print
155 b = time:gosub 300:e = time:d=e-b
160 ?:?"after bubble sort:"
165 for x=1 to l:print a(x);:next:print
170 ?:?"time was ";d/60;" seconds"
199 end
200 rem shell sort. g% is the gap size
205 g%=l/2
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
315 if a(x) >= a(x-1) then 325
320 sw=1:t = a(x):a(x)=a(x-1):a(x-1)=t
325 next
330 if sw=1 then 305
399 return
400 data 2, 21, 27, 35, 10, 25, 47, 45, 37, 19
410 data 15, 50, 16, 12, 0, 42, 44, 6, 20, 9
