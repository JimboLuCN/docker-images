#!/bin/sh

tags="
precise 12.04.5 12.04
trusty  14.04.1 14.04 latest
"

# dryrun
dryrun="$(echo "$1" | sed '/^echo$/b;s/.*//g')"

# Cleanup
docker rm $(docker ps -aqf status=exited) 2>/dev/null
docker rmi $(docker images -aqf dangling=true) 2>/dev/null

# Build
for i in $(find * -maxdepth 1 -type d)
do
  IFS=" "
  for j in $(echo $tags | grep $i)
  do
    $dryrun docker build -t ekino/puppetlabs:$j $i
  done
done