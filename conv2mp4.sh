#!/bin/sh
# this script use libfdk_aac
# $ brew install ffmpeg --with-fdk-aac

set -e

for path in "$@"
do
    ffmpeg -i $path -c:v libx264 -c:a libfdk_aac {}.mp4
done

