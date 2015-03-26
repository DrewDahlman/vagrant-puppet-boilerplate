#!/bin/bash
echo "Starting server..."

if [ -d "tmp" ]
then
	echo "tmp exists... moving on"
else
	echo "creating tmp..."
	mkdir tmp
fi

if [ -d "tmp/pids" ]
then
	echo "pids exists... moving on"
else
	echo "creating pids..."
	mkdir tmp/pids
fi

echo "Starting Unicorn..."
sudo service unicorn start