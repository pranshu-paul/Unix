# sendmail

# Basic syntax to send mails from a unix system.
echo <message> | sendmail -F <sender_name> someone@example.com

#############################################################
#!/bin/bash

# Define email parameters
from_name="paul"
to_address="paul@paulpranshu.xyz"
subject="Test Email with Attachment"
message="This is a test email with an attachment."
attachment_file="/home/paul/testu.tar"

# Create a temporary file for the email body
email_body=$(mktemp)
attachment_base64=$(base64 -w 0 "$attachment_file")

cat <<EOT > "$email_body"
To: $to_address
From: "$from_name" "$from_address"
Subject: "$subject"
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="boundary-string"

--boundary-string
Content-Type: text/plain; charset="UTF-8"

$message

--boundary-string
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="$attachment_file"
Content-Transfer-Encoding: base64

$attachment_base64

--boundary-string--
EOT

# Send the email using sendmail
/usr/sbin/sendmail -t < "$email_body"

# Clean up the temporary file
rm "$email_body"


#########################################################

# Sendmail requires a host entry of the SMTP server as "mailhost".
192.168.1.100   mailsrv2.fineorganics.com  mailsrv2 mailhost