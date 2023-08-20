// Source code structure.
// Compiler compiles codes to machine code.

/*
Author: Pranshu Paul
Program: Hello, World!
Description: This program prints hello, world to the screen!
*/
#include <stdio.h>

int main(void)
{
     printf("Hello, World!\n");

//     int speed = 20;
//     int time = 7;
//
//     int distance = speed * time;
//
//     printf("Distance = %d", distance);
//
//     int speed, time = 0;
//
//     printf("Speed: ");
//     scanf("%d", &speed);
//
//     printf("Time: ");
//     scanf("%d", &time);
//
//     int distance = speed * time;
//
//     printf("Distance = %d\n", distance);
//
//     float x, y = 0;
//
//     printf("x: ");
//     scanf("%f", &x);
//
//     printf("y: ");
//     scanf("%f", &y);
//
//     printf("x * y = %.2f", x * y);

//     char c = 'd';
//
//     printf("Enter a character: ");
//     scanf("%c", &c);
//
//     printf("The character entered is: %c\n", c);
//     printf("The decimal number of the character entered is: %d\n", c);

     double x = 5.2, y = 2.5;

     int a = 9, b = 4;

     double mutl = x * y;
     double add = x + y;
     double div = x / y;
     double sub = x - y;
     
     // modulus operator takes only: int, short
     // no "double"
     int mod = a % b;

     printf("mult: %.2f\n", mutl);
     printf("add: %.2f\n", add);
     printf("div: %.2f\n", div);
     printf("sub: %.2f\n", sub);
     printf("mod: %d\n", mod);

     int grade = 0;

     printf("Grade: ");
     scanf("%d", &grade);

//     if (grade >= 50 )
//     {
//          printf("Pass\n");
//          printf("Congrats!\n");
//     }
//     else
//     {
//          printf("Fail\n");
//          printf("Good luck next time!\n");
//     }
     
     if (grade >= 90) printf("A\n");
     else if (grade >= 80) printf("B\n");
     else if (grade >= 70) printf("C\n");
     else if (grade >= 60) printf("D\n");
     else printf("Other\n");

     return 0;
}


