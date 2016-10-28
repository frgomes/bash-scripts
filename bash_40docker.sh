#!/bin/bash

function docker_remove_images_none {
  docker images | fgrep none | cut -c44-61 | xargs docker rmi --force
}
