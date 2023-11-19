#!/bin/bash

while true
do
    kubectl port-forward service/web-service 3000:3000 &
    PID=$!  # Capture the process ID of the last backgrounded command

    sleep 5  # Wait for 5 seconds before terminating the port-forward

    # Kill the port-forward process to avoid multiple instances running concurrently
    kill $PID >/dev/null 2>&1  # Suppress errors in case the process doesn't exist

    wait $PID 2>/dev/null  # Wait for the process to finish (suppress output)
done
