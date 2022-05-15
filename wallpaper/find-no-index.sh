#!/bin/bash

i=1
while ((i < 279)); do
    image_no=$(printf "%03d\n" ${i})
    if ! [ -f "wallhaven-${image_no}.png" ] && ! [ -f "wallhaven-${image_no}.jpg" ] ;
    then
        echo wallhaven-"${image_no}"
    fi
    ((i += 1))
done
