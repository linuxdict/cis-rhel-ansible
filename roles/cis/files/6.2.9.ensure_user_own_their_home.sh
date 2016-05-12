#!/bin/bash

if grep -q -i 'release 7' /etc/redhat-release ; then
    # this is el7+
    last_uid=1000
else
    last_uid=500
fi

cat /etc/passwd | awk -F: '{ print $1 " " $3 " " $6 }' | while read user uid dir; do
 if [ $uid -ge $last_uid -a -d "$dir" -a $user != "nfsnobody" ]; then
 owner=$(stat -L -c "%U" "$dir")
 if [ "$owner" != "$user" ]; then
 echo "The home directory ($dir) of user $user is owned by $owner."
 fi
 fi
done
