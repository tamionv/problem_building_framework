#!/bin/bash
#
# Bash library for this project
# Tamio-Vesa Nakajima

# Tries to execute $1 ; if this succeeds, do nothing
# otherwise, output $2
try () {
    if eval $1 ; then
        :
    else
        echo $2
        exit 1
    fi
}

# Tries to copy $1 to $2 ; if $1 doesn't exist, creates an empty $2
maybecp () {
    if [ -f $1 ] ; then
        cp $1 $2
    else
        touch $2
    fi
}

# Evaluates the binary $1 with test $2, returning the message in $message, the time used in $timeUsed and the points in $points
evaluate_src_test () {
    binary=$1
    testname=$2

    # Get an appropriate timeout command
    timeoutCommand=timeout

    if [[ "$OSTYPE" == "darwin"* ]] ; then
        timeoutCommand=gtimeout
    fi

    # Fetch the problem configuration
    source problemconfig.sh

    # clear any previous messages
    echo -en "                                      \r"

    # Output an appropriate messgae
    echo -en "Doing $testname\r"

    # Clean the stage
    rm stage/*

    # Copy the binary into the stage
    cp $binary stage/$problemname.bin

    # Copy the input into the stage
    cp tests/$testname.in stage/$problemname.in

    # Get the problem config
    source problemconfig.sh

    # This string runs the competitor's executable
    runExec="./$problemname.bin > /dev/null 2> /dev/null"

    # This string runs the competitors executable with an appropriate timeout
    runExecWithTimeout="$timeoutCommand $timelimit $runExec"

    # Run the competitors executable with a timeout, and store the time used in timeUsed
    timeUsed=$(cd stage && { time $runExecWithTimeout ; } 2>&1 >/dev/null \
        | tail -3 \
        | head -1 \
        | awk -F ' ' '{print $2}' \
        | awk -F 'm' '{print $2}' \
        | awk -F 's' '{print $1}' && cd ..) 

    if (( $(echo "$timeUsed > $timelimit" | bc -l))) ; then
        # Set the return values
        # timeUsed is already set
        message=TLE
        points=0
    else
        # Make the evaluator
        try "cd eval && make -s && cd .." "evaluator build fail"

        # Copy the evaluator into the stage
        cp eval/eval.bin stage/eval.bin

        # Copy the ok file into the stage
        cp tests/$testname.ok stage/$problemname.ok

        # Create temporary files to hold the points and the eval message
        pointsFile=`mktemp`
        messageFile=`mktemp`

        # Enter the stage and evaluate, storing the results in $pointsFile and $messageFile
        try "cd stage && ./eval.bin > $pointsFile 2> $messageFile && cd .." "eval error"

        # Set the return values
        # timeUsed is already set
        points=`cat $pointsFile`
        message=`cat $messageFile`
    fi
}
