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
