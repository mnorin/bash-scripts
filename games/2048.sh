#!/bin/bash

# Copyright: Maxim Norin, (c)2016
# Game "2048" written in pure bash with size 2048 (including this text)
# http://mnorin.com
# E-mail: mnorin@mnorin.com

M=()
L=()

align(){
for i in {1..3}
{
for j in {1..3}
{
[ "${L[$j]}" != "" ] && [ "${L[$j-1]}" == "" ] && L[$j-1]=${L[$j]} && L[$j]=""
}
}
}

sum(){
for i in {1..3}
{
[ "${L[$i]}" == "${L[$i-1]}" ] && [ "${L[$i]}" != "" ] && L[$i-1]=$(( ${L[$i]} * 2 )) && L[$i]=""
}
}

sumup(){
align
sum
align
}

left(){
for n in 0 4 8 12
{
L=( ${M[$n]} ${M[$n+1]} ${M[$n+2]} ${M[$n+3]} )
sumup
M[$n]=${L[0]}
M[$n+1]=${L[1]}
M[$n+2]=${L[2]}
M[$n+3]=${L[3]}
}
}

right(){
for n in 0 4 8 12
{
L=( ${M[$n+3]} ${M[$n+2]} ${M[$n+1]} ${M[$n]} )
sumup
M[$n+3]=${L[0]}
M[$n+2]=${L[1]}
M[$n+1]=${L[2]}
M[$n]=${L[3]}
}
}

up(){
for n in 0 1 2 3
{
L=( ${M[$n]} ${M[$n+4]} ${M[$n+8]} ${M[$n+12]} )
sumup
M[$n]=${L[0]}
M[$n+4]=${L[1]}
M[$n+8]=${L[2]}
M[$n+12]=${L[3]}
}
}

down(){
for n in 0 1 2 3
{
L=( ${M[$n+12]} ${M[$n+8]} ${M[$n+4]} ${M[$n]} )
sumup
M[$n+12]=${L[0]}
M[$n+8]=${L[1]}
M[$n+4]=${L[2]}
M[$n]=${L[3]}
}
}

board(){
D="---------------------"
S="%s\n|%4s|%4s|%4s|%4s|\n"
clear
p=printf
echo 2048.bash
echo
$p $S $D ${M[0]:-"."} ${M[1]:-"."} ${M[2]:-"."} ${M[3]:-"."}
$p $S $D ${M[4]:-"."} ${M[5]:-"."} ${M[6]:-"."} ${M[7]:-"."}
$p $S $D ${M[8]:-"."} ${M[9]:-"."} ${M[10]:-"."} ${M[11]:-"."}
$p $S $D ${M[12]:-"."} ${M[13]:-"."} ${M[14]:-"."} ${M[15]:-"."}
echo $D
echo
echo "Moves: w,a,s,d, Quit: q"
}

a2(){
n=$(($RANDOM % 16))
while [ "${M[$n]}" != "" ]
do
n=$(($RANDOM % 16))
done
M[$n]=2
}

setup(){
for i in {0..15}; do M[$i]=""; done
a2
a2
board
}

check(){
F=1
for i in {0..15}
{
[ "${M[$i]}" == "" ] && F=0
}
return $F
}

game.over(){
while [ "$REPLY" != "y" ] && [ "$REPLY" != "n" ]
do
read -n 1 -p "GAME OVER! Play again? (y/n)"
done
case $REPLY in
y) setup; return 1 ;;
n) exit ;;
esac
}

RANDOM=12345

setup

while :
do
read -n 1 -s
case $REPLY in
w) up ;;
a) left ;;
s) down ;;
d) right ;;
q) exit ;;
*) continue ;;
esac

check || game.over || continue
board
sleep 1
a2
board
done