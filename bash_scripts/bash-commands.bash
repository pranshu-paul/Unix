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