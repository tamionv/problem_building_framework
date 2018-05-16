#!/bin/bash
#
# This builds test $problemname.$1 using ingen, incf/$1 and okgen
# Tamio-Vesa Nakajima

# include the library
source lib.sh

# Get problem name
problemname=`cat problemname`

#################
# Build input:
#################

# Build input generator
try "cd ingen && make -s && cd .." "input generator build fail"

# Copy ingen/ingen.bin and incf/$1 into stage, building an empty cf if none exists
cp ingen/ingen.bin stage/$problemname.bin
maybecp incf/$1 stage/$problemname.cf

# Build input
try "cd stage && ./$problemname.bin > ../tests/$problemname-$1.in && cd .." "input generation fail"

# Clean stage
rm stage/*

###################
# Build ok
###################

# Build ok generator
try "cd okgen && make -s && cd .." "ok generator build fil"

# Copy ok generator and input into stage
cp okgen/okgen.bin stage/$problemname.bin
cp tests/$problemname-$1.in stage/$problemname.in

# Build ok
try "cd stage && ./$problemname.bin && cd .." "ok generation fail"

# Copy ok from stage into tests
cp stage/$problemname.out tests/$problemname-$1.ok

# Clean stage
rm stage/*
