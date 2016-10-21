#!/bin/bash

function docker_kdenlive {
  XSOCK=/tmp/.X11-unix
  XAUTH=/tmp/.docker.xauth
  xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
  [[ ! -d $HOME/kdenlive ]] && mkdir -p $HOME/kdenlive
  docker run -e DISPLAY=$DISPLAY -e XAUTHORITY=$XAUTH \
             -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH \
             -v $HOME/kdenlive:$HOME/kdenlive -v $HOME/workspace:$HOME/workspace \
             -it --rm -u $USER \
             rgomes/stretch-kdenlive
}
