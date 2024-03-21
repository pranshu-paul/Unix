#include <stdio.h>

int print(int i) {
    printf("print function %d\n", i);
    return i;
}

int main(void) {
    int a = 20;

    if (a != 20 && print(a)) {
       printf("I won't be printed!\n");
    }

    if (a == 20 && print(a)) {
        printf("I will be printed!\n");
    }

    return 0;
}