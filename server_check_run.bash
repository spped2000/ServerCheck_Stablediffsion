#!/bin/bash

server="http://13.229.216.225:7860/"
webui_script="./webui.sh --listen"

is_server_running() {
    # Check if the server process is running
    if pgrep -f "$webui_script" >/dev/null; then
        return 0 # Server is running
    else
        return 1 # Server is not running
    fi
}

while true; do
    response=$(curl -s -I "$server")
    if [[ ! $response =~ "200 OK" ]]; then
        echo "$(date): Server is down! Restarting..."
        if is_server_running; then
            echo "Stopping the existing server..."
            pkill -f "$webui_script"
            sleep 5  # Wait for the server process to stop
        fi
        echo "Starting the server..."
        $webui_script
    else
        echo "$(date): Server is up!"
    fi
    sleep 10  # Adjust this delay as needed
done
