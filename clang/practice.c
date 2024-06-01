#include <stdio.h>

int main(void) {
    char s1[] = "abcdef";
    s1[0] = 'X';

    printf("s1: %s\n", s1);

    const char *s2 = "abcdef";

    s2++;

    printf("s2: %s\n", s2);

    s2 = "new string";

    printf("s2: %s\n", s2);

    printf("sizeof(s1): %d\n", sizeof(s1));
    printf("sizeof(s2): %d\n", sizeof(s2));

    return 0;
}