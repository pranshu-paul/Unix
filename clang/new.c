#include <stdio.h>

int main() {

     // This is a comment.
     /*
     This
     is
     a 
     multiline 
     comment.
     */

    /*
    Escape characters
    \n = newline
    \t = tab
    \\ = takes \ literally
    \' = takes ' literally
    \" = takes " literally
    */

     printf("I \n like \n pizza!\n");
     printf("It's really good!\n");
     printf("1 \t 2 \t  3\n4 \t 5 \t  6\n7 \t 8 \t  9\n");
     printf("\\I like Pizza\\ - Abraham Lincoln probably. \n");


     // variable = a human readable memory address.

     int xx; // declaration
     xx = 123; // initialization

     int yy = 321; // declaration + initialization

     int age = 21; // integer

     float gpa = 2.05; // decimal point number. 4 bytes 32 bit 6 - 7 digits %f

     double d = 3.1493939393948002; // 8 bytes  64 bit 15 - 16 digits %lf

     // bool e = true; // 1 byte (true or false ) %d

     char grade = 'C'; // single character (-128 to +127) %d or %c 

     unsigned char g = 255; // 1 byte (0 to +255) %d or %c

     short int h = 32767; // 2 bytes (-32,768 to 32,767) %d

     unsigned short int i = 65535; // 2 bytes (0 to +65,535) %d

     int j = 2147483647; // 4 bytes (-2147483648 to +2147483648) %d
     
     unsigned int k = 4294967295L; // 4 bytes (0 to +4294967295) %u

     long long int l = 9223372036854775807; // 8 bytes (-9 quintillion to +9 quintillion)

     unsigned long long int m = 1844674407370955161U; // 8 bytes (0 to +18 quintillion) %llu

     char name[] = "Bro"; // an array of characters



     printf("Hello %s\n", name); // Printing strings

     printf("you are %d years old\n", age); // printing an integer

     printf("Your grade %c\n", grade); // printing a character

     printf("Your gpa %f\n", gpa);

     // format specifier % = defines and formats a type of data  to be displayed.

     // %c = character
     // %s = string (array of character)
     // %f = float
     // %lf = double
     // %d = integer

     // %.1 = decimal precision
     // %1 = minimum field value
     // %- = left align

     float item1 = 5.75;
     float item2 = 10.00;
     float item3 = 100.99;

     printf("Item 1: $%-8.2f\n", item1);
     printf("Item 2: $%-8.2f\n", item2);
     printf("Item 3: $%-8.2f\n", item3);

     const float pi = 3.14159; // constant values cannot be altered by the program during its execution.

     printf("%f\n", pi);

     // arithmatic operators
     // + (addition)
     // - (subtraction)
     // * (multiplication)
     // / (division)
     // % (modulus)
     // ++ (increment)
     // -- decrement

     //int x = 5;
     //int y = 2;
//
     //int add = x + y;
     //int sub = x - y;
     //int mul = x * y;
     //float div = (float) x / (float) y; // data type conversions
     //int rem = x % y;

     //printf("%d\n", add);
     //printf("%d\n", sub);
     //printf("%d\n", mul);
     //printf("%f\n", div);
     //printf("%d\n", rem);
     
  //   x++;
  //   y--;

     //printf("%d\n", x);
     //printf("%d\n", y);
//
//   //  ++x;
//   //  --y;
//
     //printf("%d\n", x);
     //printf("%d\n", y);

//augmented assignment operator

//int x = 10;
//
//x = x + 2;
//x+=2;
//
//x = x - 3;
//x-=3;
//
//x = x * 4;
//x*=4;
//
//x = x / 5;
//x/=5;
//
//x = x % 2;
//x%=2;

     return 0;
}