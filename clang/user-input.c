#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int sum_of_numbers_from_input(void) {
    char input[100];
    int sum = 0;

    printf("Enter a line of numbers separated by spaces:");
    fgets(input, sizeof(input), stdin);

    char *token = strtok(input, " ");
    while (token != NULL) {
        sum += atoi(token);
        token = strtok(NULL, " ");
    }

    return sum;
}

int main(void) {
    int sum = sum_of_numbers_from_input();
    printf("The sum of the numbers is %d\n", sum);

    return 0;
}