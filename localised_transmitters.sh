#!/bin/bash

deps=( sqlite3 )
depsMet=true

for dep in "${deps[@]}" ; do
    [[ -f $(which $dep) ]] || { echo "$dep not found.";depsMet=false; }
done

if [ "$depsMet" = false ] ; then
    echo
    echo 'Dependencies not met, exiting...'
    exit
fi

read -p 'Enter lat, long: ' lat_long
REGEX_LAT_LONG="^(-?[0-9]+.[0-9]+), ?(-?[0-9]+.[0-9]+)$"
[[ $lat_long =~ $REGEX_LAT_LONG ]]
if [ "$?" = 1 ] ; then
  echo 'Invalid coordinates'
  exit
fi
lat=${BASH_REMATCH[1]}
long=${BASH_REMATCH[2]}

read -p 'Enter distance in km: ' distance
# approximation for australia
approx_offset=$(echo "0.00675 * $distance" | bc)
lat_min=$(echo "$lat - $approx_offset" | bc)
lat_max=$(echo "$lat + $approx_offset" | bc)
long_min=$(echo "$long - $approx_offset" | bc)
long_max=$(echo "$long + $approx_offset" | bc)

read -p 'Enter minimum frequency in MHz: ' freq_min_mhz
read -p 'Enter maximum frequency in MHz: ' freq_max_mhz
freq_min_hz=$(echo "$freq_min_mhz * 1000000" | bc)
freq_max_hz=$(echo "$freq_max_mhz * 1000000" | bc)

sqlite3 rrl.db \
  ".param set :lat_min \"'$lat_min'\"" \
  ".param set :lat_max \"'$lat_max'\"" \
  ".param set :long_min \"'$long_min'\"" \
  ".param set :long_max \"'$long_max'\"" \
  ".param set :freq_min_hz \"'$freq_min_hz'\"" \
  ".param set :freq_max_hz \"'$freq_max_hz'\"" \
  ".mode csv" \
  ".headers on" \
  ".output localised_transmitters_output.csv" \
  ".read localised_transmitters.sql" 

if [ $? -ne 0 ]; then
    echo 'Creation of query results failed'
    exit
fi
