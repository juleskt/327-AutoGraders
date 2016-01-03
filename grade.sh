#!/bin/bash

#define variables
HW=midterm2

#use startWith to skip alphabetically ordered users
startWith="gkware" #put user name here to start the grading with

ROOT_FOLDER=`pwd`
SUBMISSIONS=${ROOT_FOLDER}/${HW}
LOGFILE=${ROOT_FOLDER}/${HW}_log.txt
GRADEFILE=${ROOT_FOLDER}/${HW}_grades.txt
TEMP=${ROOT_FOLDER}/temp

#clear log & grade files
rm -rf $LOGFILE > /dev/null 2>&1
rm -rf $GRADEFILE > /dev/null 2>&1

#iterate for each user folder
for userName in `ls ${SUBMISSIONS}` ; do

    #skip user if required
    if [[ "$userName" < "$startWith" ]] ; then
        continue;
    fi

    #report next user name at terminal
    echo "User: $userName"

    #start user log & grade
    echo -n $userName >> $LOGFILE
    echo -n $userName >> $GRADEFILE

    #create clean temp folder for grading
    rm -rf $TEMP > /dev/null 2>&1
    mkdir $TEMP
    #copy user files
    cp -r ${SUBMISSIONS}/${userName}/* $TEMP/.

    ##############
    # GRADE ######
    ##############

    cd $TEMP
    question=Q1
    echo $question
    . ../q1.sh

#    cd $TEMP
#    question=Q2
#    echo $question
#    . ../q2.sh

#    cd $TEMP
#    question=Q3
#    echo $question
#    . ../q3.sh

#    cd $TEMP
#    question=Q4
#    echo $question
#    . ../q4.sh

    #finalize log & grade rows
#    echo "" >> $LOGFILE
#    echo "" >> $GRADEFILE

    #prompt to continue
    read -p "Press [Enter] to continue with the next user"
done

echo "All users finished!"
