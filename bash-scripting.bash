# BASH commands and scripting.

# Arrays

# Declaring an array.
declare -a addr

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

# To perform a mathmatical operation on the elements of an array.
printf "%s\n" "${addr[*]}"| paste | bc

# Declare an array for string
declare -a addr

# Adding the output of an command in an array.
readarray -t addr <<< $(find $PWD)

# Print all the elements.
printf "%s\n" "${addr[@]}"

# Print some specific elements of an array.
# The below example prints from the fourth element to the ninth element, a total of five elements.
printf "%s\n" "${addr[@]:3:5}"


# Performing an iteration on an array.
# "!" lists the all index number.
# "#" lists the total index number.
for i in "${!attachment[@]}"
do echo "${attachment[$i]}"
done