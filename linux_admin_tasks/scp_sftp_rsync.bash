# To upload a file onto a remote server.
scp /path/to/local_file <user_name>@<ip_address>:/path/to/remote_server/destination

# To upload a file from a windows machine.
scp C:\Users\Pranshu\.ssh\id_rsa.pub 192.168.1.16:/home/pranshu/

# To get a file from a remote server.
scp <user_name>@<ip_address>:/path/to/remote_server /destination

# To use another port.
scp -P <port> /path/to/local_file <user_name>@<ip_address>:/path/to/remote_server/destination

# To compress a connection.
scp -C /path/to/local_file <user_name>@<ip_address>:/path/to/remote_server/destination

# To use the remote server identity file.
scp -i <identity_file> /path/to/local_file <user_name>@<ip_address>:/path/to/remote_server/destination

# To preserver modification time.
scp -p /path/to/local_file <user_name>@<ip_address>:/path/to/remote_server/destination

# To get verbose output, can also increase verbosity by -vvv.
scp -v /path/to/local_file <user_name>@<ip_address>:/path/to/remote_server/destination

# To connect a remote system for data transfer.
# -a attempt to resume file transfer if interreputed.
# sftp sources remote .bash_profile
sftp <user_name>@<ip_address>

# To connect a remote system for data transfer with different port.
sftp -P <port> <user_name>@<ip_address>

# Sftp through a jump host
sftp -o "ProxyJump pranshu@152.67.29.35:2169" -P 2224 root@127.0.0.1

# To login into a specific path.
sftp <user_name>@<ip_address>:/path/to/directory

# To fetch a file directly.
sftp <user_name>@<ip_address>:/path/to/file

# To use the remote server identity file.
sftp -i private_key <user_name>@<ip_address>

# To preserve the files modificate time.
sftp -p <user_name>@<ip_address>

# To use a jump host.
sftp -P 2169 -J paul@168.138.114.133:2169 paul@10.0.0.108

# To upload a file from a windows machine.
# After login into sftp.
# -r option to "put" recursively with folder only.
# -a option to resume, in case interreputed.
put c:\path\to\file /remote/path

# To upload a file from linux machine.
put /local/path /remote/path

# To "get" a file into a windows machine.
# -r option to "put" recursively with folder only.
# -a option to resume if got interreputed.
get /remote/path c:\path\to\file

# To "get" a file into linux machine.
get /remote/path /local/path

# use "bye" command to get out of the prompt.

# ssh public keys also work with rsync.

# -a -- archive						#--max-size='200k' -- to specify file's maximum size
# -v -- verbose						#--progress -- to show progress while transfer
# -z -- compress						#--include 'Rem*' -- include all files starting with R
# -h -- human readable				#--exclude '*' -- exclude all other files and folder
# -e -- specify remote shell to use	#--remove-source-files -- removes source file after transfer
# -n -- performs a dry run before transfer
# -r -- recursive


# To copy files from this server to remote server.
rsync -avzh /path/of/source <user_name>@<ip_address>:/path/to/destination

# To copy remote directory files to this local server.
rsync -avhz <user_name>@<ip_address>:/path/of/remote_server /path/of/local_server

# If want to use specific protocol for transfer {ssh}.
rsync -avzhe ssh /path/of/source <user_name>@<ip_address>:/path/to/destination

# To show progress while transfer.
rsync -avzhe ssh --progress /path/of/source <user_name>@<ip_address>:/path/to/destination

# To specify files and folder while transfer.
rsync -avhez ssh --include 'Rem*' --exclude /path/of/source <user_name>@<ip_address>:/path/to/destination

# To remove source files after success full transfer.
rsync --remove-source-files -azvh /path/of/source <user_name>@<ip_address>:/path/to/destination

rsync --remove-source-files -razvhe "ssh -p <port>" --checksum <user_name>@<ip_address>:<source> <destination>
rsync --remove-source-files -razvhe "ssh -p 2169" --checksum paul@10.0.0.45:/ballistic/rsync /public

# To copy remote directory files to this local server from ssh.
rsync -avzhe ssh <user_name>@<ip_address>:/path/of/remote_server /path/of/local_server

# To specify options with ssh.
rsync -avzhe "ssh -p <port>"  /path/of/source <user_name>@<ip_address>:/path/to/destination

# To put restriction on bandwith limit. {1024 KB/s}
rsync -avzhe "ssh -p <port>" --bwlimit=1024  /path/of/source <user_name>@<ip_address>:/path/to/destination