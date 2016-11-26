#!/bin/bash

draw_board(){
    clear
    D="-----------------"
    S="%s\n|%3s|%3s|%3s|%3s|\n"
    printf $S $D ${M[0]:-"."} ${M[1]:-"."} ${M[2]:-"."} ${M[3]:-"."}
    printf $S $D ${M[4]:-"."} ${M[5]:-"."} ${M[6]:-"."} ${M[7]:-"."}
    printf $S $D ${M[8]:-"."} ${M[9]:-"."} ${M[10]:-"."} ${M[11]:-"."}
    printf $S $D ${M[12]:-"."} ${M[13]:-"."} ${M[14]:-"."} ${M[15]:-"."}
    echo $D
}

init_game(){
    M=()
    EMPTY=
    RANDOM=$RANDOM
    for i in {1..15}
    do
	j=$(( RANDOM % 16 ))
	while [[ ${M[j]} != "" ]]
	do
	    j=$(( RANDOM % 16 ))
	done
	M[j]=$i
    done
    for i in {0..15}
    do
	[[ ${M[i]} == "" ]] && EMPTY=$i
    done
    draw_board
}

exchange(){
    M[$EMPTY]=${M[$1]}
    M[$1]=""
    EMPTY=$1
}

quit_game(){
    while :
    do
        read -n 1 -s -p "Do you really want to quit [y/n]?"
        case $REPLY in
    	    y|Y) exit
    	    ;;
    	    n|N) return
    	    ;;
        esac
    done
}

check_win(){
    for i in {0..14}
    do
	if [ "${M[i]}" != "$(( $i + 1 ))" ]
	then
	    return
	fi
    done
    echo "You won! Want to play another game [y/n]?"
    while :
    do
        read -n 1 -s
        case $REPLY in
	    y|Y) 
	        init_game
	        break
	    ;;
	    n|N) exit
	    ;;
	esac
    done
}

start_game(){
while :
do
    echo "Use w,a,s,d to move, q for quit"
    read -n 1 -s
    case $REPLY in
	w)
	    [ $EMPTY -lt 12 ] && exchange $(( $EMPTY + 4 ))
	;;
	a)
	    COL=$(( $EMPTY % 4 ))
	    [ $COL -lt 3 ] && exchange $(( $EMPTY + 1 ))
	;;
	s)
	    [ $EMPTY -gt 3 ] && exchange $(( $EMPTY - 4 ))
	;;
	d)
	    COL=$(( $EMPTY % 4 ))
	    [ $COL -gt 0 ] && exchange $(( $EMPTY - 1 ))
	;;
	q)
	    quit_game
	;;
    esac
    draw_board
    check_win
done
}

init_game
start_game
