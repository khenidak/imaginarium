#!/bin/bash
set -e
set -o pipefail
set -u

# functions in this script are defined as `net::utils::func-name(..)`
# common helpers to aid in debugging networking problems


# lists all the network devices on current namespace
# +parms: none
function net::utils::list_device()
{
	basename -a /sys/class/net/*
}
