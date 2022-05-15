#!/bin/bash
i=1
prefix="wallhaven-"
regex="${prefix}\d+\..*"

function is_format_name() {
    if (($# != 2)); then
        return 1
    fi
    regex=${1}
    file=${2}

    if echo "${file}" | grep -Pq "${regex}"; then
        return 0
    else
        return 1
    fi
}

function get_image_no() {
    if (($# != 2)); then
        echo "-1"
    fi
    regex=${1}
    file=${2}
    if echo "${file}" | grep -Pq "${regex}"; then
        echo -e "${file}" | grep -oP "\d*" | sed -r 's/0*([0-9])/\1/'
    else
        echo "-1"
    fi
}

function git_upload_image() {
    image=$1
    echo "${image}"
    git add "${image}"
    git commit -m "${image}"
    git push origin master
}

function rename_format() {
    is_rename=0
    is_upload=0

    while getopts "cg" opt; do
        case $opt in
        c)
            echo "rename mode"
            is_rename=1
            ;;
        g)
            echo "upload mode"
            is_upload=1
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            ;;
        esac
    done

    max_no=0
    # 获取不规则命名的文件和最大文件序号
    for file in $(ls | grep -E "*png|*jpg"); do
        if is_format_name "${regex}" "${file}"; then
            file_no=$(get_image_no "${regex}" "${file}")
            if ((max_no < file_no)); then
                ((max_no = file_no))
            fi
        else
            image_list="${image_list} ${file}"
        fi
    done

    # 文件重命名
    ((i = max_no + 1))
    for image_name in $image_list; do
        image_type=${image_name##*.}
        image_no=$(printf "%03d\n" ${i})
        new_image="${prefix}${image_no}.${image_type}"
        printf "%-40s %s\n" "${image_name}" "${new_image}"

        if [ ${is_rename} == 1 ]; then
            mv "${image_name}" "${new_image}"
        fi

        if [ ${is_upload} == 1 ]; then
            git_upload_image "${new_image}"
        fi

        ((i += 1))
    done

}

rename_format "${1}" "${2}"
