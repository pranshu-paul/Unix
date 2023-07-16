#include <stdio.h>
#include <stdlib.h>

#define ADDITION 1
#define SUBTRACTION 2
#define MULTIPLICATION 3
#define DIVISION 4
#define QUIT 5

int mainMenu(void);
void opMenu(float *num1, float *num2);

int main(void) {
	float num1 = 0, num2 = 0;

	while (1)
	{
		system("cls");
		
		int option = mainMenu();

		if (option == QUIT)
		{
			exit(0);
		}

		switch (option)
		{
		case ADDITION:
			opMenu(&num1, &num2);
			printf("\nThe sum of %.2f and %.2f is %.2f", num1, num2, num1+num2);
			break;
		case SUBTRACTION:
			opMenu(&num1, &num2);
			printf("\nThe difference between %.2f and %.2f is %.2f", num1, num2, num1-num2);
			break;
		case MULTIPLICATION:
			opMenu(&num1, &num2);
			printf("\nThe product of %.2f and %.2f is %.2f", num1, num2, num1*num2);
			break;
		case DIVISION:
			opMenu(&num1, &num2);
			if (num2 !=0)
			{
				printf("\nThe quotient of %.2f and %.2f is %.2f", num1, num2, num1/num2);
			} else
			{
				printf("\nCannot divide by zero.");
			}
			break;
		default:
			printf("\nInvalid option number.");
			getchar();
			break;
		}
		
		printf("\n\nPress any key to continue...");
		getchar();
		getchar();
	}
	
	return 0;
}

int mainMenu(void) {
	printf("Choose an option.\n\n");
		printf("1) Addition\n");
		printf("2) Subtraction\n");
		printf("3) Multiplication\n");
		printf("4) Division\n");
		printf("5) Quit\n");

		int option = 0;
		printf("\nEnter the option number: ");
		scanf("%d", &option);
	return option;
}

void opMenu(float *num1, float *num2) {
	printf("\nEnter the first number: ");
	scanf("%f", num1);
	printf("Enter the second number: ");
	scanf("%f", num2);
}