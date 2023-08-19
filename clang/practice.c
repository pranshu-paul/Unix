#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

int addNumbers(int num1, int num2);

// Structs

struct Book
{
     char title[100];
     char author[100];
     int numPages;
};

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

int num1 = 10;

// +=, -=, /=, *=
num1 += 100;
printf("%d \n", num1);

num1++;
printf("%d \n", num1);

// math operation.
printf("%f \n", pow(2, 3));

printf("%f \n", sqrt(144));

printf("%f \n", round(2.7));

//// User input.
//
//char name1[10];
//printf("Enter your name: ");
//
//// Getting the user input upto 10 characters only.
//fgets(name1, 10, stdin);
//printf("Hello %s! \n", name1);
//
//int age3;
//printf("Enter your age: ");
//
//// Getting the user input and storing the value its memory address.
//scanf("%d", &age3);
//
//printf("You are %d \n", age3);
//
//char grade;
//printf("Enter your grade: ");
//scanf("%c", &grade);
//printf("You got an %c on the test \n", grade);
//
//double gpa;
//printf("Enter you gpa");
//scanf("%lf", &gpa);
//printf("Your gpa is %f \n", gpa);

// Arrays
int luckyNumber[] = {4, 8, 15, 16, 23, 42};
//             indexes: 0 1 2 3 4 5

luckyNumber[0] = 90;
printf("%d \n", luckyNumber[0]);
printf("%d \n", luckyNumber[1]);


int sum = addNumbers(4, 60);
     printf("%d \n", sum);


int isStudent = 0;
int isSmart = 0;

if (isStudent != 0 && isSmart != 0)
{
     /* code */
     printf("You are a student\n");
} else if (isStudent != 0 && isSmart == 0)
{
     /* code */
     printf("You are not a smart student\n");
} else
{
     printf("You are not a student and not smart\n");
}

if (1 > 3)
{
     /* code */
     printf("number comparison was true\n");
}

if ('a' > 'b') {
     printf("character comparison was true\n");
}

char myGrade = 'A';
switch (myGrade)
{
case 'A':
     printf("You Pass\n");
     break;
case 'F':
     printf("You fail\n");
     break;
default:
     printf("Invalid grade\n");
}

// While loop
int index = 1;
while (index <= 5)
{
     index++; // by removing this it would become an infinite loop
     printf("%d \n", index);
}


// do while loop
index = 1;

do
{
     printf("%d \n", index);
     index++;
} while (index <= 5);

for (int i = 0; i < 5; i++)
{
     printf("%d \n", i);
}




struct Book book1;
book1.numPages = 600;
strcpy( book1.title, "Harry Potter" );
strcpy( book1.author, "JK Rowling" );

printf("%s \n", book1.title);
printf("The book has %d pages.", book1.numPages);

     return 0;
}


int addNumbers(int num1, int num2){
     return num1 + num2;
}

