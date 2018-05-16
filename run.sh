#!/bin/bash
#
# Runs $1.cpp on all tests
# Tamio-Vesa Nakajima

# include the library
source lib.sh

# Get an appropriate timeout command
timeoutCommand=timeout

if [[ "$OSTYPE" == "darwin"* ]] ; then
    timeoutCommand=gtimeout
fi

# Check if timoutCommand is valid
#try "hash $timeoutCommand$" "timeout fail"

# Get the problem name and the time limit
try "problemname=`cat problemname`" "no problemname file"
try "timelimit=`cat timelimit`" "no timelimit file"

# Make the evaluator
try "cd eval && make -s && cd .." "evaluator build fail"

# Copy the evaluator into the stage
cp eval/eval.bin stage/eval.bin

# Copy the source into the stage
try "cp src/$1 stage/$problemname.cpp" "source file missing"

# Create a temporary file to hold the problem binary
binary=`mktemp`

# Build the source
try "g++ stage/$problemname.cpp -std=c++11 -o $binary -O2" "Compile error"

# Make a temporary file to hold the table:
table=`mktemp`

# $table holds the score table
echo Test Message Time Points > $table

# Find names of all inputs
tests=`ls -1 tests | grep .in | awk -F '.' '{print $1}'`

# For all tests
for testname in $tests ; do
    # Output an appropriate messgae
    echo -en "Doing $testname\r"

    # Clean the stage
    rm stage/*

    # Copy the executable into the stage
    cp $binary stage/$problemname.bin

    # Copy the input into the stage
    cp tests/$testname.in stage/$problemname.in

    # This string runs the competitor's executable
    runExec="./$problemname.bin > /dev/null 2> /dev/null"

    # This string runs the competitors executable with an appropriate timeout
    runExecWithTimeout="$timeoutCommand $timelimit $runExec"

    # Run the competitors executable with a timeout, and store the time used in timeUsed
    timeUsed=$(cd stage && { time $runExecWithTimeout ; } 2>&1 >/dev/null \
        | head -2 \
        | awk -F ' ' '{print $2}' \
        | awk -F 'm' '{print $2}' \
        | awk -F 's' '{print $1}' && cd ..)

    if (( $(echo "$timeUsed > $timelimit" | bc -l))) ; then
        # Print that this testcase resulted in a TLE
        echo $testname TLE $timeUsed 0 >> $table
    else
        # Copy the evaluator into the stage
        cp eval/eval.bin stage/eval.bin

        # Copy the ok file into the stage
        cp tests/$testname.ok stage/$problemname.ok

        # Create temporary files to hold the points and the eval message
        points=`mktemp`
        message=`mktemp`

        # Enter the stage and evaluate, storing the results in $points and $message
        try "cd stage && ./eval.bin > $points 2> $message && cd .." "eval error"

        # Add the relevant information into the table
        echo $testname `cat $message` $timeUsed `cat $points` >> $table
    fi
done

# Output the table
column -t $table

# Calculate the score
echo SCORE: `awk -F ' ' '$1 != "Test" {sum += 0 $4} END {print sum}' $table`

# Clear the temporary files
rm $table
rm $binary

# And the stage
rm stage/*
