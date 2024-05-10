#!/usr/bin/env python3

import subprocess

output = subprocess.check_output(["free", "-h"]).decode("utf-8")

# Start HTML document
html_output = "<!DOCTYPE html>\n<html>\n<head>\n<title>Memory Status</title>\n</head>\n<body>\n"

# Convert `free -h` output to HTML table
html_output += "<table width=700 bgcolor=#E9FFE6 border=0>\n"
html_output += "<tr>"
headers = [" ", "Total", "Used", "Free", "Shared", "Buff/Cache", "Available"]
for header in headers:
    html_output += "<th bgcolor='blue'><font color='white' size=2'>{}</font></th>".format(header)
html_output += "</tr>\n"

lines = output.strip().split("\n")[1:]  # Skip the header line
for line in lines:
    fields = line.split()
    html_output += "<tr>"
    for field in fields:
        html_output += "<td>{}</td>".format(field)
    html_output += "</tr>\n"

# End HTML document
html_output += "</table>\n</body>\n</html>"

# Print HTML output
print(html_output)