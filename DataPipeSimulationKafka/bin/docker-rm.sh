
ctr="$1"
if [ ! -z "$ctr" ]
then
	docker ps | grep "$ctr" >> "$LOG"
	echo docker rm -f "$ctr" >> "$LOG"
	docker rm -f "$ctr" >> "$LOG"
else
	echo "got request to delete empty container" >> "$LOG"
fi
