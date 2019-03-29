#!/bin/bash
set -e
set -o pipefail
# switch kubectl config
function kubeswitch()
{
	local configFile="$1"
	configFile="${HOME}/.kube/${configFile}"
	if [ -f $configFile ]; then
			export KUBECONFIG="${configFile}"
			echo "switched to ${KUBECONFIG}"
  else
			echo "File [$configFile] does not exist.."
	fi
}
