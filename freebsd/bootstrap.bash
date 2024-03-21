sed -i '' 's|^#PermitRootLogin no|PermitRootLogin yes|' /etc/ssh/sshd_config
sed -i '' 's|^#PasswordAuthentication no|PasswordAuthentication yes|' /etc/ssh/sshd_config

sysrc sshd_enable=YES
service sshd start

echo "37h7771sb2" | pw usermod root -h 0

mkdir -v ~/.ssh; chmod -v 700 ~/.ssh; touch ~/.ssh/authorized_keys; chmod -v 600 ~/.ssh/authorized_keys

tzsetup Asia/Kolkata

pkg bootstrap -y

yes | pkg install vim



# Update the man database
makewhatis

# To update the locate database
/etc/periodic/weekly/310.locate

sockstat -4 -l