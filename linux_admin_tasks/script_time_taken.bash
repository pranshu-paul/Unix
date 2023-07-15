start_time=$(date +%s)

##
## Shell script goes here
##

end_time=$(date +%s)
execution_time=$((end_time - start_time))

hours=$((execution_time / 3600)) 
minutes=$((execution_time % 3600 / 60))

Script execution time: $hours hour(s) $minutes minute(s)