package main

import (
	"gopkg.in/gomail.v2"
)

func main() {
	// Set up email connection
	d := gomail.NewDialer("smtp.office365.com", 587, "paulpranshu@outlook.com", "wocndebqvwemwrur")

	// Create email message
	m := gomail.NewMessage()
	m.SetHeader("From", "paulpranshu@outlook.com")
	m.SetHeader("To", "paulpranshu@gmail.com")
	m.SetHeader("Subject", "Your Subject")
	m.SetBody("text/plain", "Hello, this is the email body.")

	// Send email
	if err := d.DialAndSend(m); err != nil {
		panic(err)
	}
}
