#!/bin/sh
NAME=`basename $PWD`
CMD="docker kill $NAME"
echo "* Stopping container with: $CMD"
docker kill $NAME

CMD="docker rm $NAME"
echo "* Removing container with: $CMD"
docker rm $NAME
