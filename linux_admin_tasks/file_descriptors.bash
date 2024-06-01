# Open a file descriptor.
exec 3> /tmp/src_hosts

# Close a file descriptor.
exec 3>&-

# Open again for capturing data.
exec 3< /tmp/src_hosts

# Pass the data to make an array.
readarray -t src_hosts <&3


# Lists the current open file descriptors.
ls -la /proc/$$/fd

# To empty a file descriptor.
: > /proc/self/fd/3