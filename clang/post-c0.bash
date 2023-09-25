
# Install postgresql library.
dnf -y install libpq-devel.x86_64

# Change all connection authentication methods to md5.
vim pg_hba.conf

# To compile a C code with postgresql library.
gcc -o connect connect.c -lpq