bash - GNU Bourne-Again SHell

bash


history | awk '{$1=""}'1 | sort | uniq

# In Ubuntu/Debian os.
apt -y install bash

# In Redhat/Oracle linux upto 7th version only.
yum -y install bash

# In rhel8/oel8.
dnf -y install bash

# To enable tab completion.
# install "bash-completion" package

yum -y install bash-completion

apt -y install bash-completion

# -- single line comment.


: '
	-- multiline comment
'

history -c # Clears the complete history.

# To set time on history.
HISTTIMEFORMAT="%Y-%m-%d %T "

unset HISTTIMEFORMAT

history -d <offset>

# To get the command only
history | cut -d " " -f5-

# default PS1 = [\u@\h \W]\$
# default PS2 = >

# Below are the parameters for the PSn variables.
# \u: The username.
# \h: The hostname.
# \w: The current working directory.
# \W: The basename of the current working directory.
# \t: The current time in 24-hour format (HH:MM:SS).
# \n: A newline.
# \d: Date

export PS1="\s-\v\$ "

# This command sets the PS1 variable to its default value.
# Where \u represents the username, \h represents the hostname, and \w represents the current working directory.
# The trailing \$ displays a $ symbol for a regular user or a # symbol for the root user.

export PS1='[\u@\h \t \w]\$ '
export PS1='[\u@\h \d \w]\$ '

man hier # Man page of the linux hierarchy.

alias

# To set shortcuts to commands.

alias random-keyword="COMMAND WITH ATTRIBUTES"

Example

alias ll="ls -alF"


# Index of Shell Reserved Words

!
 
[ ]

[[ ]]

{ }

# C
case

# D
do
done

# E
elif
else
esac

# F
fi
for
function

# I
if
in

# S
select

# T
then
time

# U
until

# W
while