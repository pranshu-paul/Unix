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

//     int grade = 60;

//     printf("Grade: ");
//     scanf("%d", &grade);

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
     
//     if (grade >= 90) printf("A\n");
//     else if (grade >= 80) printf("B\n");
//     else if (grade >= 70) printf("C\n");
//     else if (grade >= 60) printf("D\n");
//     else printf("Other\n");

     int height = 10;
     // printf("height: ");
     // scanf("%d", &height);

     int weight = 20;
     // printf("weight :");
     // scanf("%d", &weight);

     if (height > 150 && weight > 50)
     {
          printf("Good to ride!\n");
     }
     else
     {
          printf("Not good to ride!\n");
     }

     if (! (height > 150))
     {
          printf("Not tall enough!\n");
     }
     else
     {
          printf("Tall enough!\n");
     }
     
//     int i = 0;
//     int number = 0;
//     int total = 0;
//     int totalNumbers = 0;
//
//     printf("How many numbers: ");
//     scanf("%d", &totalNumbers);
//
//     while (i < totalNumbers)
//     {
//          printf("Enter number %d: ", i+1);
//          scanf("%d", &number);
//
//          total = total + number;
//          i = i + 1;
//     }
//     printf("total: %d\n", total);
//     printf("average: %d", total/totalNumbers);

//     int number = 0;
//     int max = -1;
//     while (number != -1)
//     {
//          printf("Enter a number: ");
//          scanf("%d", &number);
//
//          if (number > max) max = number;
//     }
//
//     printf("max: %d\n", max);
     
//     int i = 0;
//     int number = 0;
//     do
//     {
//          printf("Enter number (>0): ", i);
//          scanf("%d", &number);
//          if (number <= 0)
//               printf("Number must be >0!\n");
//     }    while (number <= 0);
     
     int i = 0;

     for (i = 0; i < 10; i++)
     {
          printf("i: %d\n", i);
     }
     

     double initial = 0, step = 0, stop = 0;

//     do
//     {
//          printf("Initial (m): ");
//          scanf("%lf", &initial);
//          if (initial < 0) printf("Must be >=0\n");
//     } while (initial < 0);
//
//     do
//     {
//          printf("Step (m): ");
//          scanf("%lf", &step);
//          if (step <= 0) printf("Must be >=0\n");
//     } while (step <= 0);
//
//     do
//     {
//          printf("Stop (m): ");
//          scanf("%lf", &stop);
//          if (stop < 0) printf("Must be >=0\n");
//     } while (stop < 0);
     
     
//     for (double conv = initial; conv <= stop; conv += step)
//     {
//          printf("%f %f \n", conv, conv * 3.28084);
//     }
          
     printf("\n");

     printf("Meters Feet\n");
     printf("********************\n");

//     for (double conv = initial; conv <= stop; conv += step)
//     {
//         printf("%.2f %.2f\n", conv, conv * 3.28084);
//         printf("%-5.2f %-5.2f\n", conv, conv * 3.28084);
//
//     }

     int number = 3;
     switch (number)
     {
          case 0:
          printf("Case 0!\n");
          break;

          case 1:
          printf("Case 1!\n");
          break;

          case 2:
          printf("Case 2!\n");
          break;

          default:
          printf("Default case!\n");
     }

     int grade[5] = {92, 85, 72, 73, 95};
     
     // we can't add an extra element in an array.
     // the compilar would give just a warning for this.
     grade[5] = 100;

     printf("grade[2] = %d\n\n", grade[2]);

     for (int i = 0; i <= 5; i++)
     {
          printf("grade[%d] = %d\n", i, grade[i]);
     }
     
// adding the elements of an array.
     int total = 0;
     for (int i = 0; i <= 5; i++)
     {
          total += grade[i];

         
     }
      printf("average %d\n", total / 5);

     return 0;
}


