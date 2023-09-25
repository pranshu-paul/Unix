#include <stdio.h>
#include <stdlib.h>
#include <libpq-fe.h>

/* 
 * Connect to an existing database.
 * Insert a new record for Betty.
 * Select full contents of the table and print all fields.
 */

static void
exit_nicely(PGconn *conn, PGresult   *res)
{
    PQclear(res);
    PQfinish(conn);
    exit(1);
}

int
main(int argc, char **argv)
{
    const char *conninfo = "dbname=bedrock sslmode=disable";
    PGconn     *conn;
    PGresult   *res;
    int         nFields;
    int         i,
                j;

    // Make a connection to the database
    conn = PQconnectdb(conninfo);

    // Check to see that the backend connection was successfully made
    if (PQstatus(conn) != CONNECTION_OK)
    {
        fprintf(stderr, "Connection to database failed: %s", PQerrorMessage(conn));
        PQfinish(conn);
        exit(1);
    }

    res = PQexec(conn, "INSERT INTO employee (Employee_Name,Dept,JobTitle) VALUES ('Betty Rubble','IT','Neighbor')");
    if (PQresultStatus(res) != PGRES_COMMAND_OK)
    {
        fprintf(stderr, "INSERT failed: %s", PQerrorMessage(conn));
        exit_nicely(conn,res);
    }
    PQclear(res);

    // Use cursor inside a transaction block

    // Start a transaction block
    res = PQexec(conn, "BEGIN");
    if (PQresultStatus(res) != PGRES_COMMAND_OK)
    {
        fprintf(stderr, "BEGIN command failed: %s", PQerrorMessage(conn));
        exit_nicely(conn,res);
    }
    PQclear(res);  // Clear memory

    res = PQexec(conn, "DECLARE mydata CURSOR FOR select * from employee");
    if (PQresultStatus(res) != PGRES_COMMAND_OK)
    {
        fprintf(stderr, "DECLARE CURSOR failed: %s", PQerrorMessage(conn));
        exit_nicely(conn,res);
    }
    PQclear(res);

    res = PQexec(conn, "FETCH ALL in mydata");
    if (PQresultStatus(res) != PGRES_TUPLES_OK)
    {
        fprintf(stderr, "FETCH ALL failed: %s", PQerrorMessage(conn));
        exit_nicely(conn,res);
    }

    // first, print out the table collumn attribute names
    nFields = PQnfields(res);
    for (i = 0; i < nFields; i++)
        printf("%-15s", PQfname(res, i));
    printf("\n\n");

    // next, print out the rows of data
    for (i = 0; i < PQntuples(res); i++)
    {
        for (j = 0; j < nFields; j++)
            printf("%-15s", PQgetvalue(res, i, j));
        printf("\n");
    }

    PQclear(res);

    // close the portal ... we don't bother to check for errors ...
    res = PQexec(conn, "CLOSE mydata");
    PQclear(res);

    // End the transaction 
    res = PQexec(conn, "END");
    PQclear(res);

    // close the connection to the database and cleanup 
    PQfinish(conn);

    return 0;
}



//////////////////////////////////
#include <stdio.h>
#include <stdlib.h>
#include <libpq-fe.h>
#include <curl/curl.h>

// Define a struct to represent a stack node
struct StackNode {
    char* data;
    struct StackNode* next;
};

// Define a struct for HTTP response data
struct HttpResponse {
    char* data;
    size_t size;
};

// Function to initialize libcurl
CURL* initializeCurl() {
    CURL* curl = curl_easy_init();
    if (!curl) {
        fprintf(stderr, "libcurl initialization failed.\n");
        exit(EXIT_FAILURE);
    }
    return curl;
}

// Function to cleanup libcurl
void cleanupCurl(CURL* curl) {
    curl_easy_cleanup(curl);
}

// Function to initialize a PostgreSQL connection
PGconn* initializePostgres(const char* conninfo) {
    PGconn* conn = PQconnectdb(conninfo);
    if (PQstatus(conn) != CONNECTION_OK) {
        fprintf(stderr, "Connection to database failed: %s\n", PQerrorMessage(conn));
        PQfinish(conn);
        exit(EXIT_FAILURE);
    }
    return conn;
}

// Function to cleanup PostgreSQL connection
void cleanupPostgres(PGconn* conn) {
    PQfinish(conn);
}

// Function to fetch data using a cursor
PGresult* fetchData(PGconn* conn, const char* cursorName, const char* query) {
    PGresult* res = PQexec(conn, query);
    if (PQresultStatus(res) != PGRES_COMMAND_OK) {
        fprintf(stderr, "Query execution failed: %s\n", PQerrorMessage(conn));
        PQclear(res);
        exit(EXIT_FAILURE);
    }
    PQclear(res);

    res = PQexec(conn, cursorName);
    if (PQresultStatus(res) != PGRES_COMMAND_OK) {
        fprintf(stderr, "Cursor declaration failed: %s\n", PQerrorMessage(conn));
        PQclear(res);
        exit(EXIT_FAILURE);
    }
    PQclear(res);

    res = PQexec(conn, "FETCH ALL in mycursor");
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        fprintf(stderr, "FETCH ALL failed: %s\n", PQerrorMessage(conn));
        PQclear(res);
        exit(EXIT_FAILURE);
    }
    return res;
}

// Function to process and print the fetched data
void processAndPrintData(PGresult* res) {
    int numRows = PQntuples(res);
    for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < PQnfields(res); j++) {
            printf("%s\t", PQgetvalue(res, i, j));
        }
        printf("\n");
    }
}

int main() {
    const char* conninfo = "dbname=yourdb user=youruser password=yourpassword";
    const char* cursorName = "mycursor";
    const char* query = "DECLARE mycursor CURSOR FOR SELECT * FROM yourtable";

    // Initialize libcurl
    CURL* curl = initializeCurl();

    // Initialize PostgreSQL connection
    PGconn* conn = initializePostgres(conninfo);

    // Fetch and process data
    PGresult* res = fetchData(conn, cursorName, query);
    processAndPrintData(res);
    PQclear(res);

    // Cleanup
    cleanupCurl(curl);
    cleanupPostgres(conn);

    return 0;
}
