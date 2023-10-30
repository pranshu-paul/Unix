#include <stdio.h>
#include <ctype.h>

int main() {
//     int age; 

//     printf("\nEnter your age: ");
//     scanf("%d", &age);
//
//     if (age >= 18)
//     {
//          printf("You can drive!");
//     }
//     else if (age == 0)
//     {
//          printf("You can't drive! You were just born!");
//     }     
//     else if (age < 0)
//     {
//          printf("You haven't been born yet!");
//     }
//     else
//     {
//          printf("You are too young to sign up!");
//     }
     
//char grade;
//
//printf("\nEnter a letter grade: ");
//scanf("%c", &grade);
//
//switch (grade)
//{
//case 'A':
//     printf("perfect!\n");
//     break;
//case 'B':
//     printf("You did good!\n");
//     break;
//case 'C':
//     printf("You did okay!\n");
//     break;
//case 'D':
//     printf("At least it's not an F!\n");
//     break;
//case 'F':
//     printf("YOU FAILED\n");
//     break;
//default:
//     printf("Please enter a valid grade!\n");
//     break;
//}

char unit;
float temp;

printf("\nIs the temperature in (F) or (C)?: ");
scanf("%c", &unit);

     unit = toupper(unit);

     if (unit == 'C')
     {
          printf("Enter the temperature in C: ");
          scanf("%f", &temp);
          temp = (temp * 9 / 5) + 32;
          printf("The temp in Farenheit is: %.1f\n", temp);
     }
     else if (unit == 'F')
     {
          printf("Enter the temperature in F: ");
          scanf("%f", &temp);
          temp = ((temp - 32) * 5) / 9;
          printf("The temp in Celsium is: %.1f\n", temp);
     }
     else
     {
          printf("\n %c is not a valid unit of measurement", unit);
     }
     


     return 0;
}