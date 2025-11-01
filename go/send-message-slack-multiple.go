package main

import (
	"fmt"
	"log"
	"sync"

	"github.com/slack-go/slack"
)

func main() {
	token := "xoxb-2226659207044-7321559358486-QrBba1o11x9sEBD9fy7Nktit"
	channels := []string{"C079NUFD5NX", "C079NUFD5NX"}

	client := slack.New(token)

	message := "Hello, this is an automated message."

	var wg sync.WaitGroup
	wg.Add(len(channels))

	for _, channelID := range channels {
		go func(channelID string) {
			defer wg.Done()

			_, _, err := client.PostMessage(
				channelID,
				slack.MsgOptionText(message, false),
			)

			if err != nil {
				log.Printf("Failed to sent on channel %s: %v", channelID, err)
				return
			}

			fmt.Printf("Sent to channel %s\n", channelID)
		}(channelID)
	}

	wg.Wait()
}
