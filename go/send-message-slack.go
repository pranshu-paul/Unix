package main

import (
	"fmt"
	"log"

	"github.com/slack-go/slack"
)

func main() {
	token := "xoxb-2226659207044-7321559358486-QrBba1o11x9sEBD9fy7Nktit"
	channelID := "C079NMLN6TV"

	client := slack.New(token)

	message := "Hello, this is an automated message."

	channelID, timestamp, err := client.PostMessage(
		channelID,
		slack.MsgOptionText(message, false),
	)

	if err != nil {
		log.Fatalf("Failed to send message: %v", err)
	}

	fmt.Printf("Sent to channel %s at %s\n", channelID, timestamp)
}
