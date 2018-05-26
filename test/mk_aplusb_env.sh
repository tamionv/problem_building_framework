#!/bin/bash

project_directory=$(mktemp -d)

echo Building project >&2
printf "aplusb\\n0.1" | ./makeproject "$project_directory"

echo Copying files into project >&2
cp test/aplusb/incf/* "$project_directory/aplusb/incf"
cp test/aplusb/ingen/* "$project_directory/aplusb/ingen"
cp test/aplusb/okgen/* "$project_directory/aplusb/okgen"
cp test/aplusb/eval/* "$project_directory/aplusb/eval"
cp test/aplusb/src/* "$project_directory/aplusb/src"
cp test/aplusb/testmanifest "$project_directory/aplusb/testmanifest"

echo "$project_directory"
