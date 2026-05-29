10 rem teeny tiny code rain effect
20 printchr$(147):poke646,5:poke53281,0:poke53280,0
30 a=int(rnd(0)*22):b=int(rnd(0)*39):c=int(rnd(0)*22-a)
40 print"{home}":ford=1toa:printtab(b);chr$(32):next
50 ford=0toc:printtab(b);chr$(int(rnd(0)*57+33)):next
60 ifc<0or(a+c)>20goto30
70 e=21-(a+c):ford=1toe:printtab(b);chr$(32):next:goto30
