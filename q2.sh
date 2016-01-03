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
        output=`echo "1.234" | ./testExec | grep Mantissa`
        output1=`echo $output | cut -d, -f1 | cut -d: -f2 | tr -d ' '` #get relevant output
        output2=`echo $output | cut -d, -f2 | cut -d: -f2 | tr -d ' '` #get relevant output
        if [ -z "$output" ] || [ "$output1" != 1.234 ] || [ "$output2" != 0 ]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        #test case 2 - positive exponent
        output=`echo "123.4" | ./testExec | grep Mantissa`
        output1=`echo $output | cut -d, -f1 | cut -d: -f2 | tr -d ' '` #get relevant output
        output2=`echo $output | cut -d, -f2 | cut -d: -f2 | tr -d ' '` #get relevant output
        if [ -z "$output" ] || [ "$output1" != 1.234 ] || [ "$output2" != 2 ]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        #test case 3 - negative exponent
        output=`echo "0.001234" | ./testExec | grep Mantissa`
        output1=`echo $output | cut -d, -f1 | cut -d: -f2 | tr -d ' '` #get relevant output
        output2=`echo $output | cut -d, -f2 | cut -d: -f2 | tr -d ' '` #get relevant output
        if [ -z "$output" ] || [ "$output1" != 1.234 ] || [ "$output2" != -3 ]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        #test case 4 - negative number
        output=`echo "-1.234" | ./testExec | grep Mantissa`
        output1=`echo $output | cut -d, -f1 | cut -d: -f2 | tr -d ' '` #get relevant output
        output2=`echo $output | cut -d, -f2 | cut -d: -f2 | tr -d ' '` #get relevant output
        if [ -z "$output" ] || [ "$output1" != -1.234 ] || [ "$output2" != 0 ]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output}" >> $LOGFILE
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        #test case 5 - longer number
        output=`echo "1.23403392" | ./testExec | grep Mantissa`
        output1=`echo $output | cut -d, -f1 | cut -d: -f2 | tr -d ' '` #get relevant output
        output2=`echo $output | cut -d, -f2 | cut -d: -f2 | tr -d ' '` #get relevant output
        if [ -z "$output" ] || [ "$output1" != 1.234 ] || [ "$output2" != 0 ]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
    fi
fi
