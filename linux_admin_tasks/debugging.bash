# Trace system calls.
strace -e openat free 2>&1 | grep /proc/meminfo
strace -e openat,execve  free 2>&1 | grep -v No

# Trace number of system calls that which one is taking time.
strace -c free

# Trace library calls.
ltrace -e openat free 2>&1 | grep /proc/meminfo

# Trace number of function call in libraries.
ltrace -c free

strace date 2>&1 | grep -v No | grep openat

# To generate system configuration snapshot including the /etc directory /proc
sos report