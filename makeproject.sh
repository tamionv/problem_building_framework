#!/bin/bash
#
# Makes a project in $1

# Get problem configuration
read -p "Problem name name: " problemname
read -p "Time limit: " timelimit

# Make project directory
mkdir $1/$problemname

# Make project structure
mkdir $1/$problemname/eval
mkdir $1/$problemname/incf
mkdir $1/$problemname/ingen
mkdir $1/$problemname/okgen
mkdir $1/$problemname/src
mkdir $1/$problemname/stage
mkdir $1/$problemname/tests

touch $1/$problemname/eval/makefile
touch $1/$problemname/incf/makefile
touch $1/$problemname/ingen/makefile
touch $1/$problemname/okgen/makefile
touch $1/$problemname/src/makefile

cp src/buildtests.sh $1/$problemname/buildtests.sh
cp src/lib.sh $1/$problemname/lib.sh
cp src/run.sh $1/$problemname/run.sh

touch $1/$problemname/testmanifest

echo "problemname=$problemname" > $1/$problemname/problemconfig.sh
echo "timelimit=$timelimit" >> $1/$problemname/problemconfig.sh

cp src/todo $1/$problemname/todo
