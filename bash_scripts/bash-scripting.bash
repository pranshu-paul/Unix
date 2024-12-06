# BASH commands and scripting.

# Arrays

# Declare an array.
declare -a addr

# Declare a local array (inside a function).
local -a addr

# Adding elements into an array.
addr=("1" "2" "3" "4" "5" "6" "7")

# Declare an array for integers.
declare -i addr

# Adding elements in an array through indexes.
addr[0]="2"
addr[1]="8"
addr[2]="7"
addr[3]="5"

IFS='+'

# To perform a mathmatical operation on the elements of an array use * as index.
printf "%s\n" "${addr[*]}"| paste | bc

# BSD expression. (IFS is not required)
paste -s -d '+' <(printf "%s\n" "${addr[*]}") | bc

# Declare an array for string
declare -a addr

# Adding the output of an command in an array by removing the \n newline character from the end of a line.
readarray -t addr <<< $(find $PWD)

declare -a array
array=($(<command>))

# To capture all the files and directories excluding the current and parent in an array.
declare -a files
files=(* .[^.]*)

# Print all the elements.
printf "%s\n" "${addr[@]}"

# Print a specific index.
printf "%s\n" "${addr[1]}"

# Print a negative index.
# If the elements of an array are 6.
# The below statement prints the fifth index of the elements.
printf "%s\n" "${addr[-1]}"

# Print some specific elements of an array.
# The below example prints from the fourth element to the ninth element, a total of five elements.
printf "%s\n" "${addr[@]:3:5}"


# Performing an iteration on an array.
# If each elements contains space use a for loop.
# "!" lists the all index number.
# "#" lists the total index number.
for i in "${!attachment[@]}";do
	echo "${attachment[$i]}"
done

#####

# To create an associative array in bash (Dictionary).
declare -A array

array[name]=pranshu
array[age]=23
array[email]=paulpranshu@gmail.com
array[phone]=9873514389


# Adding a new element in the associative array.
# It adds elements at the top of the array.
array+=[country]=India
array+=([state]=Delhi)

# To delete an element.
unset array[state]

# To list a particular elements.
echo "${array[name]}"

# To total number of elements.
echo "${#array[@]}"

# To list all the elements in an array.
printf "%s\n" "${array[@]}"

# To list all the elements using a for loop.
for key in "${!array[@]}"; do
	echo "${array[$key]}"
done

#####

# Variables
# The below variables captures the line in a script where it is placed.
# It can also be used in a terminal.
echo $LINENO

# It returns the name of the function, inside a function when called.
func() { echo $FUNCNAME; }; func

# Shows the level of shells opened.
echo $SHLVL

echo $BASH_COMMAND

#####

# Redirection.
exec 3>&1 1> "$LOGFILE"

# Redirecting all outputs and errors to a file
exec >> "${log_file}" 2>&1

# Same as the above command.
exec &>> "${log_file}"

# To open a new shell and exit the previous one (Fresh environment).
exec -l bash

# To create a standard error message. Redirect the error using the file descriptor.
echo "Some error" >&2

# To create a redirection space instead in a file. Create named pipes.
# It doesn't consume space on drive.
mkfifo my_pipe

ls -lR / &> my_pipe

# Later the output can be seen from the pipe file.
cat < my_pipe

# cat <(ls -l) becomes cat /dev/fd/63

# Redirect the output of a command to another command as a file.
cat <(ls -l)
nl <(ping -c4 google.com)

# Here - is same as stdout
pdftotext file.pdf - | grep "search_term"

#####

## Control Flow Statements ##
if [ condition ]; then
    # commands to run if condition is true
else
    # commands to run if condition is false
fi


if [ condition ]; then
    # commands to run if condition is true
elif [ condition ]; then
	# commands to run if condition is true
else
    # commands to run if all the conditions are false
fi


for variable in value1 value2 ... valuen; do
    # commands to run for each iteration
done

# Infinite for loop.
for (( ; ; )); do
    # commands to run for each iteration
done

for (( i=0; i<=10; i++ )); do
	echo $i
done


while [ condition ]; do
    # commands to run while condition is true
done

while read out; do
	((size+=out))
done < <(ls -lAR | awk '{print $5}')

i=1; while [ $i -le 10 ]; do
  ((sum+=i))
  ((i++))
done

# A do-while loop
num=1

while true
do
   echo Number: $num
   let num++

   if [ $num -lt 5 ]; then
       break
   fi
done

# Infinite while loop.
while true; do
    # commands to run while condition is true
done

until [ condition ]; do
    # commands to run until condition is true
done


case "$variable" in
    pattern1)
        # commands for pattern1
        ;;
    pattern2)
        # commands for pattern2
        ;;
    *)
        # commands for all other cases
        ;;
esac

variable=true

case "$variable" in
    true)
        echo true;;
    false)
        echo false;;
    *)
        echo Not a boolean;;
esac


while [ condition ]; do
    if [ another_condition ]; then
        break  # exit the loop
    fi
    # other commands
done

while [ condition ]; do
    if [ skip_condition ]; then
        continue  # skip the rest of this iteration
    fi
    # other commands
done


select variable in option1 option2 ... optionN; do
    case $variable in
        option1)
            # commands for option1
            ;;
        option2)
            # commands for option2
            ;;
        *)
            # commands for all other cases
            ;;
    esac
done

# Open a file descriptor.
exec 3> /tmp/src_hosts

# Close a file descriptor.
exec 3>&-

# Open again for capturing data.
exec 3< /tmp/src_hosts

# Pass the data to make an array.
readarray -t src_hosts <&3

# Lists the current open file descriptors.
ls -la /proc/$$/fd

# To empty a file descriptor.
: > /proc/self/fd/3

# Define a function
# A function can also be difned like "function <function_name> () { <command> }

my_function() {
    # Commands to be executed inside the function
    echo "Hello from my_function!"
	echo "Returning the function $FUNCNAME name."
}

# Call the function
my_function

# To execute command parallely in a script
#!/bin/bash

hosts=("141.148.218.174" "141.148.218.174")

declare -a pids
declare -A exit_codes

for host in "${hosts[@]}"; do
    echo "$host" &
    pids+=("$!")
	
	for ((i = 0; i < ${#pids[@]}; i++)); do
		wait "${pids[$i]}"
		exit_codes["${pids[$i]}"]=$?
	done
	
done

echo "Exit codes:"
for pid in "${!exit_codes[@]}"; do
    echo "PID: $pid, Exit code: ${exit_codes[$pid]}"
done

# Pass arrays and associative arrays to a function.

#!/bin/bash

declare -a gl_array=(
	"element1"
	"element2"
)

declare -A gl_dict=(
	["key1"]=value1
	["key2"]=value2
)

func() {
    local -n array=$1
    local -n dict=$2

    for el in "${array[@]}"; do
        for key in "${!dict[@]}"; do
            echo "$el $key ${dict[$key]}"
        done
    done
}

main() {
    func gl_array gl_dict
}

main

###################################################################################

# Bash configuration files 
# /etc/profile The systemwide initialization file, executed for login shells
# /etc/bash.bash_logout The systemwide login shell cleanup file, executed when a login shell exits
# ~/.bash_profile The personal initialization file, executed for login shells
# ~/.bashrc The individual per-interactive-shell startup file
# ~/.bash_logout The individual login shell cleanup file, executed when a login shell exits
# ~/.inputrc Individual readline initialization file (Maps keys with a command for a user)

# Green
echo -e "\e[38mgreen\e[0m"

# Blue
echo -e "\e[34mblue\e[0m"

# Red
echo -e "\e[31mred\e[0m"

# Other options with echo
echo -e "\e[5mThis is blinking text\e[0m"

echo -e "\e[1mThis is bold text\e[0m"

echo -e "\e[7mThis is inverse video text\e[0m"

echo -e "\e[1m\e[4mThis is bold and underlined text\e[0m"

echo -e "\e[4mThis is underlined text\e[0m"

echo -e "\e[9mThis is strikethrough text\e[0m"


#####

# Executes the commands and shell characters inside a variable
eval

pipe='|'

eval ps -ef $pipe wc -l

nc=netcat

eval $nc

#####

# To add directories in a stack
pushd <path>
pushd $PWD
pushd $OLDPWD

# To remove directories from the stack.
popd
popd <dir>

# To list the directory index.
dirs -v

# To change to a particular directory by its index.
cd ~<index_num>

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

divide () {
  local x=$1
  local y=$2
  local value=${3:-2}  # Use default value 2 if $3 is empty

  local precision="$((20 - value))"

  local output="$(bc -l <<< $x/$y)"

  echo "$x/$y = ${output::-$precision}"
}