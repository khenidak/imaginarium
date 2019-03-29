#!/bin/bash

drives="sda|sdc|sdd"
rkbytes="$(iostat | grep -E "(sda|sdc|sdd)" | awk '{sum += $3} END {printf "%d", sum}')"
wkbytes="$(iostat | grep -E "(sda|sdc|sdd)" | awk '{sum += $4} END {printf "%d", sum}')"

echo -n "IO:$rkbytes/$wkbytes"
