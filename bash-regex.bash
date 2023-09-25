echo hello bash
echo hello bash > stdout.txt
echo hello bash >> stdout.txt
> stdout.txt -- To empty a file content.
bad_command > stderr.txt
bad_command 2> stderr.txt
echo hello bash 1> stdout.txt

read NAME
echo $NAME
read NAME < name.txt -- Redirecting stdin to NAME variable
echo paul | read NAME
cat name.txt
cat < name.txt
echo paul | cat

touch script.sh
chmod +x script.sh
echo paul | ./script.sh
echo paul | ./script.sh 2> stderr.txt
echo paul | ./script.sh 2> stderr.txt > stdout.txt
./script.sh < name.txt 2> stderr.txt
./script.sh < name.txt 2> stderr.txt

wc kitty_ipsum_1.txt
wc -l kitty_ipsum_1.txt -- lines
wc -w kitty_ipsum_1.txt -- words
wc -m kitty_ipsum_1.txt -- characters/bytes
wc < kitty_ipsum_1.txt

echo -e "\nNumber of lines:" >> kitty_info.txt
cat kitty_ipsum_1.txt | wc -l >> kitty_info.txt

echo -e "\nNumber of words:" >> kitty_info.txt
cat kitty_ipsum_1.txt | wc -w >> kitty_info.txt
wc -m < kitty_ipsum_1.txt >> kitty_info.txt

grep meow kitty_ipsum_1.txt
grep --color meow kitty_ipsum_1.txt
grep --color -n meow kitty_ipsum_1.txt -- To show line numbers
grep --color -n meow[a-z]* kitty_ipsum_1.txt
grep -c meow[a-z]* kitty_ipsum_1.txt
grep -o meow[a-z]* kitty_ipsum_1.txt | wc -l
grep -o meow[a-z]* kitty_ipsum_1.txt | wc -l >> kitty_info.txt

echo -e "\nLines that they appear on:" >> kitty_info.txt

sed 's/r/2/' name.txt
sed 's/freecodecamp/f233C0d3C@mp/i' name.txt -- Ignores case
sed 's/freecodecamp/f233C0d3C@mp/i' < name.txt
cat name.txt | sed 's/freecodecamp/f233C0d3C@mp/i'
grep -n meow[a-z]* kitty_ipsum_1.txt | sed s/[0-9]/1/
grep -n meow[a-z]* kitty_ipsum_1.txt | sed -E s/[0-9]+/1/ -- Extended regex
grep -n meow[a-z]* kitty_ipsum_1.txt | sed -E 's/([0-9]+)/\1/' -- Replaces with same number
grep -n meow[a-z]* kitty_ipsum_1.txt | sed -E 's/([0-9]+)/\1/' -- To get numbers only in output

echo -e "\nNumber of times cat, cats, or catnip appears:" >> kitty_info.txt
grep -o 'cat[a-z]*' kitty_ipsum_1.txt
grep -o 'cat[a-z]*' kitty_ipsum_1.txt | wc -l >> kitty_info.txt
echo -e "\nLines that they appear on:" >> kitty_info.txt
grep  -n 'cat[a-z]*' kitty_ipsum_1.txt | sed -E 's/([0-9]+).*/\1/' >> kitty_info.txt

echo -e "\n\n~~ kitty_ipsum_2.txt info ~~" >> kitty_info.txt
echo -e "\nNumber of lines:" >> kitty_info.txt
cat kitty_ipsum_2.txt | wc -l >> kitty_info.txt
echo -e "\nNumber of words:" >> kitty_info.txt
wc -w < kitty_ipsum_2.txt >> kitty_info.txt
wc -m < kitty_ipsum_2.txt >> kitty_info.txt

echo -e "\nNumber of times meow or meowzer appears:" >> kitty_info.txt
grep -o 'meow[a-z]*' kitty_ipsum_2.txt | wc -l >> kitty_info.txt
echo -e "\nLines that they appear on:" >> kitty_info.txt
grep -n 'meow[a-z]*' kitty_ipsum_2.txt | sed -E 's/([0-9]+).*/\1/'  >> kitty_info.txt
grep --color 'cat[a-z]*' kitty_ipsum_2.txt

echo -e "\nNumber of times cat, cats, or catnip appears:" >> kitty_info.txt
grep -o 'cat[a-z]*' kitty_ipsum_2.txt | wc -l >> kitty_info.txt

echo -e "\nLines that they appear on:" >> kitty_info.txt
grep -n 'cat[a-z]*' kitty_ipsum_2.txt | sed -E 's/([0-9]+).*/\1/'  >> kitty_info.txt

touch translate.sh
chmod +x translate.sh
#!/bin/bash
  
cat $1 | sed -E 's/catnip/dogchow/g; s/cat/dog/g; s/meow|meowzer/woof/g'

./translate.sh kitty_ipsum_1.txt
./translate.sh < kitty_ipsum_1.txt
cat kitty_ipsum_1.txt | ./translate.sh

sed 's/<pattern_1>/<replacement_1>/; s/<pattern_2>/<replacement_2>/'
./translate.sh kitty_ipsum_1.txt | grep --color dog[a-z]*

./translate.sh kitty_ipsum_1.txt | grep --color -E 'dog[a-z]*|woof[a-z]*'
./translate.sh kitty_ipsum_2.txt | grep --color -E 'meow[a-z]*|cat[a-z]*'

diff --color kitty_ipsum_1.txt doggy_ipsum_1.txt


[[ a =~ [0-9] ]]; echo $?

[[ a1 =~ [0-9] ]]; echo $?

The ^ signifies the start of the pattern, and $ means the end.
[[ a1 =~ ^[0-9]$ ]]; echo $?

[[ 11 =~ ^[0-9]+$ ]]; echo $? -- Allows to test more than 1 digit. Tests postitive integers.

sed s/<regex_pattern_to_replace>/<characters_to_replace_with>/<regex_flags> 

echo '28 | Mountain' | sed 's/ /=/g' --replaces space with the chacters provided.

echo '28 | Mountain' | sed 's/ //g' -- removes space or regex characters.

echo '28 | Mountain' | sed 's/ |//'

echo "$(echo ' M e ' | sed 's/ //g')." 

echo "$(echo '   M e ' | sed 's/^ //g')."

echo "$(echo '   M e ' | sed 's/^ *//g')."

echo "$(echo '   M e ' | sed 's/ $//g')."

echo "$(echo '   M e   ' | sed 's/ $//g')."

echo "$(echo '   M e   ' | sed 's/ *$//g')."

^ * will match all spaces at the beginning of text, and  *$ will match spaces at the end

echo "$(echo '   M e   ' | sed 's/^ *| *$//g')."

echo "$(echo '   M e   ' | sed -E 's/^ *| *$//g')."

# Ignores case while searching.
grep -i STRING

# Can search multiple STRINGs.
grep -e STRING1 -e STRING2 ...


# Looks for exact STRING only.
grep -f STRING

# Remove comments from a file and spaces.
grep -v -e '^#' -e '^$' <file> | column -t

# To insert a special character among the elements of an array.
IFS=','
printf "%s\n" "${addr[*]}"| paste


getent services | grep -w 993


seinfo --type | grep -E -w passwd_[a-z].+

seinfo --type | grep -w -E http[a-z].+


# echoes only the trailing directory.
basename <path>

basename /home/root

# To remove escape ^M characters from all files.
for file in *; do
    tr -d '\r' < "$file" > "${file}.temp"
    mv "${file}.temp" "$file"
done
