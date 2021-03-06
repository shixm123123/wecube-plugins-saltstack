#!/bin/bash
set -e -x

if [[ $# < 1 ]]; then
  echo "please input the host ip for new added host"
  exit
fi

salt-key -d $1 -y
exit 0 

#for salt-msster ha
mastersArray=("{{minion_master_ip}}")

targetFile=/etc/salt/master_roster
rm -rf ${targetFile}

for host in ${mastersArray[@]}
do
  echo "minion_$host:">> ${targetFile}
  echo "  host: $host" >> ${targetFile}
  echo "  port: {{minion_port}} >> ${targetFile}
  echo "  user: root" >> ${targetFile}
  echo "  passwd: {{minion_passwd}}" >> ${targetFile}
  echo "  sudo: True" >> ${targetFile}
  echo "  timeout: 10" >> ${targetFile}
done


hosts=$1
hostsArray=(${hosts//,/ })

for host in ${hostsArray[@]} 
do
   salt-ssh '*'  --roster-file $targetFile  -i -r "docker exec wecube-plugins-saltstack salt-key -d $host -y"
done




