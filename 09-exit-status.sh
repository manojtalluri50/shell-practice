#!/bin/bash
if [ -f "test.txt" ]; then
    echo "File exists"
    exit 0
else
    echo "File not found"
    exit 1
fi