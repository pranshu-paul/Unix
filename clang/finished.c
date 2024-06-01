#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Global variables (should be in a database!) -------- */

struct flight {
    char flight_number[7];                                                                          // Array to store the flight number (6 characters + null terminator)
    char departure_time[5];                                                                         // Array to store the departure time (4 characters + null terminator)

    // char destination[21];                                                                        // Commented out: Array to store the destination (20 characters + null terminator)

    // Create a not modifiable string literal
    char *destination;                                                                              // Pointer to a string literal or dynamically allocated string for the destination

    // char passengers[5][41];                                                                      // Commented out: Array to store names of 5 passengers, each up to 40 characters + null terminator
    // char *passengers[5];                                                                         // Commented out: Array of 5 pointers to passenger names

    char **passengers;                                                                              // Pointer to an array of pointers to passenger names (dynamic allocation for flexibility)
    int  num_passengers;                                                                            // Integer to store the current number of passengers
    int  current_max_passenger;                                                                     // Integer to store the maximum number of passengers allowed
};


// Create a pointer to the struct flight
struct flight* flights;

#define BLOCK_INCREMENT_SIZE 5                                                                      // Define a macro for the block increment size, used to increase the size of the flights array
int current_max_flights = 0;                                                                        // Initialize an integer to store the current maximum number of flights that can be handled
int num_flight = 0;                                                                                 // Initialize an integer to store the current number of flights

/* a utility function to read a line including whitespaces */
/* but excludes newline characters */

void scanline(char* str, int max_size) {
    int i = 0;                                                                                      // Initialize an index to keep track of the position in the string
    int ch;                                                                                         // Variable to store the character read from input

    // Use fflush to clear the stdin buffer
    fflush(stdin);

    do {
        ch = getc(stdin);  // Read a character from the standard input

        // If the character is not a newline or EOF and the maximum size is not reached
        if (i < max_size && ch != '\n' && ch != EOF) {
            str[i] = ch;  // Store the character in the string
            i++;          // Increment the index
        }
    
    // Continue reading characters until a newline or EOF is encountered
    } while (ch != '\n' && ch != EOF);

    str[i] = 0;  // Null-terminate the string
}

char* scanlinedyn() {

    #define INITIAL_BUFFER_SIZE 20  // Define a macro for the initial size of the buffer
    #define BUFFER_INCREMENT 10     // Define a macro for the increment size to increase the buffer when needed
    
    int current_buffer_size = 0;    // Initialize an integer to store the current size of the buffer
    char* str;                      // Declare a pointer to a character for the dynamic string buffer
    int i = 0;                      // Initialize an integer to use as an index for the buffer
    int ch;                         // Declare an integer to store characters read from input


    /* Allocate initial memory */
    str = malloc(INITIAL_BUFFER_SIZE + 1);  // Allocate memory for the buffer with the initial size plus one for the null terminator
    if (!str) {                             // Check if memory allocation failed
        printf("\nmalloc in scanlinedyn failed... exiting\n");  // Print an error message if allocation failed
        exit(1);                            // Exit the program with a status of 1 to indicate an error
    }  

    current_buffer_size = INITIAL_BUFFER_SIZE;  // Set the current buffer size to the initial buffer size defined by the macro
    printf("current_buffer_size = %i\n", current_buffer_size);  // Print the current buffer size

    fflush(stdin);  // Clear the input buffer (note: using fflush on stdin is non-standard and not recommended)


    do {
        ch = getc(stdin);  // Read a character from the standard input

        if (ch != '\n' && ch != EOF) {  // If the character is not a newline or EOF
            if (i == current_buffer_size) {  // If the index has reached the current buffer size

                printf("i = %i, current_buffer_size = %i\n", i, current_buffer_size);  // Print the index and current buffer size

                /* Reallocate memory */
                str = realloc(str, current_buffer_size + BUFFER_INCREMENT + 1);  // Increase the buffer size by the increment plus one for the null terminator
                if (!str) {  // Check if memory reallocation failed
                    printf("\nrealloc in scanlinedyn failed... exiting\n");  // Print an error message if reallocation failed
                    exit(1);  // Exit the program with a status of 1 to indicate an error
                }

                current_buffer_size += BUFFER_INCREMENT;  // Update the current buffer size to the new size
                printf("new current_buffer_size = %i\n", current_buffer_size);  // Print the new current buffer size
            }

            str[i] = ch;  // Store the character in the buffer
            i++;  // Increment the index
        }

    } while (ch != '\n' && ch != EOF);  // Continue reading characters until a newline or EOF is encountered


    str[i] = 0;

    return str;
}

/* allocated the memory for the initial block of flights */
void initializeFlightBlock() {

    flights = calloc(sizeof(struct flight), BLOCK_INCREMENT_SIZE);

    /* error checking */
    if (!flights) {
        printf("\ncalloc failed in initializeFlightBlock. Exiting...\n");
        exit(1);       
    }
    else {
        current_max_flights = BLOCK_INCREMENT_SIZE;
        printf("\nFlight block initialized to %i", current_max_flights);
    }
}

/* submenu to add a passenger-------------------------- */

void add_passenger(int flight_index) {
    
    #define BLOCK_INCREMENT_SIZE 5

    /* char new_passenger_name[41]; */
    int next_passenger_index;

    /* do a range check to be safe */

    if (flight_index < 0 || flight_index >= num_flight) {
        return;
    }

    puts("\n***** SUBMENU: ADD PASSENGER *****");

    printf("ENTER PASSENGER'S NAME: ");
    /* scanline(new_passenger_name, 40); */

    next_passenger_index = flights[flight_index].num_passengers;

    /* do we need to allocate a new block of memory for more passengers? */
    if (next_passenger_index == flights[flight_index].current_max_passenger) {
        flights[flight_index].passengers = realloc(flights[flight_index].passengers,
        sizeof(char *) * (flights[flight_index].current_max_passenger + BLOCK_INCREMENT_SIZE));
    
        /* check to see if it succeeded */
        if (flights[flight_index].passengers) {
            flights[flight_index].current_max_passenger += BLOCK_INCREMENT_SIZE;
            printf("\nPassenger block expanded. New size = %i\n", flights[flight_index].current_max_passenger);
        }
        else {
            printf("\nrealloc in addPassenger failed. Exiting...\n");
            exit(1);
        }
    }

    /* strncpy(flights[flight_index].passengers[next_passenger_index], new_passenger_name, 40); */
    flights[flight_index].passengers[next_passenger_index] = scanlinedyn();
    flights[flight_index].num_passengers ++;
    fflush(stdin);

    return;

}

/* submenu to add a flight ---------------------------- */

void add_flight() {

    char flight_number[7];
    char departure_time[5];
    /* char destination[21]; */
    char* destination;

    puts("\n********** SUBMENU: ADD FLIGHT **********");

    printf("ENTER FLIGHT NUMBER: (XXnnnn): ");
    scanf("%s", flight_number);
    
    printf("ENTER DEPARTURE TIME (hhmm): ");
    scanf("%s", departure_time);
    
    printf("ENTER DESTINATION: ");
    /* scanline(destination, 20); */
    destination = scanlinedyn();

    /* are flight blocks full, do we need more */
    if (num_flight >= current_max_flights) {
        flights = realloc(flights, sizeof(struct flight) * (current_max_flights + BLOCK_INCREMENT_SIZE));

        /* error checking */
        if (!flights) {
            printf("\nrealloc failed in addFlight. Exiting...\n");
            exit(1);
        }
        else {
            current_max_flights += BLOCK_INCREMENT_SIZE;
            printf("\nFlight block expanded. New size = %i\n\n", current_max_flights);
        }
    }

    strncpy(flights[num_flight].flight_number, flight_number, 6);
    strncpy(flights[num_flight].departure_time, departure_time, 4);
    /* strncpy(flights[num_flight].destination, destination, 20); */
    flights[num_flight].destination = destination;
    flights[num_flight].num_passengers = 0;

    num_flight++;

    printf("%s to %s added!\n", flight_number, destination);
    return;
}

/* submenu to show details of a flight------------------ */

void flight_detail(int flight_index) {

    char input[2];
    int i;

    /* do a range check to be safe */

    if (flight_index < 0 || flight_index >= num_flight) {
        return;
    }

    /* loop until X is entered */

    while(strcmp(input, "X") != 0) {

        printf("\n********** SUBMENU: FLIGHT %s **********\n", flights[flight_index].flight_number);
        printf("DEPARTURE TIME: %s\n", flights[flight_index].departure_time);
        printf("DESTINATION: %s\n\n", flights[flight_index].destination);

        puts("***** PASSENGERS *****");

        /* show all passengers or a message */

        if (flights[flight_index].num_passengers == 0) {
            printf("\n-- No passengers yet, enter A to add --\n\n");
        }
        else {
            for (i = 0; i < flights[flight_index].num_passengers; i++) {
                printf("%i. %s\n",
                i + 1,
                flights[flight_index].passengers[i]);
            }
        }

        puts("\nA = ADD PASSENGER");
        puts("X = GO BACK");
        printf("ENTER OPTION: ");

        scanf("%s", input);
        
        if (strcmp(input, "A") == 0) {

            /* is there room for another passenger? */

            /* if (flights[flight_index].num_passengers >= 5) {
                printf("*** THIS FLIGHT IS FULL ***");
            }
            else {
            */
                add_passenger(flight_index);
            /* } */

            continue;
        }

        if (strcmp(input, "X") != 0) {
            printf("\n** %s IS NOT A INVALID OPTION **\n", input);
        }
    }

}

/* housekeeping to release allocated memories */

void clean_up() {

    int i, j;

    /* iterate through the flights */
    for (i = 0; i < num_flight; i++) {

        /* iterate through the passengers in each flight */
        for (j = 0; j < flights[i].num_passengers; j++) {
            /* release the memory for each passenger's name */
            free(flights[i].passengers[j]);
            printf("flight[%i].passengers[%i] released from memory.\n", i, j);
        }

        /* release the memory for the destination string */
        free(flights[i].destination);
        printf("flight[%i].destination released from memory.\n", i);
    }

    /* now release the memory for the all the flights */
    free(flights);
    printf("All flights released from memory.\n");

}

/* main menu to show the flight schedule of the day ---- */

void flight_schedule(void) {

    char input[2];
    int i;
    char item_number;

    /* loop until X is entered */

    while(strcmp(input, "X") != 0) {
        puts("\n********** TODAY'S FLIGHT SCHEDULE **********");

        /* show all existing flights or a message */

        if (num_flight == 0) {
            printf("\n-- No flights scheduled yet, enter A to add --\n\n");
        }
        else {
            for (i = 0; i < num_flight; i++) {
                printf("%i. %s %s %s\n",
                i + 1,
                flights[i].flight_number,
                flights[i].departure_time,
                flights[i].destination);
            }

            puts("\nITEM NUMBER = FLIGHT DETAILS");
        }

        puts("A = ADD FLIGHT");
        puts("X = EXIT");
        printf("ENTER OPTION: ");
        scanf("%s", input);

        /* See if "A" is entered */

        if (strcmp(input, "A") == 0) {

            /* is there still room for more flights? */
            /* if (num_flight >= 5) {
                printf("*** MAXIMUM DAILY FLIGHTS REACHED ***");
            }
            else { */
                add_flight();
            /* } */

            continue;
        }

        /* See if a valid item number is entered */
        item_number = atoi(input);

        if (item_number > 0 && item_number <= num_flight) {
            flight_detail(item_number - 1);
            continue;
        }

        if (strcmp(input, "X") != 0) {
            printf("\n** %s IS NOT A INVALID OPTION **\n", input);
        }

    }

    return;

}

/* bootstrap of the app */

int main(void) {

    /*
    char* str = scanlinedyn();
    printf("You entered >>>%s<<<", str);
    free(str);
    */

    initializeFlightBlock();
    flight_schedule();
    clean_up();
    printf("\nGoodbye!\n\n");
    return 0;

}