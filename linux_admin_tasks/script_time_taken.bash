# Function to start the timer
start_timer() {
    start_time="$(date +%s)"
}

# Function to stop the timer and display execution time
stop_timer() {
    end_time="$(date +%s)"
    execution_time=$((end_time - start_time))
    hours=$((execution_time / 3600))
    minutes=$((execution_time % 3600 / 60))
    echo -e "\nScript execution time: $hours hour(s) $minutes minute(s)"
}

# Usage example:
start_timer

##
## Your shell script code goes here
##

stop_timer
