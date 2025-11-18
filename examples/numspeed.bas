10 l=2000:dim a(l),b%(l)
15 ?"randomizing numbers"
20 x=rnd(time):for x=1tol:r=rnd(1)*10000:a(x)=r:b%(x)=int(r):next
30 t=0:t%=0
35 ?"summing reals"
40 b=time:for x=1tol:t=t+a(x):next:e=time:printt,e-b
45 ?"summing ints"
50 t=0:b=time:for x=1tol:t=t+b%(x):next:e=time:printt,e-b
