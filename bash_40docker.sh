#!/bin/bash

function docker_torch7 {
    docker run -it --rm -p 18888:8888 -v $HOME/workspace:/root/workspace rgomes/jessie-torch7
}

function docker_kdenlive {
    XSOCK=/tmp/.X11-unix
    XAUTH=/tmp/.docker.xauth
    xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
    [[ ! -d $HOME/kdenlive ]] && mkdir -p $HOME/kdenlive
    docker run -it --rm \
               -e DISPLAY=$DISPLAY \
               -e XAUTHORITY=$XAUTH \
               -v $XSOCK:$XSOCK \
               -v $XAUTH:$XAUTH \
               -v $HOME/kdenlive/:/root/kdenlive/ \
               -v /media/b1582a88-e1e6-413d-bcac-881206487eb6/:/root/Media/ \
               rgomes/stretch-kdenlive
}
