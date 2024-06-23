#include <stdio.h>

typedef int integer;

int main() {
	int i = 22, *ptr;
	float f = 33;
	integer j = i;
	ptr = &j;
	printf("%d\n", *ptr);
	return 0;
}