#!/bin/bash

echo "Running rake on databases"
su -l vagrant -c 'rake db:create'
su -l vagrant -c 'rake db:migrate'