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
    #replace main function name
    sed -i 's/main/old_main/g' ${question}.cpp
    #convert blackjack to lower case
    sed -i 's/blackJack/blackjack/g' ${question}.cpp
    sed -i 's/BlackJack/blackjack/g' ${question}.cpp
    sed -i 's/BLACKJACK/blackjack/g' ${question}.cpp
    #add custom main function - uses error stream to ignore student debug outputs
    sed -i '1i#include <iostream>' ${question}.cpp
    echo "int main(){"                                   >> ${question}.cpp
    echo -e "\tstd::cerr << blackjack(1,8)     << endl;" >> ${question}.cpp
    echo -e "\tstd::cerr << blackjack('A',2)   << endl;" >> ${question}.cpp
    echo -e "\tstd::cerr << blackjack('K','J') << endl;" >> ${question}.cpp
    echo -e "\tstd::cerr << blackjack(2,'Q')   << endl;" >> ${question}.cpp
    echo -e "\tstd::cerr << blackjack('A','J') << endl;" >> ${question}.cpp
    echo -e "}"                                          >> ${question}.cpp

    echo " ! Manual test is needed for old_main and invalid input control"

    #compile
    rm testExec > /dev/null 2>&1
    g++ ${question}.cpp -o testExec > /dev/null 2>&1
    if ! [ -f testExec ] ; then
        echo -en "\t0\t0\t0\t0\t0\t0" >> $GRADEFILE
    else
        echo -en "\t1" >> $GRADEFILE
        #test
        output=$( { ./testExec > /dev/null; } 2>&1 ) #get error output
        output1=`echo $output | awk '{print $1}'`
        if [ -z "$output1" ] || [ "$output1" != 0 ]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output1}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        output1=`echo $output | awk '{print $2}'`
        if [ -z "$output1" ] || [ "$output1" != 0 ]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output1}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        output1=`echo $output | awk '{print $3}'`
        if [ -z "$output1" ] || [ "$output1" != 0 ]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output1}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        output1=`echo $output | awk '{print $4}'`
        if [ -z "$output1" ] || [ "$output1" != 0 ]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output1}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        output1=`echo $output | awk '{print $5}'`
        if [ -z "$output1" ] || [ "$output1" != 1 ]; then
            echo -en "\t0" >> $GRADEFILE
            echo -en "\t${question}:${output1}" >> $LOGFILE 
        else
            echo -en "\t1" >> $GRADEFILE
        fi
    fi
fi
