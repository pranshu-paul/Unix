#include <stdio.h>
#include <stdlib.h>

double add(double x, double y){
    return x + y;
}

int subtract(int x, int y){
    return x - y;
}

int multiply(int x, int y){
    return x * y;
}

int divide(int x, int y){
    return x / y;
}

int (*selection())(int, int){
    int option = 0;
    printf("Select An Operation\n");
    printf("1) Subtract\n");
    printf("2) Multiply\n");
    printf("3) Divide\n");
    printf("Enter: ");
    scanf("%d", &option);

    if (option = 1){
        return subtract;
    }
    else if (option = 2){
        return multiply;
    }
    else if (option = 3){
        return divide;
    }
    else
        return NULL;
}

int main(int argc, char const *argv[])
{

    int (*operation)(int, int) = selection();

    printf("answer: %d\n", operation(20,5));


    return 0;
}
