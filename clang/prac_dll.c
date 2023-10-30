#include <stdio.h>
#include <stdlib.h>

struct node
{
     struct node *prev;
     struct node *next;
     int data;
};

struct node *head;

void insertAtBegining();
void insertAtLast();
void insertAtSpecific();
void deleteAtBegining();
void deleteAtLast();
void deleteAtSpecific();
void display();
void search();

int main(int argc, char const *argv[])
{
     int choice = 0;

     while (choice != 9){
          printf("\n---------Main Menu---------\n");
          printf("\nChoose an option from the following list.\n");
          printf("\n1. Insert in begining\n2. Insert at last\n3. Insert at a random location.\n4. Delete from Begining\n5. Delete fromm last\n6. Delete the node after the given data\n7. Search\n8. Show\n9. Exit\n");
          printf("\nEnter you choice: ");
          scanf("\n%d", &choice);

          switch (choice)
          {
          case 1:
               insertAtBegining();
               break;
          case 2:
               insertAtLast();
               break;
          case 3:
               insertAtSpecific();
               break;
          case 4:
               deleteAtBegining();
               break;
          case 5:
               deleteAtLast();
               break;
          case 6:
               deleteAtSpecific();
               break;
          case 7:
               search();
               break;
          case 8:
               display();
               break;
          case 9:
               exit(0);
               break;
          default:
               printf("Please enter a valid choice!\n");
               break;
          }
     }
     return 0;
}

void insertAtBegining(){
     struct node *pValue;
     int item;

     pValue = (struct node *)malloc(sizeof(struct node));
     if(pValue == NULL){
          printf("\nOVERFLOW");
     } else {
          printf("Enter the item value: ");
          scanf("%d", &item);

     if(head == NULL){
          pValue->next = NULL;
          pValue->prev = NULL;
          pValue->data = item;
          head = pValue;
     } else {
          pValue->data = item;
          pValue->prev = NULL;
          pValue->next = head;
          head = pValue;
     }     
     printf("\nInserted the node successfully\n");
     }
}

void insertAtLast(){
     struct node *pValue, *temp;
     int item;
     pValue = (struct node *)malloc(sizeof(struct node));
     if(pValue == NULL){
          printf("\nOVERFLOW");
     } else {
          printf("\nEnter the value: ");
          scanf("%d", &item);
          pValue->data = item;

          if(head == NULL){
               pValue->next = NULL;
               pValue->prev = NULL;
               head = pValue;
          } else {
               temp = head;

               while(temp->next != NULL){
                    temp = temp->next;
               }

               temp->next = pValue;
               pValue->prev = temp;
               pValue->next = NULL;
          }
     }
     printf("\nInserted the node.\n");
}

void insertAtSpecific(){  
   struct node *pValue, *temp;
   int item, loc, i;  
   pValue = (struct node *)malloc(sizeof(struct node));  
   if(pValue == NULL){  
       printf("\nOVERFLOW");  
   } else {  
       temp=head;  

       printf("\nEnter the location: ");  
       scanf("%d",&loc);  

       for(i=0; i<loc; i++){  
           temp = temp->next;  
           if(temp == NULL){  
               printf("\nTotal elements are less than %d", loc);  
               return;  
           }  
       }

       printf("\nEnter the value: ");  
       scanf("%d",&item);

       pValue->data = item;  
       pValue->next = temp->next;  
       pValue->prev = temp;  
       temp->next = pValue;  
       temp->next->prev = pValue;  
       printf("\nInserted the node successfully\n");  
   }  
}

void deleteAtBegining(){  
    struct node *pValue;  
    if(head == NULL){  
        printf("\nUNDERFLOW");  
    } else {
     if(head->next == NULL){  
        head = NULL;   
        free(head);  
        printf("\nDeleted the node sucessfully\n");
     } else {  
        pValue = head;  
        head = head->next;  
        head->prev = NULL;  
        free(pValue);  
        printf("\nDeleted the node successfully\n");  
    }  
     }
}

void deleteAtLast(){  
    struct node *pValue;

    if(head == NULL){  
        printf("\nUNDERFLOW");  
    } else {
     if(head->next == NULL){  
        head = NULL;   
        free(head);   
        printf("\nDeleted the node successfully\n");  
     } else {  
        pValue = head;   
        if(pValue->next != NULL){  
            pValue = pValue->next;   
        }  
        pValue->prev->next = NULL;   
        free(pValue);  
        printf("\nDeleted the node successfully\n");  
    }  
}
}

void deleteAtSpecific(){  
    struct node *pValue, *temp;  
    int val;  
    printf("\nEnter the data after which the node is to be deleted: ");  
    scanf("%d", &val);  
    pValue = head;  
    while(pValue->data != val)  
    pValue = pValue->next;  
    if(pValue->next == NULL){  
        printf("\nCould not delete the node.\n");  
    } else {
     if(pValue->next->next == NULL){  
        pValue->next = NULL;  
     } else {   
        temp = pValue->next;  
        pValue->next = temp->next;  
        temp->next->prev = pValue;  
        free(temp);  
        printf("\nDeleted the node successfully\n");  
    }     
}
}

void display(){  
    struct node *pValue;  
    printf("\nPrinting the values...\n");  
    pValue = head;  
    while(pValue != NULL){  
        printf("%d\n",pValue->data);  
        pValue=pValue->next;  
    }
}

void search(){  
    struct node *pValue;  
    int item, i = 0, flag;  
    pValue = head;   
    if(pValue == NULL){  
        printf("\nThe List is Empty\n");  
    } else {   
        printf("\nEnter the item which you want to search: \n");   
        scanf("%d",&item);  
        while (pValue != NULL){  
            if(pValue->data == item){  
                printf("\nItem is found at the location%d", i+1);  
                flag=0;  
                break;  
            } else {  
                flag=1;  
            }  
            i++;  
            pValue = pValue->next;  
        }

        if(flag==1){  
            printf("\nCould not find the item.\n");  
        }  
    }    
}