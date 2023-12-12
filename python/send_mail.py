import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders

email = 'paulpranshu@outlook.com'
recipient = 'paulpranshu@gmail.com'
file_path = 'hr.sql'
name = 'Pranshu Paul'
subject = 'Test #7'
password = ''
message = "This is the body of your email."

smtp_server = 'smtp.office365.com'

smtp_port = 587

smtp = smtplib.SMTP(smtp_server, smtp_port)
smtp.ehlo()
smtp.starttls()
smtp.login(email, password)

header = MIMEMultipart()
header['From'] = name
header['To'] = recipient
header['Subject'] = subject

header.attach(MIMEText(message, 'plain'))

filename = file_path
attachment = open(filename, 'rb')

part = MIMEBase('application', 'octet-stream')
part.set_payload(attachment.read())
encoders.encode_base64(part)
part.add_header('Content-Disposition', f'attachment; filename= {filename}')
header.attach(part)

text = header.as_string()
smtp.sendmail(email, recipient, text)

smtp.quit()