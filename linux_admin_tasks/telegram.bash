# Find the botfather
@botfather

# Type /newbot

# Give it a name: test_api

# Create a user and get the API key for the bot that ends with "_bot": paulpranshu_bot

# Then create a channel and add the bot as an admin member to the channel.

# Get the channel id.
curl -s https://api.telegram.org/bot<api_token>/getUpdates | jq '.result[0].message.from.id'
curl -s https://api.telegram.org/bot6925765422:AAFdDHEfxyopvpyYd2lmBqy13IqtXgJ0LPI/getUpdates | jq '.result[0].message.chat.id'


# To send a message
curl -s --data "text=message $RANDOM" --data "chat_id=6738720838" https://api.telegram.org/bot6925765422:AAFdDHEfxyopvpyYd2lmBqy13IqtXgJ0LPI/sendMessage | jq

# To send a file.
curl -s -F document=@"/etc/fstab" https://api.telegram.org/bot6925765422:AAFdDHEfxyopvpyYd2lmBqy13IqtXgJ0LPI/sendDocument?chat_id=6738720838 | jq