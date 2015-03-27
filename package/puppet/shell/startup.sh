#!/bin/bash
echo "Starting server..."

## Check for TMP directory
if [ -d "tmp" ]
then
	echo "tmp exists... moving on"
else
	echo "creating tmp..."
	sudo mkdir tmp
fi

## Check for pids directory
if [ -d "tmp/pids" ]
then
	echo "pids exists... moving on"
else
	echo "creating pids..."
	sudo mkdir tmp/pids
fi

## Start unicorn
echo "Starting Unicorn..."
sudo service unicorn start