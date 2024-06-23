# Control how much memory can be filled with dirty pages before they are written to disk.
# Increasing this value can delay write operations, but too high a value may cause large bursts of I/O.
vm.dirty_ratio = 15

# Set the percentage of memory that can be filled with dirty pages before the background writeback daemon starts writing them to disk.
# Lower value helps to keep more free memory available.
vm.dirty_background_ratio = 5

# Increase the maximum number of incoming connections that can be queued for acceptance.
# Useful for improving performance on servers handling many simultaneous connections.
net.core.somaxconn = 1024

# Increase the maximum number of packets allowed to queue when the interface receives packets faster than the kernel can process them.
# Helps to prevent packet loss during high traffic.
net.core.netdev_max_backlog = 5000

# Increase the maximum number of queued connection requests awaiting acknowledgment from the client.
# Useful for handling bursts of incoming connections more efficiently.
net.ipv4.tcp_max_syn_backlog = 2048

# Reduce the tendency of the kernel to swap out memory pages.
# Lower value reduces swap usage, which can improve performance but may lead to higher RAM usage.
vm.swappiness = 10

chrt -r -p 20 <pid>

# To get the report of control groups
systemd-cgtop

# Decrease the timeslice allocated to each process (in nanoseconds)
kernel.sched_min_granularity_ns = 10000000

# Reduce the maximum timeslice for interactive tasks (in nanoseconds)
kernel.sched_latency_ns = 20000000

# Proportion of CPU time dedicated to kernel threads
kernel.sched_rt_runtime_us = 950000
kernel.sched_rt_period_us = 1000000

# Distribute interrupts for a specific network interface
echo 1 > /proc/irq/31/smp_affinity
echo 0xff > /proc/irq/31/smp_affinity

# To set affinity on all the cores.
echo 0xffffff > /proc/irq/31/smp_affinity


# Set CPU frequency scaling governor to 'performance' for all CPUs
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo performance > $cpu
done

# Set CPU shares for a cgroup to give it more CPU time relative to others
echo 1024 > /sys/fs/cgroup/cpu/my_cgroup/cpu.shares

# Change the kernel timer frequency (common values are 100, 250, 1000)
kernel.hz = 1000

# Enable NUMA Balancing
kernel.numa_balancing = 1

# Verify the core dump pattern.
sysctl kernel.core_pattern

# Analyze the core.
# If a program crashes.
find /var/lib/systemd/coredump/ -type f

# To get the details of the core dump.
journalctl -r -t systemd-coredump

journalctl -r -t systemd-coredump | grep -w systemd-coredump | cat

# Context switching means suspending execution of a process on the CPU and saving its state into the process control block.

# It will go high, if there is high network traffic, or higher disk traffic.


# Prints a single snapshot of the context switching.
# thread group id, thread id, ctx swtch, non-vol ctx swtch
pidstat -wt 1 4 | grep Average

# Check which cores are being heaviliy used.
mpstat -P ALL 1 4 | grep -w Average

# Assign the free cores to the process which is causing high ctx swtch.
taskset -c 0,1

# Check which system call is causing high ctx swtch.
# -c summary, -f follow-forks -p pid
# Forks are the child processes.
sudo timeout 5s strace -c -f -p 1879651


# To monitor interface utilization.
# Monitors the following.
# Number of packets per second (received/transmitting)
# Number of compressed packets (received/transmitting)
# Number of packets in kilobytes per second (received/transmitting)
# Number of packets received multicast per second.
sar -n DEV 1 4 | grep -w Average


mkdir -p /etc/tuned/custom-performance

vim /etc/tuned/custom-performance

[main]
summary=This is a custom profile combining balanced and latency-performance for optimized performance.
include=balanced,latency-performance

tuned-adm profile custom-performance