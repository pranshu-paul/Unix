strace -e openat free 2>&1 | grep /proc/meminfo

ltrace -e openat free 2>&1 | grep /proc/meminfo

strace date 2>&1 | grep -v No | grep openat