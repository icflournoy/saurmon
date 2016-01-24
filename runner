#!/bin/bash

[ -d reports ] || mkdir reports

while read n;
do
    HOST=${n%:*}
    PASS=${n#*:}
    echo -e "======START:\t$HOST\t======"
    sshpass -p "$PASS" ssh -o UserKnownHostsFile=known_hosts -o StrictHostKeyChecking=no root@$HOST 'bash -s' < payload.sh | tee reports/$HOST.log
	sshpass -p "$PASS" scp -o UserKnownHostsFile=known_hosts -o StrictHostKeyChecking=no root@$HOST:~/healthy/* reports/
    echo -e "======END:\t$HOST\t======\n\n"
done < hosts.list
echo End
