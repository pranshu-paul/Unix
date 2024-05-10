#!/usr/bin/env python3

import subprocess
import time

current_time = time.localtime()

formatted_time = time.asctime(current_time)

df_output = subprocess.check_output(["df", "-h"]).decode("utf-8")

html_output = f"""<!DOCTYPE html>
<html lang="en">
<head>
<title>Memory Status</title>

</head>
<body><br><center><b><font face=verdana size=3>Linux Server Health Report</font></b></center>
<center><b><font face=verdana size=2 color=#0000ff>{formatted_time}</font></b></center><br><hr>

<br>
<br>
<br>

<div align="center">
"""

html_output += "<table width=800 bgcolor=#FAF9F6 border=0>\n"
html_output += "<tr>"
html_output += "<th bgcolor='#2C3539'><font color='white' size=2'>Filesystem</th>"
html_output += "<th bgcolor='#2C3539'><font color='white' size=2'>Size</th>"
html_output += "<th bgcolor='#2C3539'><font color='white' size=2'>Used</th>"
html_output += "<th bgcolor='#2C3539'><font color='white' size=2'>Avail</th>"
html_output += "<th bgcolor='#2C3539'><font color='white' size=2'>Use%</th>"
html_output += "<th bgcolor='#2C3539'><font color='white' size=2'>Mounted on</th>"
html_output += "</tr>\n"
lines = df_output.strip().split("\n")[1:]  # Skip the header line
for line in lines:
    fields = line.split()
    html_output += "<tr>"
    html_output += "<td>{}</td>".format(fields[0])
    html_output += "<td>{}</td>".format(fields[1])
    html_output += "<td>{}</td>".format(fields[2])
    html_output += "<td>{}</td>".format(fields[3])
    use_percentage = float(fields[4].strip('%'))
    if use_percentage > 20:
        html_output += "<td bgcolor='red'><font color='white' size=2'>{}</td>".format(fields[4])
    else:
        html_output += "<td>{}</td>".format(fields[4])
    html_output += "<td>{}</td>".format(fields[5])
    html_output += "</tr>\n"
html_output += "</table>\n"

html_output += "</body>\n</html>"

print(html_output)