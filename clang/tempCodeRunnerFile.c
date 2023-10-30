#include <stdio.h>
#include <stdlib.h>

typedef struct {
     int x;
     int y;
     struct point *next;
} point;

int main(int argc, char const *argv[])
{

     point *head = (point *)malloc(sizeof(point));

     //head->x = 4;
     //head->y = 6;
     head->next = NULL;


     point *p1 = head;

     p1 = p1->next;

     return 0;
}
