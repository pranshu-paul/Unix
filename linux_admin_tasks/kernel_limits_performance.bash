# System performance, Kernel parameters, OS limits, and system internals (IPC)

# Purpose: Displays the number of file handles currently opened, the number of allocated file handles, and the maximum number of file handles allowed.
# Usage: The output format is "(allocated file handles) (file handles currently opened) (maximum file handles)". For example, "1344 0 62435".
fs.file-nr = 1344 0 62435

# Purpose: Sets the maximum number of file handles that the system can allocate.
# Usage: Set fs.file-max to 62435 to specify the maximum number of file handles that the system can allocate.
fs.file-max = 62435


# Purpose: List the hard limits for resource constraints.
# Usage: ulimit -Ha displays the hard limits for various system resources, such as maximum file size, maximum core file size, maximum data size, etc.
ulimit -Ha

# Purpose: List the soft limits for resource constraints.
# Usage: ulimit -Sa displays the soft limits for various system resources, such as maximum file size, maximum core file size, maximum data size, etc.
ulimit -Sa


# Purpose: Prints information about each individual thread in the system.
# Usage: ps -eLf displays detailed information about each thread in the system, including PID, TID (thread ID), CPU usage, memory usage, etc.
ps -eLf

# Purpose: Counts the total number of threads in the system.
# Usage: ps -eLf | wc -l counts the total number of lines (threads) outputted by the ps -eLf command, giving the total number of threads running in the system.
# maximum number of threads = virtual memory size / (stack size * 1024 * 1024)
ps -eLf | wc -l


# Purpose: Displays the number of processors available on the system.
# Usage: nproc command is used to print the number of processing units available to the current process, which can help in determining system capabilities and optimizing resource utilization.
nproc

# Purpose: Displays the maximum number of open file descriptors allowed.
# Usage: nofile command is used to print or set the maximum number of open file descriptors (file handles) that can be opened by a process. It helps in managing file I/O and system resource usage.
nofile

# Purpose: Displays the current number of file locks in the system.
# Usage: locks command is used to display information about file locks currently held in the system, helping in monitoring and troubleshooting file locking mechanisms.
locks

# Maximum core file size
*        hard    core            unlimited

# Maximum file size
*        hard    fsize           unlimited

# Maximum number of processes
*        hard    nproc           unlimited

# Maximum virtual memory size
*        hard    as              unlimited

# Maximum physical memory size
*        hard    rss             unlimited


# To get the pid of an executable running.
pidof httpd

# Detailed statistics for a specific PID, including voluntary and non-voluntary context switches.
pidstat -w -p <pid>

# detailed CPU usage summary for a command.
/usr/bin/time -v ls

# Setting processor affinity for a running process or launching a process with specified affinity.
taskset

# The below directives set the Out Of Memory behavior in the systemd unit files.
OOMScoreAdjust=

# Setting CPU affinity for systemd services
systemctl set-property sshd CPUAffinity=0

# To set a global policy, append in the below file.
# /etc/systemd/system.conf

# Reload the systemd configuration.
systemd daemon-reload


# Setting resource limits for a user (e.g., paul).
# Number of files opened.
# Minimum: 15
# * represents for all users.
paul hard nofile 500
paul soft nofile 15 

paul hard stack 16384
paul soft stack 10240

# Number of processes.
# Minimum: 7
paul hard nproc 50
paul soft nproc 7

# Maximum memory size (resident set size) in kbytes.
paul hard rss 10000

# To set the max number of logins.
* - maxlogins 3
paul - maxlogins 3

# Purpose: Defines the ephemeral port range.
# Usage: Set to 9000 65500 to specify the range of ephemeral ports.
net.ipv4.ip_local_port_range = 9000 65500

# Purpose: Disables IP forwarding, preventing routing of packets between network interfaces.
# Usage: Set to 0 to disable IP forwarding, preventing packet routing between network interfaces.
net.ipv4.ip_forward = 0

# Purpose: Enables Reverse Path Filtering (RPF) on incoming packets to prevent IP spoofing attacks.
# Usage: Set to 1 to enable Reverse Path Filtering (RPF) on incoming packets, enhancing network security.
net.ipv4.conf.default.rp_filter = 1

# Purpose: Disables acceptance of source-routed packets to mitigate network-based attacks.
# Usage: Set to 0 to disable acceptance of source-routed packets, enhancing network security.
net.ipv4.conf.default.accept_source_route = 0

# Purpose: Configures the kernel to include the process ID (PID) in core dump filenames for crash identification.
# Usage: Set to 1 to enable including the process ID (PID) in core dump filenames for crash identification.
kernel.core_uses_pid = 1

# Purpose: Enables TCP SYN cookies to defend against SYN flood attacks by efficiently tracking connection requests.
# Usage: Set to 1 to enable TCP SYN cookies, defending against SYN flood attacks.
net.ipv4.tcp_syncookies = 1


# Purpose: Sets the maximum size in bytes of a single message queue buffer.
# Usage: Set to 65536 to specify the maximum size of a single message queue buffer.
kernel.msgmnb = 65536

# Purpose: Sets the maximum size in bytes of a single message in a message queue.
# Usage: Set to 65536 to specify the maximum size of a single message in a message queue.
kernel.msgmax = 65536

# Purpose: Sets the total amount of shared memory pages that can be used system-wide.
# Usage: Set to 4294967296 to specify the total amount of shared memory pages that can be used system-wide.
kernel.shmall = 4294967296

# Purpose: Sets the maximum number of file handles that the system can allocate.
# Usage: Set to 6815744 to specify the maximum number of file handles that the system can allocate.
# Note: System nofiles takes precedence over this parameter.
fs.file-max = 6815744

# Purpose: Sets the semaphore values:
# SEMMSL - maximum number of semaphores per semaphore set.
# SEMMNS - total number of semaphores in the system.
# SEMOPM - maximum number of operations allowed per semop(2) system call.
# SEMMNI - maximum number of semaphore identifiers in the system.
# Usage: Set to 256 32000 100 142 to configure the semaphore values.
kernel.sem = 256 32000 100 142

# Purpose: Sets the maximum number of shared memory identifiers (shmid) in the system.
# Usage: Set to 4096 to specify the maximum number of shared memory identifiers in the system.
kernel.shmmni = 4096


# Purpose: Sets the maximum size in bytes for a single shared memory segment.
# Usage: Set to 4398046511104 to specify the maximum size for a single shared memory segment.
kernel.shmmax = 4398046511104

# Purpose: Sets the maximum number of message queue identifiers in the system.
# Usage: Set to 2878 to specify the maximum number of message queue identifiers in the system.
kernel.msgmni = 2878

# Purpose: Sets the default receive buffer size (in bytes) for network sockets.
# Usage: Set to 262144 to specify the default receive buffer size for network sockets.
net.core.rmem_default = 262144

# Purpose: Sets the maximum receive buffer size (in bytes) for network sockets.
# Usage: Set to 4194304 to specify the maximum receive buffer size for network sockets.
net.core.rmem_max = 4194304

# Purpose: Sets the default send buffer size (in bytes) for network sockets.
# Usage: Set to 262144 to specify the default send buffer size for network sockets.
net.core.wmem_default = 262144

# Purpose: Sets the maximum send buffer size (in bytes) for network sockets.
# Usage: Set to 1048576 to specify the maximum send buffer size for network sockets.
net.core.wmem_max = 1048576

# Purpose: Sets the maximum number of allowed concurrent asynchronous I/O operations.
# Usage: Set to 1048576 to specify the maximum number of allowed concurrent asynchronous I/O operations.
fs.aio-max-nr = 1048576



# Purpose: Configures ptrace scope:
# Usage: Set to 1 to restrict ptrace to child processes only for security purposes, enhancing system security.
kernel.yama.ptrace_scope = 1

# Purpose: Enables Address Space Layout Randomization (ASLR) for security:
# Usage: Set to 2 for full randomization of address space layout, enhancing security against memory-based attacks.
kernel.randomize_va_space = 2

# Purpose: Disables accepting secure ICMP redirects (used for updating routing tables), enhancing security.
# Usage: Set to 0 to disable accepting secure ICMP redirects, enhancing network security.
net.ipv4.conf.all.secure_redirects = 0

# Purpose: Configures the kernel to panic on an unknown Non-Maskable Interrupt (NMI), typically used for debugging.
# Usage: Set to 1 to enable kernel panic on an unknown NMI, aiding in debugging.
kernel.unknown_nmi_panic = 1

# Purpose: Enables logging of packets with un-routable source addresses (Martian packets) for debugging.
# Usage: Set to 1 to enable logging of Martian packets for debugging purposes.
net.ipv4.conf.all.log_martians = 1


# Purpose: Allows the acceptance of source-routed packets, which can be used for specific routing but poses security risks.
# Usage: Set to 1 to allow the acceptance of source-routed packets, enabling specific routing but increasing security risks.
net.ipv4.conf.all.accept_source_route = 1

# Purpose: Controls the dropping of clean cache objects from memory.
# Usage: Set to 0 to retain all cache objects in memory, 1 to drop page cache, 2 to drop dentries and inodes, 3 to drop page cache, dentries, and inodes.
vm.drop_caches = 0

# Purpose: Sets the action to take when a kernel panic occurs.
# Usage: Set to 0 to prevent automatic reboot after a kernel panic, or set to a value greater than 0 to specify the number of seconds before automatically rebooting.
kernel.panic = 0

# Purpose: Sets the maximum number of mounts that can be mounted at the same time.
# Usage: Set to 100000 to specify the maximum number of mounts that can be mounted simultaneously.
fs.mount-max = 100000

# Purpose: Sets the maximum size (in bytes) for a pipe buffer.
# Usage: Set to 1048576 to specify the maximum size for a pipe buffer in bytes.
fs.pipe-max-size = 1048576


# Purpose: Controls the behavior of the Ctrl-Alt-Del key combination.
# Usage: Set to 0 to ignore the Ctrl-Alt-Del key combination, preventing accidental system reboots.
kernel.ctrl-alt-del = 0

# Purpose: Sets the maximum value for process IDs (PIDs), allowing more concurrent processes.
# Usage: Set to 4194304 to specify the maximum value for process IDs, allowing for more concurrent processes to be created.
kernel.pid_max = 4194304

# Purpose: Sets the maximum number of pseudo-terminal (PTY) devices that can be used simultaneously.
# Usage: Set to 4096 to specify the maximum number of PTY devices that can be used simultaneously.
kernel.pty.max = 4096

# Purpose: Sets the maximum number of threads that can be created system-wide.
# Usage: Set to 5211 to specify the maximum number of threads that can be created system-wide.
kernel.threads-max = 5211

# Purpose: Sets the number of kswapd threads responsible for memory reclamation.
# Usage: Set to 1 to specify the number of kswapd threads responsible for memory reclamation.
vm.kswapd_threads = 1

# Purpose: Sets the maximum number of multicast group memberships a single socket can have.
# Usage: Set to 20 to specify the maximum number of multicast group memberships a single socket can have.
net.ipv4.igmp_max_memberships = 20

# Purpose: Sets the maximum number of multicast source filters a socket can have.
# Usage: Set to 10 to specify the maximum number of multicast source filters a socket can have.
net.ipv4.igmp_max_msf = 10


# Purpose: Sets the maximum Time-To-Live (TTL) for cached IPv4 routes.
# Usage: Set to 600 to specify the maximum Time-To-Live (TTL) for cached IPv4 routes, managing route caching.
net.ipv4.inet_peer_maxttl = 600

# Purpose: Sets the maximum distance in bytes between fragments that the kernel will accept for reassembling a fragmented IP packet.
# Usage: Set to 64 to specify the maximum distance between fragments accepted for reassembling a fragmented IP packet, managing packet reassembly.
net.ipv4.ipfrag_max_dist = 64

# Purpose: Sets the maximum number of routing table entries.
# Usage: Set to 2147483647 to specify the maximum number of routing table entries, managing routing table size.
net.ipv4.route.max_size = 2147483647

# Purpose: Sets the maximum number of orphaned TCP connections (connections without a corresponding process) allowed.
# Usage: Set to 4096 to specify the maximum number of orphaned TCP connections allowed, managing resource utilization.
net.ipv4.tcp_max_orphans = 4096

# Purpose: Sets the maximum number of TCP segments that can be re-ordered in the TCP receive queue.
# Usage: Set to 300 to specify the maximum number of TCP segments that can be re-ordered in the TCP receive queue, managing TCP segment re-ordering.
net.ipv4.tcp_max_reordering = 300

# Purpose: Sets the maximum number of connection requests that can be queued for a listening TCP socket before connections are dropped.
# Usage: Set to 128 to specify the maximum number of connection requests that can be queued for a listening TCP socket, managing connection backlog.
net.ipv4.tcp_max_syn_backlog = 128


# Purpose: Sets the maximum number of time-wait sockets (sockets in the TIME_WAIT state) allowed.
# Usage: Set to 4096 to specify the maximum number of time-wait sockets allowed, which helps in managing resource utilization.
net.ipv4.tcp_max_tw_buckets = 4096

# Purpose: Sets the maximum number of datagrams in the queue for a Unix domain socket.
# Usage: Set to 512 to specify the maximum number of datagrams in the queue for a Unix domain socket, managing queue size.
net.unix.max_dgram_qlen = 512

# Purpose: Configures the core dump pattern, piping core dumps to the systemd-coredump service with specified format specifiers.
# Usage: Configure the core dump pattern to pipe core dumps to the systemd-coredump service with the specified format specifiers.
kernel.core_pattern = |/usr/lib/systemd/systemd-coredump %P %u %g %s %t %c %h %e

# Purpose: Sets the maximum number of concurrent processes that can be dumping core at the same time.
# Usage: Set to 16 to specify the maximum number of concurrent processes that can be dumping core at the same time.
kernel.core_pipe_limit = 16

# Purpose: Configures the SysRq key functionality to allow the sync command (sync all mounted filesystems).
# Usage: Set to 16 to enable the sync command functionality through the SysRq key, allowing synchronization of all mounted filesystems.
kernel.sysrq = 16


# Purpose: Restricts the visibility of kernel pointers in /proc files to enhance security.
# Usage: Set to 1 to restrict most kernel pointers from being visible in /proc files, enhancing system security.
kernel.kptr_restrict = 1

# Purpose: Enables Reverse Path Filtering (RPF) on all network interfaces to prevent IP spoofing.
# Usage: Set to 1 to enable Reverse Path Filtering (RPF) on all network interfaces, preventing IP spoofing attacks.
net.ipv4.conf.all.rp_filter = 1

# Purpose: Allows the promotion of secondary addresses to primary on interface up events.
# Usage: Set to 1 to allow the promotion of secondary addresses to primary when network interfaces are brought up.
net.ipv4.conf.all.promote_secondaries = 1

# Purpose: Sets the default queuing discipline for network interfaces to fq_codel, which helps to reduce network latency and bufferbloat.
# Usage: Set to fq_codel to use Fair Queue Controlled Delay (fq_codel) as the default queuing discipline, reducing network latency and bufferbloat.
net.core.default_qdisc = fq_codel


# Purpose: Protects against hardlink-based attacks by restricting the creation of hardlinks to files owned by the user.
# Usage: Set to 1 to enable protection against hardlink-based attacks, preventing the creation of hardlinks to files not owned by the user.
fs.protected_hardlinks = 1

# Purpose: Protects against symlink-based attacks by restricting the creation of symlinks to files owned by the user.
# Usage: Set to 1 to enable protection against symlink-based attacks, preventing the creation of symlinks to files not owned by the user.
fs.protected_symlinks = 1

# Purpose: Sets the maximum amount of optional memory buffers per socket.
# Usage: Set to 81920 to specify the maximum amount of optional memory buffers per socket.
net.core.optmem_max = 81920

# Purpose: Ignores ICMP echo requests (pings) sent to broadcast addresses to prevent certain types of network attacks.
# Usage: Set to 1 to enable ignoring ICMP echo requests sent to broadcast addresses, enhancing network security.
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Purpose: Ignores bogus ICMP error responses to prevent certain types of network-based attacks.
# Usage: Set to 1 to enable ignoring bogus ICMP error responses, enhancing network security.
net.ipv4.icmp_ignore_bogus_error_responses = 1


# Purpose: Disables acceptance of ICMP redirect messages on all network interfaces to mitigate certain network attacks.
# Usage: Set to 0 to disable acceptance of ICMP redirect messages on all network interfaces, enhancing network security.
net.ipv4.conf.all.accept_redirects = 0

# Purpose: Logs packets with un-routable source addresses (Martian packets) for debugging on all network interfaces.
# Usage: Set to 1 to enable logging of Martian packets on all network interfaces for debugging purposes.
net.ipv4.conf.all.log_martians = 1

# Purpose: Disables acceptance of ICMP redirect messages on the default network interface to enhance security.
# Usage: Set to 0 to disable acceptance of ICMP redirect messages on the default network interface, enhancing network security.
net.ipv4.conf.default.accept_redirects = 0

# Purpose: Disables acceptance of source-routed packets on the default network interface to enhance security.
# Usage: Set to 0 to disable acceptance of source-routed packets on the default network interface, enhancing network security.
net.ipv4.conf.default.accept_source_route = 0

# Purpose: Enables logging of packets with un-routable source addresses (Martian packets) for debugging on the default network interface.
# Usage: Set to 1 to enable logging of Martian packets on the default network interface for debugging purposes.
net.ipv4.conf.default.log_martians = 1


# Purpose: Enables Reverse Path Filtering (RPF) on the default network interface to prevent IP spoofing attacks.
# Usage: Set to 1 to enable RPF, which helps prevent IP spoofing attacks by filtering packets with source addresses that do not have a route back through the same interface.
net.ipv4.conf.default.rp_filter = 1

# Purpose: Disables acceptance of secure ICMP redirect messages on the default network interface to enhance security.
# Usage: Set to 0 to disable acceptance of secure ICMP redirect messages, which can help prevent certain types of network attacks.
net.ipv4.conf.default.secure_redirects = 0

# Purpose: Disables sending of ICMP redirect messages on all network interfaces to prevent certain network attacks.
# Usage: Set to 0 to disable sending of ICMP redirect messages on all network interfaces, enhancing network security.
net.ipv4.conf.all.send_redirects = 0

# Purpose: Disables sending of ICMP redirect messages on the default network interface to prevent certain network attacks.
# Usage: Set to 0 to disable sending of ICMP redirect messages on the default network interface, enhancing network security.
net.ipv4.conf.default.send_redirects = 0

# Purpose: Enables TCP Fast Open (TFO) with a mode of 3, which allows sending data in the initial TCP SYN packet to improve connection setup performance.
# Usage: Set to 3 to enable TFO with a mode that allows sending data in the initial TCP SYN packet, improving connection setup performance.
net.ipv4.tcp_fastopen = 3

# Purpose: Sets the ratio of dirty pages at which the background kernel flusher threads will start writing out dirty data to disk in the background.
# Usage: Set to 3 to specify the ratio of dirty pages at which background kernel flusher threads will start writing out dirty data to disk.
vm.dirty_background_ratio = 3


# Purpose: Sets the ratio of dirty pages at which the system will start blocking further writes to prevent memory exhaustion.
# Usage: Set to 10 to ensure that when 10% of memory is dirty (modified but not yet written to disk), further writes are blocked to prevent memory exhaustion.
vm.dirty_ratio = 10

# Purpose: Sets the interval (in seconds) at which the kernel dumps its statistics to the /proc/vmstat file.
# Usage: Set to 10 to specify that kernel statistics are dumped to /proc/vmstat file every 10 seconds.
vm.stat_interval = 10

# Purpose: Displays the current inode statistics, including the number of allocated inodes and the number of free inodes.
# Usage: Provides information about the current inode usage in the filesystem.
fs.inode-nr = 31286     569

# Purpose: Displays inode state statistics, including the number of allocated inodes and various inode states.
# Usage: Provides detailed information about inode states in the filesystem.
fs.inode-state = 31286  569     0       0       0       0

# Purpose: Specifies the last process ID (PID) that was assigned by the kernel namespace allocator.
# Usage: Indicates the last PID assigned by the kernel namespace allocator.
kernel.ns_last_pid = 2258


# Purpose: Indicates the available entropy in the kernel's random number generator pool.
# Usage: Shows the amount of entropy available, which is useful for applications requiring random data.
kernel.random.entropy_avail = 894

# Purpose: Sets the maximum new idle load balancing cost for CPU1 in the sched_domain domain0.
# Usage: Configure this value to optimize load balancing for CPU1, enhancing scheduling efficiency.
kernel.sched_domain.cpu1.domain0.max_newidle_lb_cost = 13708

# Purpose: Sets the maximum new idle load balancing cost for CPU0 in the sched_domain domain0.
# Usage: Configure this value to optimize load balancing for CPU0, enhancing scheduling efficiency.
kernel.sched_domain.cpu0.domain0.max_newidle_lb_cost = 902959

# Purpose: Enables timer migration, allowing timers to be migrated between CPUs to balance load and improve performance.
# Usage: Set this to 1 to enable timer migration, which can help balance CPU load and improve overall system performance.
kernel.timer_migration = 1

# Purpose: Configures busy polling for network sockets, specifying the number of iterations the kernel will busy-wait for network events.
# Usage: Set this to 50 to perform repetitive checks for network events, balancing between latency and CPU usage.
net.core.busy_poll = 50


# Purpose: The kernel will busy-wait for 50 iterations.
# Usage: Perform repetitive checks. A high value means low latency at the cost of higher CPU usage.
net.core.busy_read = 50

# Purpose: Minimum time to declare a process in the hung state.
# Usage: Set this to define the timeout (in seconds) after which a process is considered hung.
kernel.hung_task_timeout_secs = 120

# Purpose: Reserve memory for the kernel critical operations in kilobytes around 1%.
# Usage: Configure this to ensure there is enough free memory reserved for critical kernel operations.
vm.min_free_kbytes = 135168

# Purpose: For web servers and database servers.
# Usage: Set this to 1 to enable zone reclaim mode, which is beneficial for web and database servers.
vm.zone_reclaim_mode = 1

# Purpose: For smoother performance applications.
# Usage: Set this to 2 for applications that require smoother performance, balancing between memory reclaim and latency.
vm.zone_reclaim_mode = 2


# Purpose: In real-time systems, the system doesn't spend resources on unnecessary memory management tasks.
# Usage: Set this to 0 for real-time systems where minimizing latency is critical.
vm.zone_reclaim_mode = 0

# Purpose: For large-scale data processing or scientific computing, the system can maintain stable performance even under heavy workloads.
# Usage: Set this to 4 to ensure stable performance under heavy workloads by being more aggressive in reclaiming memory.
vm.zone_reclaim_mode = 4

# Purpose: To prevent the kernel from overcommitting memory.
# Usage: Set this to 1 to avoid the system allocating more memory than is physically available, preventing out-of-memory situations.
vm.overcommit_memory = 1

# Purpose: Sets the total amount of shared memory (in pages) that can be used system-wide.
# Usage: Configure this to ensure sufficient shared memory space for applications that rely heavily on it.
kern.ipc.shmall = 32768

# Purpose: Sets the maximum size (in bytes) for a single shared memory segment.
# Usage: Define this to allow applications to allocate large shared memory segments as needed.
kern.ipc.shmmax = 134217728


# Purpose: Adjusting the Out Of Memory (OOM) score to prevent the killing of the process (mysqld).
# Usage: Set the OOM score adjustment to -1000 for the mysqld process to reduce its likelihood of being killed in an OOM situation.
echo -1000 > /proc/$(pidof mysqld)/oom_score_adj

# Purpose: Preventing a process (mysqld) from getting killed in an OOM situation.
# Usage: Set the OOM adjustment to -17 for the mysqld process to prevent it from getting killed in an OOM situation.
# Note: The default OOM adjustment is 0, and -17 ensures that the process is not killed.
echo -17 > /proc/$(pidof mysqld)/oom_adj



# Purpose: Define the minimum, default, and maximum receive buffer sizes for TCP sockets.
# Usage: Set to "4096 87380 16777216" to configure the TCP receive buffer sizes, optimizing network performance.
net.ipv4.tcp_rmem="4096 87380 16777216"

# Purpose: Define the minimum, default, and maximum send buffer sizes for TCP sockets.
# Usage: Set to "4096 65536 16777216" to configure the TCP send buffer sizes, optimizing network performance.
net.ipv4.tcp_wmem="4096 65536 16777216"

# Purpose: Adjust the swappiness value.
# Usage: Set to 10 to reduce the swap usage, making the system prefer to free up RAM instead of using swap space.
vm.swappiness=10

# Purpose: Increase the maximum number of inotify watches.
# Usage: Set to 1048576 to allow a higher number of file watches, beneficial for applications that monitor many files.
fs.inotify.max_user_watches=1048576
