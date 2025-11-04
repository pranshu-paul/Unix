# Download the python script
wget https://packages.openvpn.net/as/scripts/post_auth_mac_address_checking.py -O /root/mac.py

# Navigate to the scripts directory
cd /usr/local/openvpn_as/scripts

# Update the post-auth script
./sacli --key "auth.module.post_auth_script" --value_file=/root/mac.py ConfigPut

# Restart the openvpn process
./sacli start

# Update the MAC address.
./sacli --user "openvpn" --key "pvt_hw_addr" --value "70:d8:23:5f:1a:f9" UserPropPut

# Restart the openvpn process.
./sacli start

# To delete the variable
./sacli --user "openvpn" --key "pvt_hw_addr" UserPropDel; ./sacli start

# To print the hw addr
./sacli --user "openvpn" UserPropGet

# Check the post auth logs
egrep "POST_AUTH" /var/log/openvpnas.log