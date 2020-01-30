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
comp_name=$(cat /etc/hostname)

file_w_folder="$comp_name/$filename"

# Run benchmark
fio benchmark.fio --directory="$folder" --output-format=json --eta=always --output="$file_w_folder"
