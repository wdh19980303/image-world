#!/bin/bash
IMAGE_PREFIX="wallpaper"
# for image_name in wallhaven*; do
#     image_type=${image_name##*.}
#     # printf "%03d\n" ${MAX_INDEX}
#     image_no="$(printf "%03d" ${MAX_INDEX})"
#     echo "${image_no}"
#     ((MAX_INDEX += 1))
#     mv "${image_name}" "${IMAGE_PREFIX}${image_no}.${image_type}"
#     # echo "${image_name}"
# done

function get_image_resolution() {
    image_resolution=$(identify "${1}" | awk -F' ' '{print $3}')
    image_width=$(echo "${image_resolution}" | awk -F'x' '{print $1}')
    image_height=$(echo "${image_resolution}" | awk -F'x' '{print $2}')
    image_size[0]=${image_width}
    image_size[1]=${image_height}
    echo "${image_size[*]}"
}

function get_image_direction() {
    IFS=" " read -r -a image_size <<<"$(get_image_resolution "${1}")"
    if ((image_size[0] > image_size[1])); then
        echo "h"
    else
        echo "v"
    fi
}

function image_not_exist_max() {
    index=$1
    image_index="$(printf "%03d" "${index}")"

    while (($(find . -maxdepth 1 -name "${IMAGE_PREFIX}${2}-${image_index}*" | wc -l) > 0)); do
        ((index += 1))
        image_index=$(printf "%03d" ${index})
    done
    echo ${index}
}

index[0]=1
index[1]=1
dir_index
for image_name in *; do
    image_type=${image_name##*.}
    if [ "${image_type}" = "png" ] || [ "${image_type}" = "jpg" ] || [ "${image_type}" = "jpeg" ]; then
        direction=$(get_image_direction "${image_name}")
        if [ "h" = "${direction}" ]; then
            dir_index=0
        else
            dir_index=1
        fi

        if ! (echo "${image_name}" | grep -Pq "${IMAGE_PREFIX}${direction}-\d{3,}\..*"); then
            echo "${image_name}"
            index[dir_index]=$(image_not_exist_max ${index[dir_index]} "${direction}")
            image_index=$(printf "%03d" "${index[dir_index]}")
            echo "mv ${image_name}  ${IMAGE_PREFIX}${direction}-${image_index}.${image_type}"
            mv "${image_name}" ${IMAGE_PREFIX}"${direction}-${image_index}"".""${image_type}"
            ((index[dir_index] = index[dir_index] + 1))
        fi
    fi
done
