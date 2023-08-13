#!/bin/bash

# Define email parameters
from_name="Pranshu Paul"
from_address="root@srv07"
to_address="paul@paulpranshu.xyz"
subject="Test Email with Attachment"
message="This is a test email with an attachment."
attachment_file="/etc/fstab"

# Create a temporary file for the email body
email_body=$(mktemp)
cat <<EOT > "$email_body"
To: $to_address
From: "$from_name" <$from_address>
Subject: $subject
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="boundary-string"

--boundary-string
Content-Type: text/plain; charset="UTF-8"

$message

--boundary-string
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="$(basename "$attachment_file")"

This is the content of the attachment.

--boundary-string--
EOT

# Send the email using sendmail
/usr/sbin/sendmail -t < "$email_body"

# Clean up the temporary file
rm "$email_body"
