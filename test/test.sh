#!/bin/bash

project_directory=$(./test/mk_aplusb_env.sh)

cd "$project_directory/aplusb" || exit 1

echo Running sources
echo | ./buildtests
./run
./compare -s ok.cpp -s almost_ok.cpp -c random

echo Cleanup

rm -r "$project_directory"
