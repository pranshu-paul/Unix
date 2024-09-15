#!/bin/bash

service=API
port=none
host=172.19.8.113
user=pranshu
state=Testing
severity=None

api_url="https://api2.nexgplatforms.com/sms/1/text/query"
username="NexGAlrT"
password="Happy@1234"
from="NXGART"
# Pranshu,Abhishek,Satish,Sunil,Prashant,Shubham,Rohit
to="919873514389,918318867792,919958887630,919888632435,918860648225,919456188822,919868660119"
indiaDltContentTemplateId="1207171507167956290"
indiaDltPrincipalEntityId="1201164455577917424"

message="Dear TechOps,

Service: "$service"
Host: "$host"
Severity level: "$severity"
State: "$state"
Date/Time: $(date "+%d %b %Y %H:%M")

Thanks and Regards,
nexG Platforms."

send_message() {
response=$(curl -L -s -G \
    --data-urlencode "username=$username" \
    --data-urlencode "password=$password" \
    --data-urlencode "from=$from" \
    --data-urlencode "to=$to" \
    --data-urlencode "indiaDltContentTemplateId=$indiaDltContentTemplateId" \
    --data-urlencode "indiaDltPrincipalEntityId=$indiaDltPrincipalEntityId" \
    --data-urlencode "text=$message" \
    "$api_url"
)

echo "API Response:"
echo "$response" | jq
}

send_message