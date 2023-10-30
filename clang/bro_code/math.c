#include <stdio.h>
#include <math.h>

int main() {

//     double a = sqrt(9);
//     double b = pow(2, 4);
//     double c = fabs(-100);
//     double d = log(3);
//     double e = sin(45);
//     double f = cos(45);
//     double g = tan(45);
//     int h = round(3.14);
//     int i = ceil(3.14);
//     int j = floor(3.99);
//     
//    printf("%lf\n", a);
//    printf("%lf\n", b);
//    printf("%lf\n", c);
//    printf("%lf\n", d);
//    printf("%lf\n", e);
//    printf("%lf\n", f);
//    printf("%lf\n", g);
//    printf("%d\n", h);
//    printf("%d\n", i);
//    printf("%d\n", j);

 //    double radius;
 //    double circumference;
 //    double area;
//
 //    printf("\nEnter radius of a circle: ");
 //    scanf("%lf", &radius);
//
 //    circumference = 2 * PI * radius;
 //    area = PI * radius * radius;
//
 //    printf("circumference: %lf\n", circumference);
 //    printf("area: %l\nf", area);
//
     const double PI = 3.14159;

     double a;
     double b;
     double c;

     printf("\nEnter side A :");
     scanf("%lf", &a);

     printf("\nEnter side B :");
     scanf("%lf", &b);

     printf("\nEnter side C :");
     scanf("%lf", &c);

     c = sqrt(a*a + b*b);

     printf("Side c: %lf", c);

     return 0;
}