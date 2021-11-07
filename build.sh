#!/bin/bash
cp ~/.ssh/* .
rm -r panda_controller-libfranka
git clone https://github.com/tjdalsckd/panda_controller_libfranka.git
docker build -t tjdalsckd/ros2:latest .

