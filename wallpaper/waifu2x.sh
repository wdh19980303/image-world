#!/bin/bash
OLD_IFS=${IFS}
IFS=$'\n'
function waifu2x_image() {
    source_image=${1}
    ratio=${2}
    source_image_type=${source_image##*.}
    source_image_name=${source_image%.*}
    waifu2x_image="${source_image_name}""-""${ratio}X.${source_image_type}"
    echo "$waifu2x_image"
    if [ -f "${source_image}" ]; then
        if waifu_exec "${source_image}" "${waifu2x_image}" "${ratio}"; then
            rm "${source_image}"
            mv "${waifu2x_image}" "${source_image}"
        fi
    fi
}

function waifu_exec() {
    # echo "${2}"
    waifu2x-converter-cpp -i "${1}" -q 101 --scale-ratio "${3}" --noise-level 3 -o "${2}" >>/dev/null
    return $?
}

STANDARD_WIDTH=2560
STANDARD_HEIGHT=1440
for IMAGE in $(ls | grep -E "*png|*jpg"); do
    image_resolution=$(identify "${IMAGE}" | awk -F' ' '{print $(NF-6)}')
    # echo "$image_resolution"
    image_width=$(echo "${image_resolution}" | awk -F'x' '{print $1}')
    image_height=$(echo "${image_resolution}" | awk -F'x' '{print $2}')
    if ((image_height < STANDARD_HEIGHT)) || ((image_width < STANDARD_WIDTH)); then
        echo "${IMAGE}"
        if [ "$1" == "-c" ]; then
            ratio=1
            while ((image_height < STANDARD_HEIGHT)) || ((image_width < STANDARD_WIDTH)); do
                ((ratio += 1))
                ((image_height *= ratio))
                ((image_width *= ratio))
            done
            # echo ${ratio}
            waifu2x_image "${IMAGE}" ${ratio}
        fi
    fi
done
IFS=${OLD_IFS}