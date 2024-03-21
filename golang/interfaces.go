package main

import "fmt"

// Define an interface
type Shape interface {
    Area() float64
}

// Implement the interface for a rectangle
type Rectangle struct {
    Width, Height float64
}

func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

// Implement the interface for a circle
type Circle struct {
    Radius float64
}

func (c Circle) Area() float64 {
    return 3.14 * c.Radius * c.Radius
}

func main() {
    // Use the interface
    shapes := []Shape{Rectangle{Width: 3, Height: 4}, Circle{Radius: 5}}

    for _, shape := range shapes {
        fmt.Printf("Area: %.2f\n", shape.Area())
    }
}
