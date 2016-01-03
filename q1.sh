#!/bin/bash

question=Q1
echo $question

#check variables
if [ -z "$TEMP" ] ; then
    echo "Error: Call this script through grade.sh"
    exit
fi

cd $TEMP

#check file
if ! [ -f ${question}.cpp ] ; then
    echo -en "\t0" >> $GRADEFILE
else
    echo -en "\t1" >> $GRADEFILE
    
    #compile
    rm testExec > /dev/null 2>&1
    output=`g++ -std=c++0x ${question}.cpp -Wall -o testExec 2>&1`
    if ! [ -f testExec -o -z "echo $output | grep error" ] ; then
        echo -en "\t0" >> $GRADEFILE
    else
        echo -en "\t1" >> $GRADEFILE
      : << 'END' 
        textFile=randomletters.txt
        
        #creates file
        ./testExec > /dev/null 2>&1
        if ! [ -f $textFile ] ; then
            echo -en "\t0" >> $GRADEFILE
            return
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        rm $textFile > /dev/null 2>&1
        
        #appends to file
        echo "testing" > $textFile
        ./testExec > /dev/null 2>&1
        if [ "$(head -n 1 $textFile)" != "testing" ] ; then
            echo -en "\t0" >> $GRADEFILE
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        rm $textFile > /dev/null 2>&1
        
        #100 chars
        ./testExec > /dev/null 2>&1
        #count chars after removing newlines, spaces, tabs
        numchars=`cat $textFile | tr -d '\n' | tr -d ' ' | tr -d '\t' | wc -m`
        if [ "$numchars" -ne 100 ] ; then
            echo -en "\t0" >> $GRADEFILE
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        rm $textFile > /dev/null 2>&1
        
        #random
        if [ -z "`grep rand ${question}.cpp`" ] ; then
            echo -en "\t0" >> $GRADEFILE
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        
        #seeded
        if [ -z "`grep srand ${question}.cpp`" ] ; then
            echo -en "\t0" >> $GRADEFILE
        else
            echo -en "\t1" >> $GRADEFILE
        fi
        
        #lowercase
        ./testExec > /dev/null 2>&1
        chars=`cat $textFile | tr -d '\n' | tr -d ' ' | tr -d '\t'`
        #check string after stripping lowercases
        if [ -z "`echo $chars | grep -v [a-z]`" ] ; then
            echo -en "\t1" >> $GRADEFILE
        else
            echo -en "\t0" >> $GRADEFILE
        fi
        rm $textFile > /dev/null 2>&1
        
        #tab delimited
        ./testExec > /dev/null 2>&1
        chars=`cat $textFile`
        res="${chars//[^\t]}"
        numtabs=${#res}
        if [ "$numtabs" -lt 99 -o "$numtabs" -gt 102 ] ; then
            echo -en "\t1" >> $GRADEFILE
        else
            echo -en "\t0" >> $GRADEFILE
        fi
        
    fi
END
fi 
