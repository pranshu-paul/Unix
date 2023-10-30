#include <stdio.h>

void birthday(char x[], int y);
int square(double x);

int main(int argc, char const *argv[])
{
     char name[] = "Bro";
     int age = 21;

     birthday(name, age);

     double x = square(9);
     printf("\n%.2lf", x);

     return 0;
}

void birthday(char x[], int y) {
     printf("\nHappy birthday dear %s!", x);
     printf("\nYou are %d years old", y);
}

int square(double x) {
     return x * x;;
}