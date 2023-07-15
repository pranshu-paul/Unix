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