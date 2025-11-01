# Creating a chroot jail.

# Create a directory for chroot.
mkdir -p /chroot

# Create directories for the binaries and libraries just like the file system.
mkdir -p /chroot/{bin,lib64,lib}

# Copy the required utilities in chroot.
cp -v /bin/{bash,ls} /chroot/bin

# Copy the libraries of the utilities as well.
ldd /bin/bash

ldd /bin/bash | grep -o '\/[^ ]*'

bash_libs=($(ldd /bin/bash | grep -o '\/[^ ]*'))

cp -v "${bash_libs[@]}" /chroot/lib64

ls_libs=($(ldd /bin/ls | grep -o '\/[^ ]*'))

cp -v "${ls_libs[@]}" /chroot/lib64

# Create environment file for the chroot.
cat << EOF > /chroot/chroot.env
PATH=/chroot/bin
EOF

# Access the chroot jail.
chroot /chroot /bin/bash --rcfile /chroot/chroot.env
