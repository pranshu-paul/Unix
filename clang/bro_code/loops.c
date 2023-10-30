#include <stdio.h>
#include <string.h>

int main(int argc, char const *argv[])
{
     // for (int i = 0; i < 100; i+=4)
     // {
     //      printf("Result %d\n", i);
     // }


     // for (int i = 100; i > 0; i-=4)
     // {
     //      printf("Result %d\n", i);
     // }
     
     // for (int i = 100; i > 0; i--)
     // {
     //      printf("Result %d\n", i);
     // }
     
     // char name[25];

     // printf("\nWhat's you name?: ");
     // fgets(name, 25, stdin);
     // name[strlen(name) - 1] = '\0';

     // while (strlen(name) == 0)
     // {
     //      printf("\nYou did not enter your name");
     //      printf("\nWhat's your name?: ");
     //      fgets(name, 25, stdin);
     //      name[strlen(name) - 1] = '\0';
     // }
     

     // printf("Hello %s", name);


// do while loop
     int number = 0;
     int sum = 0;

     
     do{
          printf("\nEnter a # above 0: ");
          scanf("%d", &number);
          if (number > 0)
          {
               sum += number;
          }
          
     }while (number > 0);
     
     printf("sum: %d", sum);



     return 0;
}
