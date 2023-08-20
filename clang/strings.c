#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main(void)
{

     char myData[6];
     myData[0]='h';
     myData[1]='e';
     myData[2]='l';
     myData[3]='l';
     myData[4]='o';
     myData[5]='\0';

     for (int i = 0; i < 6; i++)
     {
          printf("myData[%d] %c\n", i, myData[i]);
     }
     
     char s1[] = "This is my string.";

     for (int i = 0; i < 19; i++)
     {
          if (s1[i] == '\0')
          {
               printf(" \\0", i);
          }
          else
          {
               printf("%c", s1[i]);
          }
          
          
          
     }
     

}
