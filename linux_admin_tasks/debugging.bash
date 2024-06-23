# Trace system calls.
strace -e openat free 2>&1 | grep /proc/meminfo
strace -e openat,execve  free 2>&1 | grep -v No

# Trace number of system calls that which one is taking time.
strace -c free

# To trace specific system calls only
# -e trace=network  (Trace all the network related system calls.)
# 
# -e trace=signal    (Trace all signal related system calls.)
# 
# -e trace=ipc       (Trace all IPC related system calls.)
# 
# -e trace=desc      (Trace all file descriptor related system calls.)
# 
# -e trace=memory    (Trace all memory mapping related system calls.)

# File and Directory Operations
# openat: Open a file.
# close: Close a file descriptor.
# read: Read from a file descriptor.
# write: Write to a file descriptor.
# stat: Get file status.
# lstat: Get file status, not following symbolic links.
# fstat: Get file status using file descriptor.
# rename: Rename a file.
# unlink: Delete a file.

# Memory Management
# mmap: Map files or devices into memory.
# munmap: Unmap files or devices from memory.
# brk: Change data segment size.
# sbrk: Change data segment size.
# mprotect: Set protection on a region of memory.

# Process Control
# fork: Create a child process.
# vfork: Create a child process and block parent.
# clone: Create a child process with specific attributes.
# execve: Execute a program.
# exit: Terminate the current process.
# _exit: Terminate the current process without cleanup.
# wait: Wait for a child process to change state.
# waitpid: Wait for a specific child process to change state.

# Thread Synchronization
# futex: Fast user-space locking.
# pthread_create: Create a new thread (POSIX threads).
# pthread_join: Wait for a thread to terminate (POSIX threads).

# Signal Handling
# signal: Set a signal handler.
# sigaction: Examine and change a signal action.
# kill: Send a signal to a process.
# sigprocmask: Examine and change blocked signals.

# Networking
# socket: Create a socket.
# connect: Connect a socket.
# accept: Accept a connection on a socket.
# send: Send a message on a socket.
# recv: Receive a message from a socket.
# bind: Bind a name to a socket.
# listen: Listen for connections on a socket.

# Inter-Process Communication (IPC)
# pipe: Create a pipe.
# pipe2: Create a pipe with specified flags.
# shmget: Allocate a shared memory segment.
# shmat: Attach a shared memory segment.
# shmdt: Detach a shared memory segment.
# semget: Get a semaphore set identifier.
# semop: Operate on a semaphore set.

# Resource Usage and Limits
# getrlimit: Get resource limits.
# setrlimit: Set resource limits.
# getrusage: Get resource usage.

# Time and Timers
# gettimeofday: Get the current time.
# time: Get the current time.
# clock_gettime: Get the time of a specified clock.
# nanosleep: Suspend execution for a specified time.

# Trace library calls.
ltrace -e openat free 2>&1 | grep /proc/meminfo

# Trace number of function call in libraries.
ltrace -c free

strace date 2>&1 | grep -v No | grep openat

strace -e trace=openat,close,read,write,stat,fork,execve,socket ./your_application


# To generate system configuration snapshot including the /etc directory /proc
sos report