# -- To install vncserver in rhel 7
# -- Perform all these tasks as root user or use sudo.
# -- Replace USER_NAME with user which you want to use.

# -- If the xterm is closed from vncviewer then use below command from putty or any other ssh client with that USER_NAME.
export DISPLAY=:1 && nohup xterm &> /dev/null &

yum -y install tigervnc-server xterm
cp /usr/lib/systemd/system/vncserver@.service /etc/systemd/system/
vi /etc/systemd/system/vncserver@.service

# -- Change the below line in that unit file.
ExecStart=/usr/bin/vncserver_wrapper USER_NAME %i

# Add the below line in unit file /etc/systemd/system/vncserver@.service
PIDFile=/home/USER_NAME/.vnc/%H%i.pid
# After adding this line exit vi editor.

su - USER_NAME
vncpasswd 				# Don't use view only password press "n"
^D 						# Get back to root user.
systemctl daemon-reload

# vncserver@:n, n can be any number.
# If n=7, then port number will be 5907
# n can be used upto 1 - 10.
systemctl enable --now vncserver@:1.service


# Or we can use these cmds below. If we don't want to make an unit file for other user.
vncserver :1		--		To start vncserver at :1 display.
vncserver -kill :1		--		To kill a vnc session.


# Use port forwarding to use vnc.
ssh -L 590n:localhost:590n -l USER_NAME IP_ADDRESS

# Add port on firewall.
# firewall-cmd --add-port=590n/tcp --permanent <-- This is optional if you are using your server on your vpn only. VNC IS NOT SECURE BY DEFAULT.
firewall-cmd --add-port=5901/tcp --permanent && firewall-cmd --reload

# To create vncserver service for other user.
# Rest all the procedure is same.
cp /usr/lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver-USER_NAME@.service




#########################################################################################################
# Vnc server for rhel 8
sudo su -

dnf install -y tigervnc-server tigervnc-server-module xterm
su - USER_NAME
vncpasswd
^D
restorecon -RFv $HOME/.vnc

vi	/etc/tigervnc/vncserver.users
	:1=username -- add this line to above file

firewall-cmd --add-port=5901/tcp
su - USER_NAME
vncserver

# To kill vncserver.
vncserver -kill :1




#####################################################################################################
# Change <USER_NAME> with the user-name for which it need to be used.
# DO NOT open firewall on public ip instead use ssh tunneling.
# ssh -L 5901:localhost:5901 <USER_NAME>@<IP_ADDRESS>
# System wide configuration /etc/tigervnc/vncserver-config-defaults.
# User specific configuration /home/<USER_NAME>/.vnc/config

# export DISPLAY=:1 && nohup xterm &> /dev/null & -- From ssh client.

User=oracle
# Installs tigervnc-server and xterm.
dnf -y install tigervnc-server xterm

# Changes vnc password for the user.
su - $User -c vncpasswd

# assign user-name for the vnc server.
echo :1="${User}" >> /etc/tigervnc/vncserver.users

cat > /usr/share/xsessions/xterm.desktop << EOF
[Desktop Entry]
Exec=xterm
TryExec=xterm
Type=Application
DesktopNames=XTERM
EOF

# Adds session gnome or xterm.
echo session=xterm >> /etc/tigervnc/vncserver-config-defaults

# Adds default size for the vnc server.
echo geometry=1366x768 >> /etc/tigervnc/vncserver-config-defaults

# Restores the .vnc folder default context for SELinux.
restorecon -rv /home/$User/.vnc/

# Add this line to /usr/lib/systemd/system/vncserver@.service
Restart=always

# Reloads all daemons.
systemctl daemon-reload

# Starts and enable the vncserver service.
systemctl enable --now vncserver@:1

# Opens port for vnc on firewall.
firewall-cmd --add-port=5901/tcp --permanent

# Reloads firewall to make changes persistant.
firewall-cmd --reload

# Clean any existing files in /tmp/.X11-unix environment except X0
find /tmp/.X11-unix/ -name "X[1-9]*" | xargs rm -f




# User specific configuration file.
touch /home/$User/.vnc/config

# Changes permission for user specific configuration.
chmod 766 /home/$User/.vnc/config









#!/bin/bash -e

dnf -y install tigervnc-server xterm

# change this line or uncomment.
vim /etc/gdm/custom.conf
WaylandEnable=False

find /tmp/.X11-unix/ -name "X[1-9]*" | xargs rm -f

useradd paul
su - paul -c vncpasswd

cat > /usr/share/xsessions/xterm.desktop << EOF
[Desktop Entry]
Exec=xterm
TryExec=xterm
Type=Application
DesktopNames=XTERM
EOF

echo 'session=xterm' >> /etc/tigervnc/vncserver-config-defaults

# su - paul -c "openssl req -new -x509 -days 30 -nodes -newkey rsa:2048 -keyout ~/.vnc/private.key -out ~/.vnc/public.cert -subj "/C=US/ST=Ca/L=Sunnydale/CN=$(hostname -f)""
# cat >> /etc/tigervnc/vncserver-config-defaults << EOF
# securitytypes=x509Vnc
# X509Key=/home/paul/.vnc/private.key
# X509Cert=/home/paul/.vnc/public.cert
# EOF


echo :1=paul >> /etc/tigervnc/vncserver.users

restorecon -RFv /home/paul/.vnc/

vim /usr/lib/systemd/system/vncserver@.service
Restart=always # -- Add this line below ExecStar=  in service coloumn at 39th number line.

systemctl daemon-reload

systemctl start vncserver@:1

systemctl is-active vncserver@:1

ss -lntp | grep vnc

firewall-cmd --add-port=5901/tcp && firewall-cmd --reload