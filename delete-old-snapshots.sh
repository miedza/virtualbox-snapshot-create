#!/bin/sh

# Deletes old snapshots

usage ()
{
  echo "usage: $0 [number of snapshots to keep]"
  exit
}

[ -n "$1" ] || usage

VM_IDS=$(VBoxManage list vms | awk -F '"' '{print $2}')

OIFS="${IFS}"
NIFS=$'\n'

IFS="${NIFS}"

for vm in ${VM_IDS}
do
	echo "Deleting all but latest $1 snapshots from $vm"
	VBoxManage snapshot "$vm" list | awk '/UUID/ {gsub ("\\)", "") ; if ( $NF != "" ) { lista[i] = $NF; i++ } } END { for (i=1; i<=length(lista)-2-'$1' ; i++) print lista[i]}' | xargs -L1 VBoxManage snapshot "$vm" delete

	logger "Finished snapshot deletion of $vm"
	
	echo "Finished snapshot deletion of $vm"

	printf "\n\n"
done

IFS="${OIFS}"


