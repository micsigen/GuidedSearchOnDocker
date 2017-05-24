#!/bin/bash

if [ "${AUTHORIZED_KEYS}" != "**None**" ]; then
    echo "=> Found authorized keys"
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh
    touch /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    IFS=$'\n'
    arr=$(echo ${AUTHORIZED_KEYS} | tr "," "\n")
    for x in $arr
    do
        x=$(echo $x |sed -e 's/^ *//' -e 's/ *$//')
        cat /root/.ssh/authorized_keys | grep "$x" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "=> Adding public key to /root/.ssh/authorized_keys: $x"
            echo "$x" >> /root/.ssh/authorized_keys
        fi
    done
fi

if [ ! -f /.root_pw_set ]; then
        /set_root_pw.sh
        ssh-keygen -A
fi

/etc/init.d/ps start
/etc/init.d/cas start
/etc/init.d/workbench start

sleep 5s

curl -v -FoldPwd=admin -FnewPwd=Oracleatg123 -FnewPwdConfirm=Oracleatg123 \
http://admin:admin@localhost:8006/ifcr/system/userManager/user/admin.changePassword.json

sleep 5s

curl -v -FoldPwd=admin -FnewPwd=Oracleatg123 -FnewPwdConfirm=Oracleatg123 \
http://admin:admin@localhost:8006/ifcr/system/userManager/user/admin.changePassword.json

# /bin/su - endeca -c /home/endeca/bin/installDiscoverApp.sh

echo $'\n'
echo "Container started successfully!"

exec /usr/sbin/sshd -D