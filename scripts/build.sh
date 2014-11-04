#!/bin/sh
NAME=`basename $PWD`
CMD="docker build -t=$NAME ."
echo "* Building container with: $CMD"
docker build -t=$NAME .
./start.sh
