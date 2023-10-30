#include <stdio.h>
#include <string.h>

int main() {
     int age;

     char name[25];

     printf("Enter your name\n");
     fgets(name, 25, stdin); // getting input from stdin
     name[strlen(name)-1] = '\0'; // alterting the last index of the array from \n to \0
     //scanf("%s", &name);

     printf("Enter your age: \n");
     scanf("%d", &age);

     printf("Hello %s, You are %d years old\n", name, age);

     return 0;

}