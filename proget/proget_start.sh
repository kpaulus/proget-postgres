#!/bin/bash
attempt=0
while [ $attempt -le 9 ]; do
    attempt=$(( $attempt + 1 ))
    echo "Waiting for postgres server to be up (attempt: $attempt)..."
    sleep 2
done

echo Running changescripter...
mono /usr/local/proget/db/bmdbupdate.exe Update /Conn='Server=db; Database=ProGet; User Id=proget; Password=proget;' /Init=yes

echo Starting ProGet service...
mono /usr/local/proget/service/ProGet.Service.exe Run /Urls=http://*:80/ &
pgservice_pid=$!
echo "Service PID is $pgservice_pid"

function handle_shutdown {
	echo "Stopping ProGet service..."
	kill -15 $pgservice_pid

	exit 0
}

trap "handle_shutdown" HUP INT QUIT KILL TERM

echo "Running... Press enter or use docker stop to exit."
while true
do
	sleep 1
done
