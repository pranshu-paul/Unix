import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders

smtp = smtplib.SMTP('smtp.gmail.com', 587)
smtp.ehlo()
smtp.starttls()

email = 'testing.paulpranshu@gmail.com'
password = ''

recipient = 'paulpranshu@gmail.com'

smtp.login(email, password)

message = MIMEMultipart()
message['From'] = 'Pranshu Paul'
message['To'] = recipient
message['Subject'] = 'Test #1'

body = "This is the body of your email."
message.attach(MIMEText(body, 'plain'))

filename = 'hr.sql'
attachment = open(filename, 'rb')

part = MIMEBase('application', 'octet-stream')
part.set_payload(attachment.read())
encoders.encode_base64(part)
part.add_header('Content-Disposition', f'attachment; filename= {filename}')
message.attach(part)

text = message.as_string()
smtp.sendmail(email, recipient, text)

smtp.quit()