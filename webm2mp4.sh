#!/bin/sh

set -e

find . -name "*.webm" -exec ffmpeg -i {} -c:v libx264 -c:a libfdk_aac {}.mp4 \;

