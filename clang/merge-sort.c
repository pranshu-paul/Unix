#include <stdlib.h>
#include <stdio.h>

// Declaring function prototypes
void mergeSort(int*, int);
void merge(int*, int, int*, int);

int main() {
	int *arr;
	int i, N;
	
	printf("Enter the number of elements in the array:\n");
	scanf("%d", &N);
	
	arr = (int*) malloc(sizeof(int)*N);
	
	printf("Enter the %d elements to sort:\n", N);
	for (i = 0; i < N; i++) {
		scanf("%d", &arr[i]);
	}
	
	mergeSort(arr, N);
	
	printf("\nThe sorted elements are:\n");
	for  (i=0; i < N; i++) {
		printf("%d\n", arr[i]);
	}
	
	free(arr);
	return 0;
}
	
void mergeSort(int *array, int size) {
	int mid;
	if (size == 1) {
		return;
	} else {
		mid = size / 2;
		mergeSort(array, mid);
		mergeSort(array + mid, size - mid);
		merge(array, mid, array + mid, size - mid);
	}
}

void merge(int *a, int s1, int *b, int s2) {
	int i, j, k, *temp_arr;
	temp_arr = (int*) malloc((s2 + s1) * sizeof(int));
	i = j = k = 0;
	while (i < s1 && j < s2) {
		temp_arr[k++] = (a[i] < b[j]) ? a[i++] : b[j++];
	}
	
	while (i < s1) {
		temp_arr[k++] = a[i++];
	}
	
	while (j < s2) {
		temp_arr[k++] = b[j++];
	}
	
	for (i = 0; i < k; i++) {
		a[i] = temp_arr[i];
	}
	
	free(temp_arr);
}	