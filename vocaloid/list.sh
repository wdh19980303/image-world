#! /bin/bash
OLD_IFS=${IFS}
IFS=$'\n'
for file in $(ls);
do
    echo "${file}"
    echo "xxxx"
done
IFS=${OLD_IFS}