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
        #if [ -z "`echo "5 9 1 18 3" | ./testExec | grep "Mean`" ] ; then
        output2=`echo "5 9 1 18 13" | ./testExec | grep mean`
        output1=`echo "5 9 1 18 13" | ./testExec | grep Median`
        output4=`echo "1 2 3 4 5" | ./testExec | grep mean`
        output3=`echo "1 2 3 4 5" | ./testExec | grep Median`

	output1=`echo ${output1##* } | tr -d .` #get last word, remove dots
	output2=`echo ${output2##* } | tr -d .` #get last word, remove dots
        output3=`echo ${output3##* } | tr -d .` #get last word, remove dots
        output4=`echo ${output4##* } | tr -d .` #get last word, remove dots
	
	if [ "$output1" != 9 ] && [ "$output3" != 3 ]; then
            echo -en "\t0" >> $output1 >> $GRADEFILE
        else
            echo -en "\t1" >> $output2 >> $GRADEFILE
        fi
        
        if [ "$output2" != 638 ] && [ "$output4" != 261 ]; then
             echo -en "\t0" >> $GRADEFILE
        else
            echo -en "\t1" >> $GRADEFILE
        fi

fi
fi
