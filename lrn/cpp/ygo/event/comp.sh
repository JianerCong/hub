#! /bin/bash

CC="g++"
suffix="cpp"

if [ x"$1" = x ]; then
    echo "Usage comp.sh <c-filename>"
    return
fi

sr="$1.$suffix"
if [ ! -f $sr ]; then
    echo "File $sr dosn't exits"
    return
fi

s="$CC $sr -o $1 $2"            # pass the second arg if exits
echo "Command : $s"
$(echo $s) 2> log.txt
# [ is a command
# try  [ 1 = 1]; echo $?
# and [ 1 = 2]; echo $?
if [ $? = 0 ]; then             #without ';' then becomes part of [
    echo "Compiled successed"
    ./$1
else
    echo "Compiled failed"
    less log.txt
fi


# Exit code is used for conditional


