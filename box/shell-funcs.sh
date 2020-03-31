#!/bin/bash
# TODO: add function for retabing
# $ find . -name '*.ts' -exec vim +"set tabstop=4 shiftwidth=4 expandtab | retab | wq" {} \;
set -e 
set -o pipefail

# Stop and rm containers 
nuke-docker-ps () { docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) ;}
nuke-docker-img () { docker rmi -f $(docker images -q) ;}
iDev(){  tmux attach -t kal || tmux new -s kal; }
sDev(){  tmux attach -t "$1" || tmux new -s "$1" ;}

#python -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)' < vector_endpoints.json > vector_endpoints.yaml

# list openssl cipher suits 
# OpenSSL requires the port number.
function ciphers_supported()
{
  SERVER="$1"
  DELAY=1
  ciphers=$(openssl ciphers 'ALL:eNULL' | sed -e 's/:/ /g')

  echo Obtaining cipher list from $(openssl version).

  for cipher in ${ciphers[@]}
  do
    echo -n Testing $cipher...
    result=$(echo -n | openssl s_client -cipher "$cipher" -connect $SERVER 2>&1)
    if [[ "$result" =~ ":error:" ]] ; then
      error=$(echo -n $result | cut -d':' -f6)
      echo NO \($error\)
    else
     if [[ "$result" =~ "Cipher is ${cipher}" || "$result" =~ "Cipher    :" ]] ; then
      echo YES
     else
      echo UNKNOWN RESPONSE
      echo $result
     fi
    fi
  sleep $DELAY
  done
}

# TMUX 
function current-tmux-session-name()
{
	for s in $(tmux list-sessions -F '#{session_name}'); do
			tmux list-panes -F '#{pane_tty} #{session_name}' -t "$s"
	done | grep "$tty" | awk '{print $2}'
}

function tmxv() { tmux split-window -h -c "$(pwd)" "$* ;/bin/bash";}
function tmxh() { tmux split-window -v -c "$(pwd)" "$*; /bin/bash";}
function tmxt() { tmux new-window -n "$1" -c "$(pwd)" "${*:2} ;/bin/bash";}

