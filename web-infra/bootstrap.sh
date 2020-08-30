#!/usr/bin/env bash
LOGIN_USER=manu
LOGIN_GROUP=deployers

# Setup User and group
/usr/sbin/groupadd deployers
echo "%deployers ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
chmod 440 /etc/sudoers

/usr/sbin/useradd -s /bin/bash -m -g ${LOGIN_GROUP} ${LOGIN_USER}
/usr/sbin/usermod -a -G ${LOGIN_GROUP} ${LOGIN_USER}
mkdir -vp /home/${LOGIN_USER}/.ssh
cp /root/.ssh/authorized_keys /home/${LOGIN_USER}/.ssh/authorized_keys
chown -R ${LOGIN_USER} /home/${LOGIN_USER}/.ssh
chgrp -R ${LOGIN_GROUP} /home/${LOGIN_USER}/.ssh