#!/bin/sh
NAME=`basename $PWD`
CMD="docker run -v $HOME:/root -w /root -h $NAME --name=$NAME -i -t $NAME /bin/zsh"
echo "* Starting container with: $CMD"
docker run -v $HOME:/root -w /root -h dockerized_$NAME --name=$NAME -i -t $NAME /bin/zsh
