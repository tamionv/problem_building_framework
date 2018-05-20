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

# Evaluates whatever is in the stage, and returns: the time used in $1, the evaluation result in $2, the points in $3
evaluate_stage () {
    # Get an appropriate timeout command
    timeoutCommand=timeout

    if [[ "$OSTYPE" == "darwin"* ]] ; then
        timeoutCommand=gtimeout
    fi

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
        eval $1=$timeUsed
        eval $2=TLE
        eval $3=0
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

        # Set the return values
        eval "$1="$timeUsed""
        eval "$2=`cat $message`"
        eval "$3=`cat $points`"
    fi
}
