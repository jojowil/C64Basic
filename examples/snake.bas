0 poke53265,peek(53265)and239:poke53281,.:poke53280,.
1 dimx(255):dimy(255):s=54276
2 gosub980
3 c=55548:w=13:h=7:t=9:f=4:l=4:n=1:g=1:p=.:a=600
4 dx=1:dy=.:x=3:y=.:hp=l:tp=.:fori=.tol:x(i)=i:next:e=.:poke53265,peek(53265)or16
5 getk$:ifk$="w"thenifdx<>.thendy=-40:dx=.
6 ifk$="s"thenifdx<>.thendy=40:dx=.
7 ifk$="a"thenifdy<>.thendy=.:dx=-1
8 ifk$="d"thenifdy<>.thendy=.:dx=1
10 ifnthenfp=c+int(rnd(.)*16)+(int(rnd(.)*16)*40):if(peek(fp)and15)=.thenn=.:pokefp,f
20 x(hp)=x:y(hp)=y:hp=hp+1:ifhp>lthenhp=.
25 pokec+x(tp)+y(tp),.:tp=tp+1
27 iftp>lthentp=.:ife>.thenl=l+1:e=e-1:x(l)=x(tp):y(l)=y(tp):tp=l
30 pokec+x+y,w:pokec+x(tp)+y(tp),t:x=x+dx:ifx>15thenx=.
35 ifx<.thenx=15
40 y=y+dy:ify>atheny=.
45 ify<.theny=a
50 z=peek(c+x+y)and15:ifz<>.thenifz<>ftheng=2
55 pokec+x+y,h:ifint(fp)=int(c+x+y)thenn=1:e=e+1:p=p+1:?"{home}{down}{down}{down}{down}{down}{down}{down}{right}{right}{right}";p
65 pokes,48:pokes,49
99 onggoto5,100
100 fori=1tol:pokec+x(tp)+y(tp),2:tp=tp+1:iftp>lthentp=0
101 ford=0to9:next:next
199 stop
980 ?"{clear}{down}","{right}{right}{right}{reverse on}{pink}{169}{reverse off}{yellow}{169}{right}{reverse on}{127}{right}{right}{cyan}{169}{light gray}{127}{right}{pink} {reverse off}{169}{right}{reverse on}{yellow} F":?,"{right}{right}{right}{reverse on}{cyan}{169}{reverse off}{purple}{169}{right}{reverse on}{yellow} {light green}{127}{right}{cyan} {light gray} {right}{purple} {127}{right}{light green} {cyan}E"
981 ?"{right}{white}UC{light green}F{yellow}F{cyan}R{green}FF{light blue}CI":?"{right}{light green}B{right}{right}{right}{right}{right}{right}{right}{light blue}B"
982 ?"{right}{yellow}H {light green}s{yellow}c{cyan}W{yellow}r{light green}e {blue}G {white}U{light green}C{yellow}F{cyan}F{pink}F{orange}R{red}RRRRRRRFF{orange}F{pink}C{yellow}I"
983 ?"{right}{cyan}H{right}{right}{right}{right}{right}{right}{right}{blue}G{right}{light green}B",,"{left}{left}{yellow}B":?"{right}{green}H{right}{right}{right}{right}{right}{right}{right}{blue}G{right}{yellow}H",,"{left}{left}{pink}G"
984 ?"{right}{green}B{right}{right}{right}{right}{right}{right}{right}{light blue}B{right}{cyan}H",,"{left}{left}{orange}G":?"{right}{light blue}JCD{blue}DED{light blue}DC{green}K{right}{pink}H",,"{left}{left}{red}G"
985 ?,"{right}{orange}Y",,"{left}{left}{red}T":fori=.to5:?,"{right}Y",,"{left}{left}T":next
986 ?,"{right}Y",,"{left}{left}{orange}T":?,"{right}{red}H",,"{left}{left}{pink}G":?,"{right}{orange}H",,"{left}{left}{cyan}G"
987 ?,"{right}{pink}H",,"{left}{left}{yellow}G":?,"{right}B",,"{left}{left}{light green}B":?,"{right}{yellow}J{pink}C{orange}D{red}DDEEEEEEE{orange}E{pink}D{cyan}D{yellow}D{light green}C{white}K"
988 ?"{home}{down}{down}{down}{down}{down}{black}":fori=.to15:?,"{right}{right}QQQQQQQQQQQQQQQQ":next:?"{white}"
989 pokes+20,15:pokes-4,.:pokes-3,2:pokes+1,18:pokes+2,.
999 return
