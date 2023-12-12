package main

import "fmt"

func sum() *[5]int {
	arr := [...]int{4, 5, 6, 7, 8}
	return &arr
}

func main() {
	result := sum()
	fmt.Println("Values in the array:", *result)
}
