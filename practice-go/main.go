package main

import "fmt"

func main() {
	const price float32 = 275.00
	const tax float32 = 27.50
	const quantity = 2
	fmt.Println("Total:", quantity*(price+tax))
}
