#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main(void)
{

//     char myData[6];
//     myData[0]='h';
//     myData[1]='e';
//     myData[2]='l';
//     myData[3]='l';
//     myData[4]='o';
//     myData[5]='\0';
//
//     for (int i = 0; i < 6; i++)
//     {
//          printf("myData[%d] %c\n", i, myData[i]);
//     }
//     
//     char s1[] = "This is my string.";
//
//     for (int i = 0; i < 19; i++)
//     {
//          if (s1[i] == '\0')
//          {
//               printf(" \\0\n", i);
//          }
//          else
//          {
//               printf("%c", s1[i]);
//          }
//          
//          
//          
//     }
     
char s2[20]; 

    printf("Enter: "); 
    scanf("%19s", s2); 

    for (int i = 0; i < 20; i++) {       
        printf("s2[%d]: %c\n", i, s2[i]);    
    }	

int i = 0;

while (s2[i] != '\0')
{
     if (s2[i] == '0')
          printf("found 0\n");
     i++;
}

printf("s2: %s", s2);
     return 0;
}
