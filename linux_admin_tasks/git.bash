# Generate a key pair.
ssh-keygen -t rsa -N "" -b 4096 -C "centos"

# Paste the public key on github.com

# Clone the repository locally.
git clone git@github.com:pranshu-paul/Unix.git /root/repo/git

# To set the global email and user name.
git config --global user.email "paulpranshu@gmail.com"
git config --global user.name "Pranshu Paul"

# Commit the changes with a message.
git commit -a -m commit

# Push the changes.
git push