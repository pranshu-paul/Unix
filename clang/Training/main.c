#include <stdio.h>
#include <stdlib.h>

typedef struct node
{
    struct node *prev;
    struct node *next;
    int data;
} node ;

struct node *head;

void insertion_beginning();
void insertion_last();
void insertion_specified();
void deletion_beginning();
void deletion_last();
void deletion_specified();
void display();
void search();

int main (void)
{
	int option = 0;

    while(1)
    {
		system("cls");

        printf("\n===================Main Menu===================\n");
        printf("\nChoose an option from the following list\n");
        printf("\n===============================================\n");
        printf("\n1. Insert at head\n");
		printf("2. Insert at last\n");
		printf("3. Insert at a random location\n");
		printf("4. Delete at head\n");
		printf("5. Delete at last\n");
		printf("6. Delete the node after the given value\n");
		printf("7. Search\n");
		printf("8. Show\n");
		printf("9. Exit\n");
        printf("\nEnter your choice: ");
        scanf("\n%d",&option);

        switch(option)
        {
            case 1:
                insertion_beginning();
            break;
            case 2:
                insertion_last();
            break;
            case 3:
                insertion_specified();
            break;
            case 4:
                deletion_beginning();
            break;
            case 5:
                deletion_last();
            break;
            case 6:
                deletion_specified();
            break;
            case 7:
                search();
            break;
            case 8:
                display();
            break;
            case 9:
            exit(0);
            default:
                printf("Please enter a valid choice.");
        }
    }

	return 0;
}

void insertion_beginning()
{
   node *temp = (node *)malloc(sizeof(node));

   int item = 0;

	if (temp == NULL)
	{
		printf("\nCould not allocate memory.");
	}
	else
	{
		printf("\nEnter a value: ");
		scanf("%d",&item);

		if(head == NULL)
		{
			temp->next = NULL;
			temp->prev = NULL;
			temp->data = item;
			head = temp;
		}
		else
		{
			temp->data = item;
			temp->prev = NULL;
			temp->next = head;
			head->prev = temp;
			head = temp;
		}

		printf("\nNode inserted\n");
	}
}

void insertion_last()
{
   node *ptr, *temp;
   int item = 0;

   ptr = (node *)malloc(sizeof( node));

   if (ptr == NULL)
   {
       printf("\nCould not allocate memory.");
   }
   else
   {
       printf("\nEnter a value: ");
       scanf("%d",&item);
        ptr->data=item;
       if(head == NULL)
       {
           ptr->next = NULL;
           ptr->prev = NULL;
           head = ptr;
       }
       else
       {
          temp = head;

          while(temp->next!=NULL)
          {
              temp = temp->next;
          }

          temp->next = ptr;
          ptr ->prev=temp;
          ptr->next = NULL;
       }
   }
     printf("\nNode inserted.\n");
}

void insertion_specified()
{
   node *ptr,*temp;
   int item, loc, i;
   ptr = (node *)malloc(sizeof(node));

   if (ptr == NULL)
   {
       printf("\nCould not allocate memory.");
   }
   else
   {
       temp = head;
       printf("Enter the location");
       scanf("%d",&loc);

       for(i = 0; i < loc; i++)
       {
           temp = temp->next;
           if (temp == NULL)
           {
               printf("\n There are less than %d elements", loc);
               return;
           }
       }

       printf("Enter value");
       scanf("%d",&item);

       ptr->data = item;
       ptr->next = temp->next;
       ptr -> prev = temp;
       temp->next = ptr;
       temp->next->prev = ptr;

       printf("\nnode inserted\n");
   }
}

void deletion_beginning()
{
    struct node *ptr;
    if(head == NULL)
    {
        printf("\n UNDERFLOW");
    }
    else if(head->next == NULL)
    {
        head = NULL;
        free(head);
        printf("\nnode deleted\n");
    }
    else
    {
        ptr = head;
        head = head -> next;
        head -> prev = NULL;
        free(ptr);
        printf("\nnode deleted\n");
    }

}

void deletion_last()
{
    struct node *ptr;
    if(head == NULL)
    {
        printf("\n UNDERFLOW");
    }
    else if(head->next == NULL)
    {
        head = NULL;
        free(head);
        printf("\nnode deleted\n");
    }
    else
    {
        ptr = head;
        if (ptr->next != NULL)
        {
            ptr = ptr->next;
        }
        ptr->prev->next = NULL;

        free(ptr);

        printf("\nNode deleted\n");
    }
}

void deletion_specified()
{
    node *ptr, *temp;
    int val;

    printf("\n Enter the data after which the node is to be deleted : ");
    scanf("%d", &val);
    ptr = head;

    while(ptr -> data != val)
    ptr = ptr -> next;
    if(ptr -> next == NULL)
    {
        printf("\nCan't delete\n");
    }
    else if (ptr->next->next == NULL)
    {
        ptr ->next = NULL;
    }
    else
    {
        temp = ptr -> next;
        ptr->next = temp->next;
        temp->next->prev = ptr;

        free(temp);
        printf("\nNode deleted\n");
    }
}

void display()
{
    struct node *temp;
	int i = 1;

    printf("\nThe values in the list.\n\n");

    temp = head;
    while(temp != NULL){
        printf("Node %d: %d\n",i , temp->data);
        temp = temp->next;

		i++;
    }

	printf("\nPress any key to continue.\n");
	getchar();
	getchar();
}

void search()
{
    node *temp;
    int location;
    temp = head;

    if (temp == NULL) {
        printf("\nThe list is empty\n");
    } else {
        printf("\nEnter the location where you want to search: ");
        scanf("%d", &location);

        for (int i = 0; i <= location; i++) {
            if (temp == NULL) {
                printf("\nLocation not found. List is shorter than expected.\n");
                return;
            }
            temp = temp->next;
        }

        if (temp != NULL) {
            printf("%d\n", temp->data);
        }
    }

    printf("\nPress any key to continue.\n");
    getchar();
    getchar();
}

