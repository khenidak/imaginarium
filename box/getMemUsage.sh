#!/bin/bash


free -m | awk 'NR==2{printf "MEM:%.2f%%  ",$3*100/$2 }';

