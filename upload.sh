#!/bin/bash
OLD_IFS=${IFS}
IFS=$'\n'
i=1
for dir_detail in $(find . -type f |  grep -E "png|jpg|jpeg");
do
    echo 
    echo start upload
    echo "${dir_detail}"
    cmd_git_add="git add ${dir_detail}"
    cmd_git_commit="git commit -m \"${dir_detail}\""
    cmd_git_push="git push origin master"
    echo "${cmd_git_add}"
    git add "${dir_detail}"
    echo "${cmd_git_commit}"
    git commit -m \""${dir_detail}"\"
    echo "${cmd_git_push}"
    git push origin master
    ((i+=1))
done
echo 
echo "upload count:" $i
IFS=${OLD_IFS}
