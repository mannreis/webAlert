#!/bin/bash

# REQUIRES:
#           notify-send
#           paplay

URL=$1
if [ "0" == "${#URL}" ]; then
    echo "Specify URL please"
    exit
fi
SOUND='/home/einstein/Android/Sdk/platforms/android-24/data/res/raw/fallbackring.ogg'
curl $URL -L --compressed -s > .new.html
html2text < .new.html > .new.txt
cp .new.txt .old.txt

for (( ; ; )); do
    mv .new.txt .old.txt 2> /dev/null
    curl $URL -L --compressed -s > .new.html
    html2text < .new.html > .new.txt
    DIFF_OUTPUT="$(diff .new.txt .old.txt)"
    if [ "0" != "${#DIFF_OUTPUT}" ]; then
        paplay $SOUND
        notify-send 'URL - alert'
        sleep 5
        rm .old.txt .new.txt .new.html
        exit
    fi
    sleep 1
done
