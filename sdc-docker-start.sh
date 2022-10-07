#!/bin/sh

xhost +local:
docker run -it --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" -p 2233:22 --rm --name ros -e GRANT_SUDO=yes -v /home:/host softmac/sdc-course-docker:test bash

