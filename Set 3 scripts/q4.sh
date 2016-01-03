#!/bin/bash

#check variables
if [ -z "$TEMP" ] ; then
    echo "Error: Call this script through grade.sh"
fi

cd $TEMP

#check file
if ! [ -f ${question}.cpp ] ; then
    echo -en "\t0\t0\t0\t0\t0" >> $GRADEFILE
else
    echo -en "\t1" >> $GRADEFILE
    #check function
    sed -i 's/guesssqrt/guessSqrt/g' ${question}.cpp
    sed -i 's/GuessSqrt/guessSqrt/g' ${question}.cpp
    temp=`grep guessSqrt ${question}.cpp`
    if [ -z "$temp" ] ; then
        echo -en "\t0\t0\t0\t0" >> $GRADEFILE
    else
        echo -en "\t1" >> $GRADEFILE
        #add custom main
        sed -i '1i#include <iostream>' ${question}.cpp
        echo "int new_main(){"                  >> ${question}.cpp
        echo -e "\tstd::cout << guessSqrt(2.25);" >> ${question}.cpp
        echo -e "}" >> ${question}.cpp
        #compile
        rm testExec > /dev/null 2>&1
        g++ ${question}.cpp -o testExec > /dev/null 2>&1
        if ! [ -f testExec ] ; then
            echo -en "\t0\t0\t0" >> $GRADEFILE
        else
            echo -en "\t1" >> $GRADEFILE

            #test case 1 - check program output
            output=`echo "1.6" | ./testExec`
            output1=`echo $output | awk -F\  '{print $NF}' | tr e E` #get last word with capital E
            if [ -z "$output1" ] || [ `echo $output1'>'0.001 | bc -l` -eq 1 ]; then
                echo -en "\t0" >> $GRADEFILE
                echo -en "\t${question}:${output}" >> $LOGFILE 
            else
                echo -en "\t1" >> $GRADEFILE
            fi

            #test case 2 - check function output
            sed -i 's/\ main/\ old_main/g' ${question}.cpp
            sed -i 's/new_main/main/g' ${question}.cpp
            g++ ${question}.cpp -o testExec > /dev/null 2>&1
            output=`./testExec | tr e E` #capitalize E
            if [ -z "$output" ] || [ `echo $output'>'1.5011 | bc -l` -eq 1 ] || [ `echo $output'<'1.4999 | bc -l` -eq 1 ]; then
                echo -en "\t0" >> $GRADEFILE
                echo -en "\t${question}:${output}" >> $LOGFILE 
            else
                echo -en "\t1" >> $GRADEFILE
            fi
        fi
    fi
fi
