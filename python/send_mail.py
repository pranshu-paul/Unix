import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders

# Email details
email = 'paulpranshu@outlook.com'
recipient = 'paulpranshu@gmail.com'
file_path = 'hr.sql'
name = 'Pranshu Paul'
subject = 'Test #7'
password = ''
message = "This is the body of your email."

# Server configuration
smtp_server = 'smtp.office365.com'
smtp_port = 587

# Initiate smtp connection
smtp = smtplib.SMTP(smtp_server, smtp_port)
smtp.ehlo()
smtp.starttls()
smtp.login(email, password)

# Set email headers
header = MIMEMultipart()
header['From'] = name
header['To'] = recipient
header['Subject'] = subject

# Provide the MIME type of the message
header.attach(MIMEText(message, 'plain'))

# Open the file in the read-only binary mode
filename = file_path
attachment = open(filename, 'rb')

# Provide the MIME type of the attachement
part = MIMEBase('application', 'octet-stream')
part.set_payload(attachment.read())
encoders.encode_base64(part)
part.add_header('Content-Disposition', f'attachment; filename= {filename}')
header.attach(part)

text = header.as_string()
smtp.sendmail(email, recipient, text)           # Send the mail

smtp.quit()
