#!/bin/sh

set -e

find . -name "*.mkv" -exec ffmpeg -i {} -c:v libx264 -c:a libfdk_aac {}.mp4 \;

