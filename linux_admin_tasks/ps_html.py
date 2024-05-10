#!/usr/bin/env python3

import subprocess
import time

current_time = time.localtime()

formatted_time = time.asctime(current_time)

ps_output = subprocess.check_output(["ps", "-eo", "pid,ppid,pmem,pcpu,user,time,euser,ruser,comm"]).decode("utf-8")

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

    <style>
		body {{
			font: Calibri, sans-serif;
		}}		
	
        table {{
            width: 65%;
            border-collapse: collapse;
			
        }}

        td {{
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
			background-color: #FAF9F6;
			font-size: 18px;
        }}

        th {{
			border: 1px solid #ddd;
            background-color: #2C3539;
			font-size: 20px;
			color: #ffffff;
        }}
		
    </style>

<div align="center">
"""

html_output += "<table>\n"
html_output += "<tr>"
                
headers = ["PID", "PPID", "%MEM", "%CPU", "USER", "TIME", "EUSER", "RUSER", "COMMAND"]
for header in headers:
    html_output += "<th>{}</font></th>".format(header)
html_output += "</tr>\n"

lines = ps_output.strip().split("\n")[1:]
for line in lines:
    fields = line.split()
    html_output += "<tr>"
    html_output += "<td>{}</td>".format(fields[0])
    html_output += "<td>{}</td>".format(fields[1])
    html_output += "<td>{}</td>".format(fields[2])
    html_output += "<td>{}</td>".format(fields[3])
    html_output += "<td>{}</td>".format(fields[4])
    html_output += "<td>{}</td>".format(fields[5])
    html_output += "<td>{}</td>".format(fields[6])
    html_output += "<td>{}</td>".format(fields[7])
    html_output += "<td>{}</td>".format(fields[8])
    html_output += "</tr>\n"
html_output += "</table>\n"

html_output += "</body>\n</html>"

print(html_output)