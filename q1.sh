#!/bin/bash

#check variables
if [ -z "$TEMP" ] ; then
    echo "Error: Call this script through grade.sh"
fi

cd $TEMP

#check file
if ! [ -f ${question}.cpp ] ; then
    echo -en "\t0\t0\t0\t0\t0\t0\t0" >> $GRADEFILE
else
    echo -en "\t1" >> $GRADEFILE
    #compile
    rm testExec > /dev/null 2>&1
    g++ ${question}.cpp -o testExec > /dev/null 2>&1
    if ! [ -f testExec ] ; then
        echo -en "\t0\t0\t0\t0\t0\t0" >> $GRADEFILE
    else
        echo -en "\t1" >> $GRADEFILE
        #test case 1 - normal
        if [ -z "`echo "1 1 4 2 2 8" | ./testExec | grep "THE CIRCLES OVERLAP"`" ] ; then
            echo -en "\t0" >> $GRADEFILE
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        #test case 2 - one contains the other
        if [ -z "`echo "0 0 4 0 0 8" | ./testExec | grep "THE CIRCLES OVERLAP"`" ] ; then
            echo -en "\t0" >> $GRADEFILE
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        #test case 3 - not overlapping
        output=`echo "0 0 1 5 5 1" | ./testExec | grep DISTANCE`
        output=`echo ${output##* } | tr -d .` #get last word, remove dots
        if [ -z "$output" ] || [ $output != 507 ] ; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        #test case 4 - negative coord
        if [ -z "`echo "1 -1 4 -2 2 8" | ./testExec | grep "THE CIRCLES OVERLAP"`" ] ; then
            echo -en "\t0" >> $GRADEFILE
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        #test case 5 - not overlapping, negative
        output=`echo "0 -2 1 3 2 1" | ./testExec | grep DISTANCE`
        output=`echo ${output##* } | tr -d .` #get last word, remove dots
        if [ -z "$output" ] || [[ "$output" != 3 && "$output" != 300 ]]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
    fi
fi
  