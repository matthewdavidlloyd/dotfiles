#!/usr/bin/env bash

music=$(osascript ${HOMES}/.applescripts/spotify.scpt)
weather=$(${HOME}/.scripts/ansiweather -a false -u metric -l "RoyalLeamingtonSpa,GB"  | cut -f1 -d "-" | sed 's/Current weather in //g' | sed 's/=> //' | sed 's/Royal Leamington Spa //g')
timey=`date -u +'%H:%M'`

if [[ $music ]]; then
  echo "$music |$weather| $timey"
else
  echo "$weather| $timey"
fi;
