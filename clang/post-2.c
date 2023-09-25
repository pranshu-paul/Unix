#include <stdio.h>
#include <stdlib.h> // Include for malloc and free
#include <libpq-fe.h>

int main(int argc, char* argv[]) {
    PGconn *conn;
    PGresult *res;
    const char *connString = "dbname = customer user = postgres password = Mysql#459 hostaddr = 127.0.0.1 port = 5432";
    const char *sql = "select * from customer";

    conn = PQconnectdb(connString);

    if (PQstatus(conn) == CONNECTION_OK) {
        printf("Opened database successfully: %s\n", PQdb(conn));
    } else {
        printf("Can't open database: %s\n", PQerrorMessage(conn));
        PQfinish(conn);
        return 1;
    }

    res = PQexec(conn, sql);

    if (PQresultStatus(res) == PGRES_TUPLES_OK) {
        int rows = PQntuples(res);
        int cols = PQnfields(res);

        // Allocate memory for an array of strings
        char **data = (char **)malloc(rows * sizeof(char *));
        if (data == NULL) {
            perror("Memory allocation failed");
            PQclear(res);
            PQfinish(conn);
            return 1;
        }

        for (int i = 0; i < rows; i++) {
            data[i] = (char *)malloc(cols * sizeof(char));
            if (data[i] == NULL) {
                perror("Memory allocation failed");
                for (int j = 0; j < i; j++) {
                    free(data[j]); // Free previously allocated memory
                }
                free(data);
                PQclear(res);
                PQfinish(conn);
                return 1;
            }

            for (int j = 0; j < cols; j++) {
                snprintf(data[i], cols, "%s = %s\n", PQfname(res, j), PQgetvalue(res, i, j));
            }
        }

        for (int i = 0; i < rows; i++) {
            printf("%s\n", data[i]);
            free(data[i]); // Free memory for each string
        }

        free(data); // Free memory for the array of strings
        printf("Operation done successfully\n");
    } else {
        printf("Query failed: %s\n", PQerrorMessage(conn));
    }

    PQclear(res);
    PQfinish(conn);

    return 0;
}
