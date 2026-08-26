#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
else
    echo "You are running with the root access"
fi

# validate function takes inputs exit status as $1 and which command they try to install as $2
VALIDATE(){
        if [ $1 -eq 0 ]
    then
        echo -e "Installing $2 is ... $G SUCCESS $N"
    else
        echo -e "Installing $2 is ... $R FAILURE $N"
        exit 1
    fi
}

dnf list installed mysql

if [ $? -ne 0 ]
then 
    echo "MySQL is not installed... going to install it"
    dnf install mysql -y
    VALIDATE $? "MYSQL"
else
    echo -e "Nothing to do MySQL... $Y Already installed $N"
fi

dnf list installed python3

if [ $? -ne 0 ]
then 
    echo "Python3 is not installed... going to install it"
    dnf install python3 -y
    VALIDATE $? "Python3"
else
    echo -e "Nothing to do Python3... $Y Already installed $N"
fi

dnf list installed nginx

if [ $? -ne 0 ]
then 
    echo "Nginx is not installed... going to install it"
    dnf install nginx -y
    VALIDATE $? "Nginx"
else
    echo -e "Nothing to do Nginx.. $Y Already installed $N"
fi
