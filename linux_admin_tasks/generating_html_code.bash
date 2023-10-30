df -h |awk '{print $1, "|", $2,"|", $3,"|",$4,"|",$5,"|",$6}' | awk -F"|" 'BEGIN{print "<BR><B><FONT FACE='VERDANA' SIZE=2 color='#000000'>Disk Usage :</B></B><BR></font><table border=1  width='700'>"}{print "<tr>";for (i=1;i<=NF;i++) {print "<TD align='LEFT' bgcolor='#ccccff'><FONT FACE='VERDANA' SIZE=2>"$i"</td>"};print "</tr>"} END{print "</table>"}'



df -h | 

html() {
  echo "<table width=700 bgcolor=#E9FFE6 align=LEFT border=1>"

  while read -r line; do
    if [[ ! $header_done ]]; then
      echo "<tr>"
      IFS=' ' read -ra columns <<< "$line"
      for column in "${columns[@]}"; do
        echo "<TH align='LEFT' bgcolor='#00008B'><FONT FACE='VERDANA' color="white" SIZE=2'>$column</TH>"
      done
      echo "</tr>"
      header_done=true
    else
      echo "<tr>"
      IFS=' ' read -ra columns <<< "$line"
      for column in "${columns[@]}"; do
        echo "<TD>$column</TD>"
      done
      echo "</tr>"
    fi
  done

  echo "</table>"
}