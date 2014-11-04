#!/bin/bash
./stop.sh
NAME=`basename $PWD`
CMD="docker rmi $NAME"
echo "* Removing image with: $CMD"
docker rmi $NAME
