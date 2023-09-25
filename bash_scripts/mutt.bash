#!/bin/bash

attachment[0]='/fzd04_home/scripts/Health_check/HEALTH_CHECK_REPORT_FOR_PROD.html'
attachment[1]='/fzd04_home/scripts/Health_check/HEALTH_CHECK_REPORT_OF_DATABASE_OS.html'
attachment[2]='/fzd04_home/scripts/Health_check/RMAN_BKP_REPORT_FOR_FOIL_PROD.html'

recipient[0]='dba@rostantechnologies.com'
recipient[1]='himanshu_mehta@fineorganics.com'
recipient[2]='yogesh_tare@fineorganics.com'
recipient[3]='pavan_patil@fineorganics.com'

subject='ZPROD Daily Health Check Report'

echo 'This is an email from Finezeeland Production.'  | mutt -c "${recipient[@]:1}" -s "${subject}" "${recipient[0]}" -a "${attachment[@]}"