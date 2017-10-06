#!/bin/sh
# this script use libfdk_aac
# $ brew install ffmpeg --with-fdk-aac

set -e

find . -name "*.webm" -exec ffmpeg -i {} -c:v libx264 -c:a libfdk_aac {}.mp4 \;

