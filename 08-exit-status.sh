ping -c 1 google.com
echo "$?"

if [ $? -eq 0 ]; then
    echo "Internet is working"
else
    echo "No internet connection"
fi