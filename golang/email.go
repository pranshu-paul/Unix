package main

import (
	"log"

	"gopkg.in/gomail.v2"
)

func main() {
	d := gomail.NewDialer("smtp.office365.com", 587, "paulpranshu@outlook.com", "wocndebqvwemwrur")

	m := gomail.NewMessage()
	m.SetHeader("From", "paulpranshu@outlook.com")
	m.SetHeader("To", "paulpranshu@gmail.com")
	m.SetHeader("Subject", "Your Subject")
	m.SetBody("text/html", "<h1>Hello, this is the email body.</h1>")
	m.Attach("C:\\Users\\Pranshu\\OneDrive\\Unix\\golang\\aws\\lambda.json")

	err := d.DialAndSend(m)

	if err != nil {
		log.Fatal(err)
	}
}
