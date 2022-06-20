#! /bin/bash

CC="g++"
suffix="cpp"
# PROGNAME="${0##*/}"
PROGNAME="jpp"

if [ x"$1" = x ]; then
    echo "Usage $PROGNAME <c++-filename>"
    return
fi


if [ ${1##*.} = "$suffix" ]; then
    sr=$1
else
    sr="$1.$suffix"
fi

o=${sr%%.*}
echo "o is $o"

if [ ! -f $sr ]; then
    echo "File $sr dosn't exits"
    return
fi

s="$CC $sr -o $o $2"            # pass the second arg if exits
echo "Command : $s"
$(echo $s) 2> log.txt
# [ is a command
# try  [ 1 = 1]; echo $?
# and [ 1 = 2]; echo $?
if [ $? = 0 ]; then             #without ';' then becomes part of [
    echo "Compiled successed: 🐸"
    echo " "
    echo " "
    "./$o"
    rm $o
else
    echo "Compiled failed"
    less log.txt
fi


# Exit code is used for conditional


