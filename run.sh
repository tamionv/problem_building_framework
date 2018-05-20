#!/bin/bash
#
# Runs sources on tests
# Tamio-Vesa Nakajima
#
# Use cases:
# ./run.sh -> runs all sources on all tests
# ./run.sh -s "a.cpp b.cpp" -s c.cpp -> runs a,b,c.cpp on all tests
# ./run.sh -t "00 01 02" -> runs all sources on tests 00, 01, 02
# ./run.sh -s a.cpp -t 00 -> runs a.cpp on 00

##########################
# GENERAL SETUP
#########################

# include the library
source lib.sh

# include the configuration
source problemconfig.sh

# make stage (as git deletes it)
mkdir -p stage

# Get an appropriate timeout command
timeoutCommand=timeout

if [[ "$OSTYPE" == "darwin"* ]] ; then
    timeoutCommand=gtimeout
fi

# Make the evaluator
try "cd eval && make -s && cd .." "evaluator build fail"

# Copy the evaluator into the stage
cp eval/eval.bin stage/eval.bin

############################
# ARGUMENT PARSING
#############################

# default values for used sources and used tests

srcs=""
tests=""

while getopts "hs:t:" opt; do
    case $opt in
        h)
            echo "Usage: ./run.sh -s [source] -t [test]"
            exit 0
            ;;
        s)
            for x in $OPTARG ; do
                srcs="$srcs $x"
            done
            ;;
        t)
            for x in $OPTARG ; do
                tests="$tests $problemname-$x"
            done
            ;;
    esac
done
            
if [ -z "$srcs" ] ; then
    srcs=`ls -1 src | grep .cpp`
fi

if [ -z "$tests" ] ; then
    tests=`ls -1 tests | grep .in | awk -F '.' '{print $1}'`
fi

tests=`echo $tests | sort -t '-' -k 1 -n`


###########################
# EVALUATING
##########################

for src in $srcs ; do
    # Copy the source into the stage
    try "cp src/$src stage/$problemname.cpp" "source file missing"

    # Create a temporary file to hold the problem binary
    binary=`mktemp`

    # Build the source
    try "g++ stage/$problemname.cpp -std=c++11 -o $binary -O2" "Compile error"

    # Make a temporary file to hold the table:
    table=`mktemp`

    # $table holds the score table
    echo $src > $table
    echo Test Message Time Points >> $table

    # For all tests
    for testname in $tests ; do
        # clear any previous messages
        echo -en "                                      \r"

        # Output an appropriate messgae
        echo -en "Doing $testname\r"

        # Clean the stage
        rm stage/*

        # Copy the executable into the stage
        cp $binary stage/$problemname.bin

        # Copy the input into the stage
        cp tests/$testname.in stage/$problemname.in
        
        #timeUsed=""
        #message=""
        #points=""

        evaluate_stage timeUsed message points

        echo $testname.in $message $timeUsed $points >> $table
    done

    # Clear "Doing test ..."
    echo -en "                               \r"

    # Output the table
    column -t $table

    # Calculate the score
    echo SCORE: `awk -F ' ' '$1 != "Test" {sum += 0 $4} END {print sum}' $table`

    # Clear the temporary files
    rm $table
    rm $binary

    # And the stage
    rm stage/*
done
