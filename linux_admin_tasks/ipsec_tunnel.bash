# Install IPSec packages.
yum -y install libreswan

# The above package adds some new kernel parameters in /etc/sysctl.d/50-libreswan.conf.
# To apply those parameter live.
sysctl --system

# Start the IPSec service.
systemctl enable --now ipsec

# Open the ports 500 and 4500 of UDP on both the nodes.
firewall-cmd --add-port={500,4500}/udp
firewall-cmd --add-port={500,4500}/udp --permanent

# Generate a RSA key pair on each host.
ipsec newhostkey

# The above command generates two keys as "ckid".

# Use the below command to generate the leftrsakey and rightrsakey.
ipsec showhostkey --left --ckaid <key>
ipsec showhostkey --right --ckaid <key>

# In the /etc/ipsec.d directory, create a new my_host-to-host.conf.
conn testtunnel
	leftid=@west
	left=10.122.0.2
	leftrsasigkey=0sAwEAAbeQCjuUsaylrnG5EXzqIGsepsuIhfGGDGqqrnWaoSfPP7sOnoOlTFCuSBSwWnKggbfDufAYlTjuxLgbCF/ri3vFbNrYP1KeWqQzLKaNSNjXT8YjtIhDpS0wgeL3cHKxk7F0sBFubYSnPzKuv6waJE4R+Yfx/xGlT8FSO2/tjQKdbVWSH3Ae6j2bQikZT9zrgUezegKVsgTTlNQNSGY4YxD8wTjpdKfjPEmra5UMWFzD5OR7AjNrREuvI9c4lo73KNko3bfSF0skXp6UUDnJS96MvYF3uIhpr8ZhmeRjs3fSjnTiWxnE24jBfwGzG81Wnr4eNFXmFVF/pTaJWto7v8E8NuCuSassxQMcWzKskvEEUGcX+uFmT6CzD8ehjRu/nZSLqzi19bcQF8bpGmcMZO5P7abtaoLFrE5ZUZdya31pkkjQYz7qRLmvllob8aCcJuEaOVL8ym3myPkizSH2t9nGSdUAnQaNQkQG3ryWvhJzSHqKkyfuPi9X3/6mpSn6FTo5Fss=
	
	rightid=@east
	right=10.0.0.241
	rightrsasigkey=0sAwEAAbeQCjuUsaylrnG5EXzqIGsepsuIhfGGDGqqrnWaoSfPP7sOnoOlTFCuSBSwWnKggbfDufAYlTjuxLgbCF/ri3vFbNrYP1KeWqQzLKaNSNjXT8YjtIhDpS0wgeL3cHKxk7F0sBFubYSnPzKuv6waJE4R+Yfx/xGlT8FSO2/tjQKdbVWSH3Ae6j2bQikZT9zrgUezegKVsgTTlNQNSGY4YxD8wTjpdKfjPEmra5UMWFzD5OR7AjNrREuvI9c4lo73KNko3bfSF0skXp6UUDnJS96MvYF3uIhpr8ZhmeRjs3fSjnTiWxnE24jBfwGzG81Wnr4eNFXmFVF/pTaJWto7v8E8NuCuSassxQMcWzKskvEEUGcX+uFmT6CzD8ehjRu/nZSLqzi19bcQF8bpGmcMZO5P7abtaoLFrE5ZUZdya31pkkjQYz7qRLmvllob8aCcJuEaOVL8ym3myPkizSH2t9nGSdUAnQaNQkQG3ryWvhJzSHqKkyfuPi9X3/6mpSn6FTo5Fss=
	authby=rsasig
	
	auto=start


	
# Verify the syntax.
ipsec verify

# After importing the keys, restart ipsec service.
systemctl restart ipsec

# Load the connection.
ipsec auto --add testtunnel

# Start the tunnel.
ipsec auto --up testtunnel


# Configuring a site-to-site VPN.
# To join the two remote networks together.

# Copy the my_host-to-host.conf created earlier to a new file my_site-to-site.conf
cp /etc/ipsec.d/my_host-to-host.conf /etc/ipsec.d/my_site-to-site.conf


# Add the following configuration in the file my_site-to-site.conf.
conn <subnet_name>
	also=<tunnel_name>
	leftsubnet=192.168.1.0/24
	rightsubnet=192.168.2.0/24
	auto=start
	
	conn <tunnel_name>
	leftid=@west
	left=192.1.2.23
	leftrsasigkey=<ckid>
	
	rigthid=@east
	right=192.1.2.45
	rightrsakey=<ckid>
	authby=rsasig
	
# Troubleshooting.

# Check the process.
ps -ef | grep pluto

# Check the socket.
ss -lnup | grep plutp

# Check logs.
journalctl -r -t pluto