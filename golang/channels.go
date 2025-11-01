package main

import "fmt"

// Working with channels

func main() {
	dataChan := make(chan int, 2)

	dataChan <- 789 // Adding data to channel
	dataChan <- 123 // Adding data to channel

	n := <-dataChan // Get data from channel

	fmt.Printf("n = %d\n", n)
}

///////////////////////////////

package main

import "fmt"

// Working with channels

func main() {
	dataChan := make(chan int)

	go func() {
		dataChan <- 789 // Adding data to channel
	}()

	n := <-dataChan // Get data from channel

	fmt.Printf("n = %d\n", n)
}

////////////////////
package main

import "fmt"

func main() {

	dataChan := make(chan int)

	go func() {
		for i := 0; i < 9999; i++ {
			dataChan <- i
		}
		close(dataChan)
	}()

	for n := range dataChan {
		fmt.Printf("n = %d\n", n)
	}
}

//////////////////////////
package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

func DoWork() int {
	time.Sleep(time.Second)
	return rand.Intn(100)
}

func main() {

	dataChan := make(chan int)

	go func() {
		wg := sync.WaitGroup{}
		for i := 0; i < 999; i++ {
			wg.Add(1)
			go func() {
				result := DoWork()
				dataChan <- result
			}()
		}
		wg.Wait()
		close(dataChan)
	}()

	for n := range dataChan {
		fmt.Printf("n = %d\n", n)
	}
}