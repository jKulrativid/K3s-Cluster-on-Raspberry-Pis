#!/bin/bash

while true
do
    kubectl port-forward service/web-service 3000:3000 --address 0.0.0.0 &
    PID1=$!  # Capture the process ID of the last backgrounded command
	kubectl port-forward service/gateway-service 8080:8080 --address 0.0.0.0 &
    PID2=$!  # Capture the process ID of the last backgrounded command
	kubectl port-forward service/chef-service 50001:50001 --address 0.0.0.0 &
    PID3=$!  # Capture the process ID of the last backgrounded command
	kubectl port-forward service/recipe-service 50002:50002 --address 0.0.0.0 &
    PID4=$!  # Capture the process ID of the last backgrounded command
	kubectl port-forward service/review-service 50003:50003 --address 0.0.0.0 &
    PID5=$!  # Capture the process ID of the last backgrounded command

    sleep 40  # Wait for 40 seconds before terminating the port-forward

    # Kill the port-forward process to avoid multiple instances running concurrently
    kill $PID1 >/dev/null 2>&1  # Suppress errors in case the process doesn't exist
    wait $PID1 2>/dev/null  # Wait for the process to finish (suppress output)
	kill $PID2 >/dev/null 2>&1  # Suppress errors in case the process doesn't exist
    wait $PID2 2>/dev/null  # Wait for the process to finish (suppress output)
	kill $PID3 >/dev/null 2>&1  # Suppress errors in case the process doesn't exist
    wait $PID3 2>/dev/null  # Wait for the process to finish (suppress output)
	kill $PID4 >/dev/null 2>&1  # Suppress errors in case the process doesn't exist
    wait $PID4 2>/dev/null  # Wait for the process to finish (suppress output)
	kill $PID5 >/dev/null 2>&1  # Suppress errors in case the process doesn't exist
    wait $PID5 2>/dev/null  # Wait for the process to finish (suppress output)
done
