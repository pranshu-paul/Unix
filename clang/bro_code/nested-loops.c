#include <stdio.h>

int main(int argc, char const *argv[])
{
     // int rows;
     // int columns;
     // char symbol;

     // printf("\nEnter # of rows: ");
     // scanf("%d", &rows);
     
     // printf("\nEnter # of columns: ");
     // scanf("%d", &columns);

     // scanf("%c");
     //    printf("\nEnter a symbol to use: ");
     // scanf("%c", &symbol);

     // for (int i = 1; i <= rows; i++)
     // {
     //      for (int j = 1; j <= columns; j++)
     //      {
     //           printf("%c", symbol);
     //      }
     //      printf("\n");
     // }
     
     // continue = skips rest of the code and forces the next iteration of the loop.
     // break = exits a loop/switch


     for (int i = 0; i <=20 ; i++)
     {
          if (i == 13 || i == 20)
          {
              // continue; // skipped to print 13 and continued

              break;
          }
          
          
          printf("%d\n", i);
     }
     



     return 0;
}
