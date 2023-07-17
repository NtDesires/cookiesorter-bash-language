#!/bin/bash

search_dir=$1
sort=$2
makedir=$3
shift 3
search_strings=$@
if [[ $# -lt 0 ]]; then
    echo "Usage: ./script.sh <search_dir> <sort> <ext dir> <search_string1> <search_string2> ... "
    echo "Project: self writen by https://github.com/NtDesires/"
    exit 1
fi

dest_dir=$search_dir"/Sorter"
mkdir -p "$dest_dir"
if [[ $? -ne 0 ]]; then
    echo "Нет прав на создание $dest_dir!"
    exit 1
fi

for string in $search_strings; do
    if [[ $makedir -eq 1 ]]; then
    dest_dir=$search_dir"/Sorter/$string"
    mkdir -p "$dest_dir"
    if [[ $? -ne 0 ]]; then
    echo "Нет прав на создание $dest_dir!"
    exit 1
    fi
    fi
    output_file=$string"_found.txt"
    paths_file=$string"_paths.txt"
    if [[ -f "$dest_dir/$output_file" ]]; then
        rm "$dest_dir/$output_file"
    fi

    if [[ -f "$dest_dir/$paths_file" ]]; then
        rm "$dest_dir/$paths_file"
    fi

    touch "$dest_dir/$output_file"
    if [[ $? -ne 0 ]]; then
        echo "Нет прав на создание $dest_dir/$output_file!"
        exit 1
    fi

    touch "$dest_dir/$paths_file"
    if [[ $? -ne 0 ]]; then
        echo "Нет прав на создание $dest_dir/$paths_file!"
        exit 1
    fi
    if [[ $sort -eq 1 ]]; then
    for file in $(find $search_dir -type f -name "*Cookies*"); do
        grep -i "$string" $file > "$dest_dir/$string-$filename"
        if [[ $? -eq 0 ]]; then
            filename=$(basename $file)
            cat "$dest_dir/$string-$filename" >> "$dest_dir/$output_file"
            echo $file >> "$dest_dir/$paths_file"
        fi
    done
    fi
    prev_file=""
    for file in $(find $search_dir -type f -name "*Cookies*"); do
        grep -i "$string" $file >> "$dest_dir/$output_file"
        if [[ $? -eq 0 ]]; then
            if [[ "$prev_file" != "$file" ]]; then
                echo  >> "$dest_dir/$output_file"
                echo  >> "$dest_dir/$output_file"
                filename=$(basename $file)
                echo "$filename" >> "$dest_dir/$output_file"
                prev_file=$file
            fi
            echo $file >> "$dest_dir/$paths_file"
        fi
    done
done

if [[ -d $dest_dir ]]; then
    for file in $(ls $dest_dir/*_found.txt); do
        if [[ -s $file ]]; then
            echo "Found cookies saved to $file"
        else
            echo "Warning: $file is empty."
        fi
    done
else
    echo "Directory $dest_dir not found!"
fi

if [[ -d $dest_dir ]]; then
    for file in $(ls $dest_dir/*_paths.txt); do
        if [[ -s $file ]]; then
            echo "Paths to files saved to $file"
        else
            echo "Warning: $file is empty."
        fi
    done
else
    echo "Directory $dest_dir not found!"
fi
