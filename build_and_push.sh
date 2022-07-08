#!/usr/bin/env bash
# Usage 
# ./build_and_push.sh
# VARS
dailytag=$(date -I)
imagename='pilbbq/rclone'
dailyimage="$imagename:$dailytag"
latestimage="$imagename:latest"
maxmind_licensekey="$1"
# SCRIPT
# Build daily and latest
docker build --no-cache -t $dailyimage -t $latestimage .
# Push all tags
docker push -a $imagename
