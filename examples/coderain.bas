0 rem teeny tiny code rain effect
1 printchr$(147):poke646,5:poke53281,0:poke53280,0:a$="{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}"
2 a=int(rnd(0)*24):b=int(rnd(0)*39):c=int(rnd(0)*23-a)
3 print"{home}";left$(a$,a):ford=0toc:printtab(b);chr$(int(rnd(0)*57+33)):next:goto2
