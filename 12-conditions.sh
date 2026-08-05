#!/bin/bash

NUMBER=$1

if [ $NUMBER -gt 20 ]
then
    echo "Given number $NUMBER is greater than 20"
else
    echo "Given number $NUMBER is not greater than 20"
fi