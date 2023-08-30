# system monitoring and performance
# Useful commands -- ps, top, iostat, vmstat, free, df, du, systemctl, lscpu, kill, pkill, pgrep, nohup, fg, bg, sar

# "systemd" is the first process with PID 1 when the system boots up.
# Kernel starts this process.
# Process schedular is integrated in the kernel itself.

# BIOS/UEFI --> From the reserved sector of Hard Drive "Grub" --> kernel with initramfs --> Decompresses the kernel --> mounts the root file system "/" --> systemd

# top -u USER
top -u pranshu|UID

# top -o option.
top -o %CPU
top -o VIRT
top -o $MEM -- highest memory usage at top.

# To monitor a PID ONLY.
top -p PID

# top internal commands(keyboard shortcuts).
E -- for changing memory unit to Mi, Gi, Ti, from Ki
f or F -- to change display fields.
k -- to kill a process by entering PID. press Esc to exit out of the promtp.
H -- for changing CPU mode to threads mode.
r -- to change process priority -- nice value [-20 is highest, 0 is default, +19 is lowest.]
m -- to change memory value to bar graph. -- b for bold.
1 -- to change CPU view from 1 to as logical CPUs.
u -- for changing view to user specific.

# To find a zombie process.
ps aux | grep -e Z -e '<defunct>' | grep -v grep


# To check last log for root -u = user.
lastlog -u root

# To install iostat.
yum -y install sysstat

%user -- shows percentage of CPU utilization at user level.
%nice -- shows process priorities [-20 is highest, 0 is default, +19 is lowest.]
%system -- shows utilization at kernel.
%iowait -- shows CPUs waiting time when system has outstanding disk usage.
%steal -- involuntary wait by CPUs while hypervisior was servicing another virtual processor.
%idle -- shows how much percent CPU is in idle state.

tps -- transfer per second.

# To check CPUs I/O status.
iostat -c

# To check all I/O status in megabytes per second.
iostat

# To check a specific device I/O.
iostat -x DEVICE_NAME
iostat -x sda

# To list CPU counts.
grep -c '^processor' /proc/cpuinfo

# List all hardware details.
lshw | less

# List less details of hardware.
lshw -short | less

# Process monitoring.
ps -aux -- all processes from user x

ps -ef -- all processes in ASCII format.

# ps -au USER
ps -au pranshu

ps -C COMMAND -- searches command PID

ps -ef | awk '{print $2 ',' $8}' | less -- to see only PID and command.

# Background job management.
# bg - move jobs to the background.

bg %1	# Sends the job, having Job ID ‘n’, to the background.

bg %%	# Sends the current job to the background.

bg %-	# Sends the previous job to the background.

bg %sleep 5	# Sends the job whose name starts with string to the background.

kill %1 # To kill the job #1.

# fg -  Moves the job to the foreground.
fg %1

# To send any program/command in background.
# Press Ctrl-Z, then.
# It will show the job-id, as stopped.
# It can be continued by the below command.
bg %<job_id>
bg %1


# To check the system's uptime.
uptime -p


# Operating System Signals.

# Signal	Number	Description
# SIGHUP	1	Hangup signal
# SIGINT	2	Interrupt signal
# SIGQUIT	3	Quit signal
# SIGKILL	9	Kill signal
# SIGTERM	15	Termination signal
# SIGUSR1	10	User-defined signal 1
# SIGUSR2	12	User-defined signal 2
# SIGCONT	18	Continue signal
# SIGSTOP	19	Stop signal
# SIGTSTP	20	Terminal stop signal
# SIGTTIN	21	Background read from terminal signal
# SIGTTOU	22	Background write to terminal signal
# SIGPIPE	13	Broken pipe signal
# SIGALRM	14	Alarm clock signal
# SIGCHLD	17	Child process terminated or stopped signal
# SIGBUS	10	Bus error signal
# SIGFPE	8	Floating-point exception signal
# SIGILL	4	Illegal instruction signal
# SIGSEGV	11	Segmentation violation signal
# SIGSYS	12	Bad system call signal
# SIGTRAP	5	Trace/breakpoint trap signal
# SIGURG	16	Urgent condition on socket signal
# SIGXCPU	24	CPU time limit exceeded signal
# SIGXFSZ	25	File size limit exceeded signal

# Just remove the "SIG" prefix.

kill -HUP <pid>
kill -KILL <pid>