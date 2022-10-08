#! /bin/bash


for str in 1 2 4; do
    echo $str
done



FILE=/tmp/whiletest.$$;
echo firstline > $FILE

while tail -10 $FILE | grep -q firstline; do
    # add lines to $FILE until the last 10 lines dosn't contains "firstline"
    echo -n Number of lines in $FILE: ' ' # disable newline
    wc -l $FILE | awk '{print $1}'
    # pass the output to awk, which extract the first argument
    echo newline >> $FILE
done

