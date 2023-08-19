#include <stdio.h>
#include <stdlib.h>

int main (void) {
     printf("Hello\n");
     printf("World");
     printf("!\n");

// single 8-bit character.
char testGrade = 'A';

// array of characters (string)
char name[] = "Mike";

// 16-bits signed integer.
short age0 = 10;

// 16-bits singed integer.
int age1 = 20;

// 32-bits signed integer.
long age2 = 30;

// 64-bits signed intger.
long long age = 40;

// single precision floating point.
float gpa0 = 2.5;

// double-precision floating point.
double gpa1 = 3.5;

// extended-precision floating point.
long double gpa2 = 4.5;

int isTall = 1;

testGrade = 'F';

printf("%s, your grade is %c \n", name, testGrade);

// Casting and data-type conversion.
printf("%d \n", (int)3.14);
printf("%f \n", (double)3 / 2);

int num = 10;

// Printing the memory address.
printf("%p \n", &num);

// Storing the memory address in a variable Num.
int *pNum = &num;

// Priting the memory address stored in the variable pNum.
printf("%p \n", pNum);

// Dereferencing the variable (Printing the value stored in that memory address.).
printf("%d \n", *pNum);

// Performing arithmetic operations.

printf("%d \n", 2 * 3);
printf("%d \n", 10 % 3);
printf("%d \n", 1 + 2 * 3);
printf("%f \n", 10 / 3.0);

     return 0;
}