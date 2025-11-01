# Download the go tar ball.
wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz

# Install the go extension for vim
dnf -y install vim-go

# Extract the go tar ball.
tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz 

# Export the required variables.
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Source the environment file.
source ~/.bashrc

# To install the go IDE features
go install golang.org/x/tools/gopls@latest

# Check the version.
go version

# Initialize the file name.
go mod init main

# Add or remove the missing packages
go mod tidy