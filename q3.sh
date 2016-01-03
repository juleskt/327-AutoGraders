#!/bin/bash

#check variables
if [ -z "$TEMP" ] ; then
    echo "Error: Call this script through grade.sh"
fi

cd $TEMP

#check file
if ! [ -f ${question}.cpp ] ; then
    echo -en "\t0\t0\t0\t0" >> $GRADEFILE
else
    echo -en "\t1" >> $GRADEFILE
    #compile
    rm testExec > /dev/null 2>&1
    g++ ${question}.cpp -o testExec > /dev/null 2>&1
    if ! [ -f testExec ] ; then
        echo -en "\t0\t0\t0" >> $GRADEFILE
    else
        echo -en "\t1" >> $GRADEFILE
        #test case 1 - 1 difference
        output=`echo "20395 20392" | ./testExec | awk 'BEGIN {FS="octal"} {print $1}' | awk -F\  '{print $NF}'`
        if [ -z "$output" ] || [ "$output" != 1 ]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        #test case 2 - one number is longer
        output=`echo "20392 2117547" | ./testExec | awk 'BEGIN {FS="octal"} {print $1}' | awk -F\  '{print $NF}'`
        if [ -z "$output" ] || [ "$output" != 2 ]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
    fi
fi
