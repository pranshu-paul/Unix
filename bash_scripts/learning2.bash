#!/bin/bash
# logevents.sh
# Author: Stephane Chazelas.
# Used in ABS Guide with permission.
# Event logging to a file.
# Must be run as root (for write access in /var/log).
ROOT_UID=0 # Only users with $UID 0 have root privileges.
E_NOTROOT=67 # Non-root exit error.
if [ "$UID" -ne "$ROOT_UID" ]
then
 echo "Must be root to run this script."
 exit $E_NOTROOT
fi 
FD_DEBUG1=3
FD_DEBUG2=4
FD_DEBUG3=5
# === Uncomment one of the two lines below to activate script. ===
# LOG_EVENTS=1
# LOG_VARS=1
log() # Writes time and date to log file.
{
echo "$(date) $*" >&7 # This *appends* the date to the file.
# ^^^^^^^ command substitution
 # See below.
}
case $LOG_LEVEL in
 1) exec 3>&2 4> /dev/null 5> /dev/null;;
 2) exec 3>&2 4>&2 5> /dev/null;;
 3) exec 3>&2 4>&2 5>&2;;
 *) exec 3> /dev/null 4> /dev/null 5> /dev/null;;
esac
FD_LOGVARS=6
if [[ $LOG_VARS ]]
then exec 6>> /var/log/vars.log
else exec 6> /dev/null # Bury output.
fi
FD_LOGEVENTS=7
if [[ $LOG_EVENTS ]]
then
 # exec 7 >(exec gawk '{print strftime(), $0}' >> /var/log/event.log)
 # Above line fails in versions of Bash more recent than 2.04. Why?
 exec 7>> /var/log/event.log # Append to "event.log".
 log # Write time and date.
else exec 7> /dev/null # Bury output.
fi
echo "DEBUG3: beginning" >&${FD_DEBUG3}
ls -l >&5 2>&4 # command1 >&5 2>&4
echo "Done" # command2 
echo "sending mail" >&${FD_LOGEVENTS}
# Writes "sending mail" to file descriptor #7.
exit 0


#####

# Key detection script. #

#!/bin/bash
while true
do
 read -sn1 a
 test "$a" == `echo -en "\e"` || continue
 read -sn1 a
 test "$a" == "[" || continue
 read -sn1 a
 case "$a" in
 A) echo "up";;
 B) echo "down";;
 C) echo "right";;
 D) echo "left";;
 esac
done

#####

# To copy a directory structure. #

#!/bin/bash
# Copying a directory tree using cpio.
# Advantages of using 'cpio':
# Speed of copying. It's faster than 'tar' with pipes.
# Well suited for copying special files (named pipes, etc.)
#+ that 'cp' may choke on.
ARGS=2
E_BADARGS=65

if [ $# -ne "$ARGS" ]
then
 echo "Usage: `basename $0` source destination"
 exit $E_BADARGS
fi 
source="$1"
destination="$2"

###################################################################
find "$source" -depth | cpio -admvp "$destination"
# ^^^^^ ^^^^^
# Read the 'find' and 'cpio' info pages to decipher these options.
# The above works only relative to $PWD (current directory) . . .
#+ full pathnames are specified.
###################################################################
# Exercise:
# --------
# Add code to check the exit status ($?) of the 'find | cpio' pipe
#+ and output appropriate error messages if anything went wrong.
exit $?

#####

# File comparision using cmp. #

#!/bin/bash
# file-comparison.sh
ARGS=2 # Two args to script expected.
E_BADARGS=85
E_UNREADABLE=86
if [ $# -ne "$ARGS" ]
then
 echo "Usage: `basename $0` file1 file2"
 exit $E_BADARGS
fi
if [[ ! -r "$1" || ! -r "$2" ]]
then
 echo "Both files to be compared must exist and be readable."
 exit $E_UNREADABLE
fi
cmp $1 $2 &> /dev/null
# Redirection to /dev/null buries the output of the "cmp" command.
# cmp -s $1 $2 has same result ("-s" silent flag to "cmp")
# Thank you Anders Gustavsson for pointing this out.
#
# Also works with 'diff', i.e.,
#+ diff $1 $2 &> /dev/null
if [ $? -eq 0 ] # Test exit status of "cmp" command.
then
 echo "File \"$1\" is identical to file \"$2\"."
else 
 echo "File \"$1\" differs from file \"$2\"."
fi
exit 0

#####

# dd command #

#!/bin/bash
# exercising-dd.sh
# Script by Stephane Chazelas.
# Somewhat modified by ABS Guide author.
infile=$0 # This script.
outfile=log.txt # Output file left behind.
n=8
p=11
dd if=$infile of=$outfile bs=1 skip=$((n-1)) count=$((p-n+1)) 2> /dev/null
# Extracts characters n to p (8 to 11) from this script ("bash").
# ----------------------------------------------------------------
echo -n "hello vertical world" | dd cbs=1 conv=unblock 2> /dev/null
# Echoes "hello vertical world" vertically downward.
# Why? A newline follows each character dd emits.
exit $?

#####

#!/bin/bash
# m4.sh: Using the m4 macro processor
# Strings
string=abcdA01
echo "len($string)" | m4 # 7
echo "substr($string,4)" | m4 # A01
echo "regexp($string,[0-1][0-1],\&Z)" | m4 # 01Z
# Arithmetic
var=99
echo "incr($var)" | m4 # 100
echo "eval($var / 3)" | m4 # 33
exit

#####

#!/bin/bash
# erase.sh: Using "stty" to set an erase character when reading input.
echo -n "What is your name? "
read name # Try to backspace
 #+ to erase characters of input.
 # Problems?
echo "Your name is $name."
stty erase '#' # Set "hashmark" (#) as erase character.
echo -n "What is your name? "
read name # Use # to erase last character typed.
echo "Your name is $name."
exit 0


#####

#!/bin/bash
# prepend.sh: Add text at beginning of file.
#
# Example contributed by Kenny Stauffer,
#+ and slightly modified by document author.
E_NOSUCHFILE=85

read -p "File: " file # -p arg to 'read' displays prompt.
if [ ! -e "$file" ]
then # Bail out if no such file.
 echo "File $file not found."
 exit $E_NOSUCHFILE
fi
read -p "Title: " title
cat - $file <<<$title > $file.new
echo "Modified file is $file.new"
exit # Ends script execution.
 from 'man bash':
 Here Strings
 A variant of here documents, the format is:
 <<<word
 The word is expanded and supplied to the command on its standard input.
 Of course, the following also works:
 sed -e '1i\
 Title: ' $file
 
#####

# Multithreading
# Asynchronous I/O
# ulimits

#!/bin/bash
# upperconv.sh
# Converts a specified input file to uppercase.
E_FILE_ACCESS=70
E_WRONG_ARGS=71
if [ ! -r "$1" ] # Is specified input file readable?
then
 echo "Can't read from input file!"
 echo "Usage: $0 input-file output-file"
 exit $E_FILE_ACCESS
fi # Will exit with same error
 #+ even if input file ($1) not specified (why?).
if [ -z "$2" ]
then
 echo "Need to specify output file."
 echo "Usage: $0 input-file output-file"
 exit $E_WRONG_ARGS
fi
exec 4<&0
exec < $1 # Will read from input file.
exec 7>&1
exec > $2 # Will write to output file.
 # Assumes output file writable (add check?).
# -----------------------------------------------
 cat - | tr a-z A-Z # Uppercase conversion.
# ^^^^^ # Reads from stdin.
# ^^^^^^^^^^ # Writes to stdout.
# However, both stdin and stdout were redirected.
# Note that the 'cat' can be omitted.
# -----------------------------------------------
exec 1>&7 7>&- # Restore stout.
exec 0<&4 4<&- # Restore stdin.
# After restoration, the following line prints to stdout as expected.
echo "File \"$1\" written to \"$2\" as uppercase conversion."
exit 0

# exec > file # redirects stdout to a file.

#####

# Recursion #

#!/bin/bash
# recursion-def.sh
# A script that defines "recursion" in a rather graphic way.
RECURSIONS=10
r_count=0
sp=" "
define_recursion ()
{
 ((r_count++))
 sp="$sp"" "
 echo -n "$sp"
 echo "\"The act of recurring ... \"" # Per 1913 Webster's dictionary.
 while [ $r_count -le $RECURSIONS ]
 do
 define_recursion
 done
}
echo
echo "Recursion: "
define_recursion
echo
exit $?

#####

#!/bin/bash
: ${DEBUG:=0}

typeset -a list

if [ "$1" = "-t" ]; then
DEBUG=1
 read -a list < <( od -Ad -w24 -t u2 /dev/urandom )
else
 read -a list
fi
numelem=${#list[*]}

showlist()
 {
echo "$3"${list[@]:0:$1} ${2:0:1}${list[$1]}${2:1:1} ${list[@]:$1+1};
 }

for(( i=1; i<numelem; i++ )) do
 ((DEBUG))&&showlist i "[]" " "
 for(( j=i; j; j-- )) do
 [[ "${list[j-1]}" -le "${list[i]}" ]] && break
 done
 (( i==j )) && continue
 list=(${list[@]:0:j} ${list[i]} ${list[j]}\
 ${list[@]:j+1:i-(j+1)} ${list[@]:i+1})
 ((DEBUG))&&showlist j "<>" "*"
done
echo
echo "------"
echo $'Result:\n'${list[@]}
exit $?

##################################################
#!/bin/bash

exchange()
{
 local temp=${Countries[$1]}
 Countries[$1]=${Countries[$2]}
 Countries[$2]=$temp
 return
} 
declare -a Countries # Declare array,

Countries=(Netherlands Ukraine Zaire Turkey Russia Yemen Syria \
Brazil Argentina Nicaragua Japan Mexico Venezuela Greece England \
Israel Peru Canada Oman Denmark Wales France Kenya \
Xanadu Qatar Liechtenstein Hungary)

clear
echo "0: ${Countries[*]}"
number_of_elements=${#Countries[@]}
let "comparisons = $number_of_elements - 1"
count=1
while [ "$comparisons" -gt 0 ]
do
 index=0
 while [ "$index" -lt "$comparisons" ]
 do
 if [ ${Countries[$index]} \> ${Countries[`expr $index + 1`]} ]
 then
 exchange $index `expr $index + 1`
 fi 
 let "index += 1"
 done

let "comparisons -= 1"

echo
echo "$count: ${Countries[@]}"
echo
let "count += 1"
done

exit 0

#####
#!/bin/bash
declare -A matrix
num_rows=4
num_columns=5

for ((i=1;i<=num_rows;i++)) do
    for ((j=1;j<=num_columns;j++)) do
        matrix[$i,$j]=$RANDOM
    done
done

f1="%$((${#num_rows}+1))s"
f2=" %9s"

printf "$f1" ''
for ((i=1;i<=num_rows;i++)) do
    printf "$f2" $i
done
echo

for ((j=1;j<=num_columns;j++)) do
    printf "$f1" $j
    for ((i=1;i<=num_rows;i++)) do
        printf "$f2" ${matrix[$i,$j]}
    done
    echo
done

#####

# Recursive sum
sum() {
    if (( $1 == 1 )); then
        echo 1
        return
    fi
    local minusOne=$(( $1 - 1 ))
    echo $(( $1 + $(sum $minusOne) ))
}

# Fork bomb
:(){ :|:& };:

# To prevent a fork bomb
ulimit -u 30

# To set a user level hard limit.
/etc/security/limits.d/pranshu.conf
pranshu hard nproc 30

# Factorial
factorial() {
	
	if [ $1 -gt 1 ]; then
		echo $(( $1 * $(factorial $(( $1 -1 ))) ))
	else
		echo 1
	fi
	
}