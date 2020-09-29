#!/bin/bash
# Update to latest version of ESXi 6.5 as of 03/2020
# Author: Jeff Starke

read -r "What is the IP of the target ESX server? " $esxip

ssh root@$esxip
for i in $(esxcli vm process list | grep World | cut -d" " -f 6);
 do esxcli vm process kill --type=soft --world-id=$i; done
esxcli system maintenanceMode set --enable true
esxcli network firewall ruleset set -e true -r httpClient
esxcli software profile update -p ESXi-6.7.0-20200403001-standard -d https://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml


esxcli network firewall ruleset set -e false -r httpClient

esxcli system shutdown reboot --reason "Performing update."
