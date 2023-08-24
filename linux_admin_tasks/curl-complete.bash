curl -T /u01/app/oracle/product/12.1.0.2/dbhome_1/appsutil/log.zip \
-u "amit@rostantechnologies.com" "ftps://transport.oracle.com/issue/3-30514507571/"

curl http://169.254.169.254/opc/v1/instance/

curl http://169.254.169.254/opc/v1/instance/metadata/

curl http://169.254.169.254/opc/v1/vnics

curl ifconfig.co

# The below must be created.
From: testing.paulpranshu@gmail.com
To: "Pranshu Paul" paulpranshu@gmail.com
Subject: This is a test.

Hi Pranshu,
I’m sending this mail with curl thru my gmail account.
Bye!

# Add username and password in ~/.netrc.
machine smtp.gmail.com login testing.paulpranshu@gmail.com password <password>
machine <smpt_host> login <email_address> password <password>

# Attachments can be sent through encoding in base 64
curl --ssl-reqd \
--url 'smtps://smtp.gmail.com:465' \
--mail-from 'testing.paulpranshu@gmail.com' \
--mail-rcpt 'paulpranshu@gmail.com' \
--upload-file mail.txt \
-n
