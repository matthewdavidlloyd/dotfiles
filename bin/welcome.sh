#!/usr/bin/env bash

# Overview
echo "Today is $(date)"
echo -en "Outside "
${HOME}/.scripts/ansiweather | sed -e 's/^[ \t ]*//'

# Network info
echo "Network Info"
echo -n "External IP : "
curl http://ipecho.net/plain; echo
echo -n "Local IP : "
ipconfig getifaddr en0
