import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders

# SMTP server setup
server = smtplib.SMTP('smtp.gmail.com', 587)
server.ehlo()
server.starttls()

# Your Gmail credentials
email = 'testing.paulpranshu@gmail.com'
password = 'xuurxxwvnzfqfamz'  # Replace with your Gmail password

# Recipient's email address
recipient = 'paulpranshu@gmail.com'

# Login to your Gmail account
server.login(email, password)

# Create the email content
msg = MIMEMultipart()
msg['From'] = 'NeuralNine'
msg['To'] = recipient
msg['Subject'] = 'Test #1'

# Email body
body = "This is the body of your email."
msg.attach(MIMEText(body, 'plain'))

# Attach a file
filename = 'cert.pem'  # Replace with the path to your file
attachment = open(filename, 'rb')

part = MIMEBase('application', 'octet-stream')
part.set_payload(attachment.read())
encoders.encode_base64(part)
part.add_header('Content-Disposition', f'attachment; filename= {filename}')
msg.attach(part)

# Send the email
text = msg.as_string()
server.sendmail(email, recipient, text)

# Close the connection
server.quit()