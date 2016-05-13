#!/bin/bash
h="1 2 3"
a(){
for i in $h $h $h
{
[ -n "${L[$i]}" ] && [ -z "${L[$i-1]}" ] && L[$i-1]=${L[$i]} && L[$i]=""
}
}
s(){
for i in $h
{
[ "${L[$i]}" == "${L[$i-1]}" ] && [ -n "${L[$i]}" ] && L[$i-1]=$((${L[$i]}*2)) && L[$i]=""
}
}
_(){
for n in $5 $6 $7 $8
{
L=( ${M[$n+$1]} ${M[$n+$2]} ${M[$n+$3]} ${M[$n+$4]} )
a;s;a
M[$n+$1]=${L[0]}
M[$n+$2]=${L[1]}
M[$n+$3]=${L[2]}
M[$n+$4]=${L[3]}
}
}
S="%s\n|%4s|%4s|%4s|%4s|\n"
p=printf
D="---------------------"
e=echo
w="$p $S $D"
q(){
$w ${M[$1]:-"."} ${M[$2]:-"."} ${M[$3]:-"."} ${M[$4]:-"."}
}
m="0 4 8 12"
b(){
clear
for i in $m
{
q $i+{0,1,2,3}
}
$e $D
$e "Moves: w,a,s,d, Quit: q"
}
R(){
n=$(($RANDOM%16))
}
t(){
R
while [ -n "${M[$n]}" ]
do
R
done
M[$n]=2
}
p(){
for i in {0..15}
{
M[$i]=
}
t;t;b
}
c(){
F=1
for i in {0..15}
{
[ -z "${M[$i]}" ] && F=0
}
return $F
}
o(){
until [ "$REPLY" = "y" -o "$REPLY" = "n" ]
do
read -n 1 -p "GAME OVER! Play again? (y/n)"
done
case $REPLY in
y) p; return 1 ;;
n) exit ;;
esac
}
RANDOM=$RANDOM
g="0 1 2 3"
C=continue
p
for ((;;))
{
read -n 1 -s
case $REPLY in
w) _ $m $g ;;
a) _ $g $m ;;
s) _ 12 8 4 0 $g ;;
d) _ {3..0} $m ;;
q) exit ;;
*) $C ;;
esac
c || o || $C
b
sleep 1
t
b
}