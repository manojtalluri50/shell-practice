#!/bin/bash

SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14} # i* DAYS provided that will be considered otherwise default 14 days

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2 is ... $G SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "$2 is ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
}

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R ERROR:: Please run this script with root access $N" | tee -a $LOG_FILE
        exit 1
    else
        echo "You are running with the root access" | tee -a $LOG_FILE
    fi

}

CHECK_ROOT

mkdir -p $LOGS_FOLDER

USAGE(){
    echo -e "$R USAGE:: $N sh 24-backup.sh <source-dir> <destination-dir> <days(optional)>"
}

if [ $# -lt 2 ]
then
    USAGE
fi

if [ ! -d $SOURCE_DIR ]
then
    echo -e "$R Source Directory $SOURCE_DIR does not exist. please check $N"
    exit 1
fi

if [ ! -d $DEST_DIR ]
then
    echo -e "$R Destination Directory $DEST_DIR does not exist. please check $N"
    exit 1
fi

FILES=$(find $SOURCE_DIR -name "*.log" -mtime +$DAYS)

if [ ! -z $FILES ]
then
    echo "Files to zip are: $FILES"
    TIMESTAMP=$(date +%F-%H-%M-%S)
    ZIP_FILE="$DEST_DIR/app-logs-$TIMESTAMP.zip"
    echo $FILES | zip -@ $ZIP_FILE

    if [ -f $ZIP_FILE ]
    then
        echo -e "Successfully created zip file"

        while IFS= read -r filepath
        do
            echo "Deleting file: $filepath" | tee -a $LOG_FILE
            rm -rf $filepath
        done <<< $FILES

        echo -e "Log files older than $DAYS from source directory removed ... $G SUCCESS $N"

    else
        echo -e "Zip file creation ... $R FAILURE $N"
        exit 1
    fi
else
    echo -e "No log files found older than 14 days ... $Y SKIPPING $N"
fi

