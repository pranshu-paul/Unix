# SSH connection details
user=pranshu
ssh_port=22

# Target hosts connection details.
declare -a hosts=(
"172.19.8.166"
"172.19.8.167"
)

# Services with their port to be checked.
declare -A services=(
["bearerbox"]=13001
)

# SMS API details.
api_url="https://api2.nexgplatforms.com/sms/1/text/query"
username="NexGAlrT"
password="Happy@1234"
from="NXGART"
# Pranshu,Abhishek,Satish,Sunil,Prashant,Shubham,Rohit
to="919873514389" #,918318867792,919958887630,919888632435,918860648225,919456188822,919868660119"
indiaDltContentTemplateId="1207171507167956290"
indiaDltPrincipalEntityId="1201164455577917424"