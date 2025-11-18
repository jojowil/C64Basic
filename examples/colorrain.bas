0 print"{clear}":rem tiny colored code rain effect
1 poke646,int(rnd(0)*16):poke53281,0:poke53280,int(rnd(0)*16):a$="{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}"
2 a=int(rnd(0)*24):b=int(rnd(0)*39):c=int(rnd(0)*23-a)
3 print"{home}";left$(a$,a):ford=0toc:printtab(b);chr$(int(rnd(0)*57+33)):next:goto1
