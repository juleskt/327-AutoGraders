#!/bin/bash

#check variables
if [ -z "$TEMP" ] ; then
    echo "Error: Call this script through grade.sh"
fi

cd $TEMP

#check file
if ! [ -f ${question}.cpp ] ; then
    echo -en "\t0\t0\t0\t0\t0\t0" >> $GRADEFILE
else
    echo -en "\t1" >> $GRADEFILE
    #compile
    rm testExec > /dev/null 2>&1
    g++ ${question}.cpp -o testExec > /dev/null 2>&1
    if ! [ -f testExec ] ; then
        echo -en "\t0\t0\t0\t0\t0" >> $GRADEFILE
    else
        echo -en "\t1" >> $GRADEFILE
        cp ${question}.cpp ${question}_org.cpp #save original
        #test case 1 - correct guess
        sed -i 's/rand()/5/g' ${question}.cpp
        g++ ${question}.cpp -o testExec
        output=`echo "5" | ./testExec`
        output1=`echo $output | grep CONG | wc -l`
        if [ $output1 != 1 ]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        #test case 2 - partial award
        output=`echo "15" | ./testExec`
        output1=`echo $output | grep artial | wc -l`
        if [ $output1 != 1 ]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        #test case 3 - guess zero
        cp ${question}_org.cpp ${question}.cpp
        sed -i 's/rand()/10/g' ${question}.cpp
        g++ ${question}.cpp -o testExec
        output=`echo "0 10" | ./testExec`
        output1=`echo $output | grep artial | wc -l`
        if [ $output1 != 1 ]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        #test case 3 - partial award with second digit
        cp ${question}_org.cpp ${question}.cpp
        sed -i 's/rand()/15/g' ${question}.cpp
        g++ ${question}.cpp -o testExec
        output=`echo "2 8 17" | ./testExec`
        output1=`echo $output | grep artial | wc -l`
        if [ $output1 != 1 ]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
    fi
fi
