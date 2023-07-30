mkdir -p /chroot

mkdir -p /chroot/{bin,lib64,lib}

cp -v /bin/{bash,ls} /chroot/bin

ldd /bin/bash

ldd /bin/bash | grep -o '\/[^ ]*'

bash_libs=($(ldd /bin/bash | grep -o '\/[^ ]*'))

cp -v ${bash_libs[@]} /chroot/lib64

ls_libs=($(ldd /bin/ls | grep -o '\/[^ ]*'))

cp -v ${ls_libs[@]} /chroot/lib64

cat << EOF > /chroot/chroot.env
PATH=/chroot/bin
EOF

chroot /chroot /bin/bash --rcfile /chroot/chroot.env
