# system monitoring and performance
# Useful commands -- ps, top, iostat, vmstat, free, df, du, systemctl, lscpu, kill, pkill, pgrep, nohup, fg, bg, sar

# "systemd" is the first process with PID 1 when the system boots up.
# Kernel starts this process.
# Process schedular is integrated in the kernel itself.

# BIOS/UEFI --> From the reserved sector of Hard Drive "Grub" --> kernel with initramfs --> Decompresses the kernel --> mounts the root file system "/" --> systemd

# bg - move jobs to the background.

bg %1	# Sends the job, having Job ID ‘n’, to the background.

bg %%	# Sends the current job to the background.

bg %-	# Sends the previous job to the background.

bg %sleep 5	# Sends the job whose name starts with string to the background.

# fg -  Moves the job to the foreground.

top

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