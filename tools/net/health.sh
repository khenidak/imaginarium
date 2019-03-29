#!/bin/bash

# functions in this script are defined as `net::health::func-name(..)`
# common helpers to aid in debugging networking problems

set -e
set -u
set -o pipefail

# finds kernel tx/rx errors
# info: https://www.dynatrace.com/news/blog/detecting-network-errors-impact-on-services/
# +params:
# ++ $1: device_name -- mandatory
function net::health::has_buffer_errors()
{
	echo "."
}

# finds device errors 
# info: https://www.dynatrace.com/news/blog/detecting-network-errors-impact-on-services/
function net::health::has_device_errors()
{
	echo "."
}

# finds tcp errors
function net::health::has_tcp_errors()
{
 	echo "."
}
