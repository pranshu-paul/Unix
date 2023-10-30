#include <stdio.h>
#include <string.h>

int main(int argc, char const *argv[])
{
     char string1[] = "Bro";
     char string2[] = "Code";

     // strlwr(string1); // Convert to lower.
     // strupr(string1); // to upper
     // strcat(string1, string2); // combines two strings
     // strncat(string1, string2, 2); // appends n characters from string2 to string1
     // strcpy(string1, string2); // copies string2 to string1
     // strncpy(string1, string2, 2);

     // strset(string1, '?'); // sets all the characters to the given character.
     // strnset(string1, '?', 1); // sets first n character of a string to a given character.
     // strrev(string1); // reverses a string

     // int result = strlen(string1); // returns string length as int
     // int result = strcmp(string1, string2);
     // int result = strcmpi(string1, string2);
     int result = strnicmp(string1, string2, 1);
     printf("%d\n", result);

     if (result == 0)
     {
          printf("Strings are same.");
     }
     else
     {
          printf("Strings are not same.");
     }
     

     return 0;
}
