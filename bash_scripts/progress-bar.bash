#!/bin/bash

# Define the total number of units for progress
total_units=60

# Function to display the progress bar
progress_bar() {
    local progress=$1
    local completed=$((progress * 100 / total_units))
    local remaining=$((100 - completed))
    
    # Create the progress bar
    printf "["
    for ((j = 0; j < completed; j++)); do
        printf "#"
    done
    for ((j = 0; j < remaining; j++)); do
        printf " "
    done
    printf "] %d%%" "$completed"
}

# Simulate a task with progress
for ((i = 0; i <= total_units; i++)); do
    progress_bar "$i"
    sleep 1  # Simulate 1 second of work
    echo -en "\r"  # Move the cursor to the beginning of the line
done

# Add a newline to clear the progress bar
echo


#####

#!/bin/bash

# Function to display the progress bar
progress_bar() {
    local progress=$1
    local completed=$((progress * 100 / total_units))
    local remaining=$((100 - completed))
    
    # Create the progress bar
    printf "["
    for ((j = 0; j < completed; j++)); do
        printf "#"
    done
    for ((j = 0; j < remaining; j++)); do
        printf " "
    done
    printf "] %d%%" "$completed"
}

# Define the command you want to run (replace this with your actual command)
your_command="some_command_to_run"

# Start the command in the background
$your_command &

# Get the process ID (PID) of the background command
pid=$!

# Simulate a task with progress (you can adjust total_units based on the expected duration)
total_units=60
for ((i = 0; i <= total_units; i++)); do
    # Check if the process is still running
    if ! ps -p $pid > /dev/null; then
        break  # If the process has finished, exit the loop
    fi
    
    progress_bar "$i"
    sleep 1  # Simulate 1 second of work
    echo -en "\r"  # Move the cursor to the beginning of the line
done

# Add a newline to clear the progress bar
echo
