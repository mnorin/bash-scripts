#!/bin/bash

get_task(){
if [ "$TASK" == "" ]
then
    echo -n "Enter task description: "
    read TASK
fi
}

add_task(){
get_task
sed -i $0 -re "s/(^TASKLISTEND$)/$TASK\n\1/"
$0 show
}

del_task(){
get_task
sed -i $0 -e "/ TASKLISTEND$/,/^TASKLISTEND$/ {/$TASK/d}"
$0 show
}

show_task(){
echo "----------TASK LIST--------"
cat << TASKLISTEND
TASKLISTEND
}

show_help(){
  cat << EOF

Description: script which keeps tasks list (or any other list) inside itself
Usage: $0 [add|show|del]'

Commands:
  add ["task description"]
  del [task description part (will delete any tasks that include entered string)]
  show

EOF
exit
}

case $1 in
    add|del|show)
	ACTION=$1
	shift
	TASK=$@
	${ACTION}_task
    ;;
    *)
	show_help
    ;;
esac
