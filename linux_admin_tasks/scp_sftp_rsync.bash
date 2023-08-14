# To upload a file onto a remote server.
scp /PATH/TO/LOCAL_FILE USER@IP_ADDRESS:/PATH/TO/REMOTE_SERVER/DESTINATION

# To upload file from windows machine.
scp C:\Users\Pranshu\.ssh\id_rsa.pub 192.168.1.16:/home/pranshu/

# To get a file from remote server.
scp USER@IP_ADDRESS:/PATH/TO/REMOTE_SERVER /DESTINATION

# To use another port.
scp -P PORT /PATH/TO/LOCAL_FILE USER@IP_ADDRESS:/PATH/TO/REMOTE_SERVER/DESTINATION

# To compress a connection.
scp -C /PATH/TO/LOCAL_FILE USER@IP_ADDRESS:/PATH/TO/REMOTE_SERVER/DESTINATION

# To use remote server identity file.
scp -i IDENTITY_FILE /PATH/TO/LOCAL_FILE USER@IP_ADDRESS:/PATH/TO/REMOTE_SERVER/DESTINATION

# To preserver modification time.
scp -p /PATH/TO/LOCAL_FILE USER@IP_ADDRESS:/PATH/TO/REMOTE_SERVER/DESTINATION

# To get verbose output, can also increase verbosity by -vvv.
scp -v /PATH/TO/LOCAL_FILE USER@IP_ADDRESS:/PATH/TO/REMOTE_SERVER/DESTINATION

# To connect a remote system for data transfer.
# -a attempt to resume file transfer if interreputed.
sftp USER_NAME@IP_ADDRESS

# To connect a remote system for data transfer with different port.
sftp -P USER_NAME@IP_ADDRESS

# To login into a specific path.
sftp USER_NAME@IP_ADDRESS:/PATH/TO/DIRECTORY

# To fetch file directly.
sftp USER_NAME@IP_ADDRESS:/PATH/TO/FILE

# To use remote server identity file.
sftp -i PRIVATE_KEY USER_NAME@IP_ADDRESS

# To preserve files modificate time.
sftp -p USER_NAME@IP_ADDRESS

# To upload file from windows machine.
# After login into sftp.
# -r option to put recursively with folder only.
# -a option to resume if got interreputed.
put c:\PATH\TO\FILE /REMOTE/PATH

# To upload file from linux machine.
put /LOCAL/PATH /REMOTE/PATH

# To get file into windows machine.
# -r option to put recursively with folder only.
# -a option to resume if got interreputed.
get /REMOTE/PATH c:\PATH\TO\FILE

# To get file into linux machine.
get /REMOTE/PATH /LOCAL/PATH

# use bye command to get out of the prompt.

# ssh public keys also work with rsync.

-a -- archive						#--max-size='200k' -- to specify file's maximum size
-v -- verbose						#--progress -- to show progress while transfer
-z -- compress						#--include 'R*' -- include all files starting with R
-h -- human readable				#--exclude '*' -- exclude all other files and folder
-e -- specify remote shell to use	#--remove-source-files -- removes source file after transfer
-n -- performs a dry run before transfer
-r -- recursive


# To copy files from this server to remote server.
rsync -avzh /PATH/OF/SOURCE USER_NAME@IP_ADDRESS:/PATH/TO/DESTINATION

# To copy remote directory files to this local server.
rsync -avhz USER_NAME@IP_ADDRESS:/PATH/OF/REMOTE_SERVER /PATH/OF/LOCAL_SERVER

# If want to use specific protocol for transfer {ssh}.
rsync -avzhe ssh /PATH/OF/SOURCE USER_NAME@IP_ADDRESS:/PATH/TO/DESTINATION

# To show progress while transfer.
rsync -avzhe ssh --progress /PATH/OF/SOURCE USER_NAME@IP_ADDRESS:/PATH/TO/DESTINATION

# To specify files and folder while transfer.
rsync -avhez ssh --include 'R*' --exclude /PATH/OF/SOURCE USER_NAME@IP_ADDRESS:/PATH/TO/DESTINATION

# To remove source files after success full transfer.
rsync --remove-source-files -azvh /PATH/OF/SOURCE USER_NAME@IP_ADDRESS:/PATH/TO/DESTINATION

# To copy remote directory files to this local server from ssh.
rsync -avzhe ssh USER_NAME@IP_ADDRESS:/PATH/OF/REMOTE_SERVER /PATH/OF/LOCAL_SERVER

# To specify options with ssh.
rsync -avzhe "ssh -p PORT"  /PATH/OF/SOURCE USER_NAME@IP_ADDRESS:/PATH/TO/DESTINATION

# To put restriction on bandwith limit. {1024 KB/s}
rsync -avzhe "ssh -p PORT" --bwlimit=1024  /PATH/OF/SOURCE USER_NAME@IP_ADDRESS:/PATH/TO/DESTINATION