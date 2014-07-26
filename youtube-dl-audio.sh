#!/bin/bash

if [ "$#" -eq 0 ]; then
    echo "USAGE: $0 URL"
    exit -1
fi

youtube-dl --extract-audio --audio-format mp3 $1
