#!/bin/bash
#
# This builds all tests using testmanifest
# Tamio-Vesa Nakajima

# include the library
source lib.sh

# Get problem name
problemname=`cat problemname`

# Make stage (as git deletes it)
mkdir -p stage

# We will want to remember this:
currtest=0

# Loop over lines of 
cat testmanifest | while read instr; do
    # Parse a line of testmanifest
    set $instr
    numberoftests=$1
    incf=$2
    totalpoints=$3
    points=$(($totalpoints / $numberoftests))

    for nr in `seq $currtest $(($currtest + $numberoftests - 1))` ; do
        echo $nr
        #################
        # Build input:
        #################

        # Build input generator
        try "cd ingen && make -s && cd .." "input generator build fail"

        # Copy ingen/ingen.bin and incf/$1 into stage
        cp ingen/ingen.bin stage/$problemname.bin
        try "cp incf/$incf stage/$problemname.cf" "incf/$incf doesn't exist"

        # Build input
        try "cd stage && ./$problemname.bin > ../tests/$problemname-$nr.in && cd .." "input generation fail"

        # Clean stage
        rm stage/*

        ###################
        # Build ok
        ###################

        # Build ok generator
        try "cd okgen && make -s && cd .." "ok generator build fil"

        # Copy ok generator and input into stage
        cp okgen/okgen.bin stage/$problemname.bin
        cp tests/$problemname-$nr.in stage/$problemname.in

        # Indicate the number of points in the stage
        echo $points > stage/$problemname.points

        # Build ok
        try "cd stage && ./$problemname.bin && cd .." "ok generation fail"

        # Copy ok from stage into tests
        cp stage/$problemname.ok tests/$problemname-$nr.ok

        # Clean stage
        rm stage/*
    done

    #update currtest
    currtest=$(($currtest + $numberoftests))

done
