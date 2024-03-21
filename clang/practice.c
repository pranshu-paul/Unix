#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
 typedef struct node 
{
    int value;
     struct node *next;
 } Node;
 void print_list (Node * head);
Node * insert_at_head (Node * head, int value);
Node * insert_at_tail (Node * head, int value);
Node * delete_at_head (Node * head);
Node * delete_at_tail (Node * head);
int length (Node * head);
int recursive_length (Node * node);
bool is_member (Node * node, int value);
int count_matches (Node * node, int value);
void replace_matches (Node * node, int find_value, int replace_value);
 int
main (void)  { Node * list_head = NULL;
     list_head = insert_at_head (list_head, 7);
    list_head = insert_at_head (list_head, 5);
    list_head = insert_at_head (list_head, 3);
    list_head = insert_at_head (list_head, 5);
    list_head = insert_at_head (list_head, 5);
    list_head = insert_at_head (list_head, 5);
     printf ("List before replacement:\n");
    print_list (list_head);
     replace_matches (list_head, 5, 9);
    replace_matches (list_head, 7, 8);
    replace_matches (list_head, 8, 128);
     printf ("List after replacement:\n");
    print_list (list_head);
    return 0;
}

 void
    replace_matches (Node * node, int find_value, int replace_value) 
    { if (node == NULL)
          
          {if (node->value == find_value) 
           node->value = replace_value;
            replace_matches (node->next, find_value, replace_value); }
           }

            int count_matches (Node * node, int find_value) 
           { if (node == NULL) return 0; 
           else
           if (node->value == find_value) 
           return 1 + count_matches (node->next, find_value); 
           else
           return count_matches (node->next, find_value); }

            bool is_member (Node * node, int find_value) 
           { if (node == NULL) return false; 
           else
           if (node->value == find_value) return true; 
           else
           return is_member (node->next, find_value); }

            int recursive_length (Node * node) 
           { if (node == NULL) return 0; 
           else
           return 1 + recursive_length (node->next); }
            int length (Node * head) 
           { Node * current; current = head; int length = 0;
           while (current != NULL)  { length++; current = current->next;
           }
           return length; }

            Node * delete_at_tail (Node * head) 
           { if (head == NULL) return NULL; 
           else
           if (head->next == NULL)  { free (head); return NULL; }
           
           else
           
           {
           Node * current = head; Node * prev = NULL;
            while (current->next != NULL)  { prev = current;
           current = current->next; }
            prev->next = NULL; free (current); return head; }
           }

            Node * delete_at_head (Node * head) 
           { if (head == NULL) return NULL; 
           else
           
           {
           Node * to_return = head->next; free (head); return to_return; }
           }

            Node * insert_at_tail (Node * head, int value) 
           { Node * new_node = calloc (1, sizeof (Node));
           new_node->value = value; if (head == NULL) return new_node; 
           else
           
           {
           Node * current = head;
           while (current->next != NULL) current = current->next;
           current->next = new_node; return head; }
           }

            Node * insert_at_head (Node * head, int value) 
           { Node * new_node = calloc (1, sizeof (Node));
           new_node->value = value; if (head == NULL) return new_node; 
           else
           
           {
           new_node->next = head; return new_node; }
           }
            void print_list (Node * head) 
           { Node * current; current = head; int i = 0;
           while (current != NULL)  { printf ("Node %d: %d\n", i,
                                                 current->value); i++;
           current = current->next; }
           }
