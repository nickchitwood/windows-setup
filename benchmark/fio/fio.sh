#! /bin/bash
# Get folder to test in

echo "Which folder to benchmark in? (Default is UserProfile\Documents):"

read folder

if [ -z "$folder" ] 
then
    folder=$HOME
fi

# Prepare for results file
echo "What to name the results file:"
read filename