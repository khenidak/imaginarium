#~/bin/bash

top -bn1 | grep load | awk '{printf "CPU:%.2f%", $(NF-2)}';

