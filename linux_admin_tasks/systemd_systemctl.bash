# systemctl - systemctl control
# Package = systemd

# To list all services with description.
# -a=all -t=type
systemctl -at service

# To list all targets.
systemctl -at target

# To get list of enabled units.
systemctl list-unit-files --state=enabled

# To start and enable a service or socket.
systemctl enable --now SERVICE|SOCKET

# To change systemctl target.
systemctl isolate multi-user-target

# To change default target.
systemctl set-default graphical.target

# To check which is the current default target.
systemctl get-default

# To change into rescue target.
systemctl emergency

# To reboot, shutdown, hibernate.
systemclt {reboot|poweroff|hibernate}

# To view a unit file.
systemctl cat sshd

# To override a unit file.
systemctl edit SERVICE|SOCKET

# To list failed services.
systemctl list-units --state failed --type service


# To clean the temp directory.
systemd-tmpfiles --clean

# To start a system socket only not the process.
# This opens an endpoint so that the process can be started remotely.
systemctl start sshd.socket

# To list the active sockets.
systemctl list-units --type socket


# To mask a unit file.
# To prevent a reboot on the machine remotely.
systemctl mask ctrl-alt-del.target

# To unmask a unit file.
systemctl unmask ctrl-alt-del.target