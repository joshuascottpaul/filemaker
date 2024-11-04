#!/bin/bash
FM_PASS="hard coded password not recommended"
# Function to display usage instructions
usage() {
    echo "Usage: $0 <command> [services]"
    echo "Commands:"
    echo "  list clients"
    echo "  start <service(s)>    # Start specified services, e.g., start fmse xdbc wpe"
    echo "  stop <service(s)>     # Stop specified services, e.g., stop fmse xdbc wpe"
    echo "  restart <service(s)>  # Restart specified services, e.g., restart fmse xdbc wpe"
    echo "  <other commands>      # Replace <other commands> with actual FileMaker Server admin commands"
    exit 1
}

# Check if no arguments are provided
if [[ $# -eq 0 ]]; then
    usage
fi

# Prompt for password securely (if not already set via an environment variable)
if [[ -z "$FM_PASS" ]]; then
    read -sp "Enter FileMaker Server Password: " FM_PASS
    echo
fi

# Extract the main command and shift arguments
COMMAND=$1
shift

# Define valid service control commands
if [[ "$COMMAND" == "start" || "$COMMAND" == "stop" || "$COMMAND" == "restart" ]]; then
    if [[ $# -eq 0 ]]; then
        echo "Error: No services specified for $COMMAND."
        usage
    fi

    # Loop through each specified service and apply the command
    for SERVICE in "$@"; do
        echo "${COMMAND^}ing $SERVICE..."
        /usr/bin/fmsadmin "$COMMAND" "$SERVICE" -y -u root -p "$FM_PASS"
    done
else
    # Run the provided command with all additional arguments
    /usr/bin/fmsadmin "$COMMAND" "$@" -u root -p "$FM_PASS"
