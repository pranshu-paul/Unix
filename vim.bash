# Default vim configuration files

# User level: .vimrc 
# System wide: /etc/vimrc

set guifont=Consolas:h16
set number

:wq # write quit
:x # Same as the above
ZZ # Same as the above

:wq! # Force write quit
:q! # Force exit - no changes saved

/<string_search>

n # Searches forward
N # Searches backward

Ctrl-f # forward
Ctrl-b # backward

G # Last page
gg # first page

dd # Deletes the whole line
dw # Delete the whole from "left-right"

# Escape commands
o -- adds a new line downwards
O -- adds a new line upwards

A -- enters into the "insert" mode from last of the line.
I -- enters into the "insert" from the beginging of the line.

yy -- copys the whole line.

p -- pastes downwards
P -- pastes upwards

# Find and replace
# Press "escape" ":"
# And then.
%s/<string>/<string_replaced>/

# To change the all occurances.
%s/<string>/<string_replaced>/g

# To save the name
:file <file_name>
:saveas <file_name>

# "Escape" and "colon" commands.
# To set and unset number lines.
set number
set nonumber

# To get better contrast.
set bg=dark

# To unhighlight.
noh

# Set file format to unix.
# This command converts the file from windows to unix.
:set ff=unix
:wq


# To check a file's format.
:set ff?

# To remove carriage returns.
sed -i 's/\r$//' filename


# This command converts the Windows carriage return line feed file format to Unix line feed only.
dos2unix

# Truncate a log file.
/dev/null >| my_logfile.log