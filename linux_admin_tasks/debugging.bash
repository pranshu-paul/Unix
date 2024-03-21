strace -e open free 2>&1 | grep /proc/meminfo

ltrace -e open free 2>&1 | grep /proc/meminfo

strace date 2>&1 | grep -v No | grep openat