#!/bin/bash


alias k166="docker run --rm --net=host -it -v ~/:/host/ -v ~/.kube:/root/.kube/ gcrio.azureedge.net/google_containers/hyperkube-amd64:v1.6.6 "/kubectl""


source ~/.scripts/aliases_hcp.sh
