#include <stdio.h>

// Define a struct with a pointer to a function
struct Calculator {
    int (*add)(int, int);
    int (*subtract)(int, int);
};

// Function to add two numbers
int addFunction(int a, int b) {
    return a + b;
}

// Function to subtract two numbers
int subtractFunction(int a, int b) {
    return a - b;
}

int main() {
    // Create an instance of the Calculator struct
    struct Calculator calculator;

    // Assign the add and subtract functions to the struct's function pointers
    calculator.add = addFunction;
    calculator.subtract = subtractFunction;

    // Use the functions through the struct
    int result_add = calculator.add(5, 3);
    int result_subtract = calculator.subtract(5, 3);

    // Display the results
    printf("Addition: %d\n", result_add);
    printf("Subtraction: %d\n", result_subtract);

    return 0;
}
