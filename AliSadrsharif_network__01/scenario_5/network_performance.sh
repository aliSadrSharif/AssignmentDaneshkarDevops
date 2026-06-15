#!/bin/bash

# Configuration
SERVER_IP="" # IP address of the iperf3 server. Leave empty for localhost.
REPORT_FILE="performance_report.txt"
UDP_BANDWIDTH="100M" # Bandwidth for UDP test
IPERF_PORT=5201 # Default iperf3 port

# Check and install iperf3
echo "Checking if iperf3 is installed..."
if ! command -v iperf3 &> /dev/null
then
    echo "iperf3 could not be found. Attempting to install..."
    if sudo apt update && sudo apt install -y iperf3; then
        echo "iperf3 installed successfully."
    else
        echo "Failed to install iperf3. Please install it manually (sudo apt install iperf3) and re-run the script."
        exit 1
    fi
else
    echo "iperf3 is already installed."
fi

# Clear previous report
> "$REPORT_FILE"
echo "Cleared previous report file: $REPORT_FILE"

# Function to run command and append to report
run_and_report() {
    local cmd="$1"
    local title="$2"
    echo "--- $title ---" >> "$REPORT_FILE"
    echo "Running: $cmd"
    if eval "$cmd" >> "$REPORT_FILE" 2>&1; then
        echo "$title completed successfully."
    else
        echo "Error running $title. Check $REPORT_FILE for details."
    fi
    echo -e "\n" >> "$REPORT_FILE"
}

# Check if port is available
is_port_in_use() {
    local port=$1
    if sudo lsof -i :$port > /dev/null; then
        return 0 # Port is in use
    else
        return 1 # Port is free
    fi
}

# Determine server IP
if [ -z "$SERVER_IP" ]; then
    echo "Running in localhost mode (no server IP provided)."
    # Check if the iperf port is available before starting server
    if is_port_in_use $IPERF_PORT; then
        echo "Port $IPERF_PORT is already in use. Please close other applications using this port or specify a different SERVER_IP."
        # Try to find and kill the existing iperf3 server process
        SERVER_PID=$(pgrep -f "iperf3 -s")
        if [ -n "$SERVER_PID" ]; then
            echo "Found existing iperf3 server process with PID $SERVER_PID. Attempting to kill it..."
            kill $SERVER_PID
            sleep 2 # Give it a moment to die
            if is_port_in_use $IPERF_PORT; then
                 echo "Failed to free port $IPERF_PORT. Exiting."
                 exit 1
            else
                 echo "Successfully killed existing server process."
            fi
        else
            echo "Could not find an existing iperf3 server process. Please check manually."
            exit 1
        fi
    fi

    echo "Starting iperf3 server in the background on port $IPERF_PORT..."
    iperf3 -s -p $IPERF_PORT > /dev/null 2>&1 &
    SERVER_PID=$!
    echo "Server started with PID $SERVER_PID. Waiting for it to be ready..."
    sleep 5 # Increased wait time
    IPERF_CMD_BASE="iperf3 -c localhost -p $IPERF_PORT"
else
    echo "Using provided server IP: $SERVER_IP"
    # If a server IP is provided, assume the server is already running
    IPERF_CMD_BASE="iperf3 -c $SERVER_IP -p $IPERF_PORT"
fi

# Perform Network Tests

# 1. TCP Bandwidth Test
echo "Running TCP Bandwidth Test..."
run_and_report "$IPERF_CMD_BASE" "TCP Bandwidth Test (Client -> Server)"

# 2. UDP Test (Jitter, Latency, Packet Loss)
echo "Running UDP Test for Jitter, Latency, and Packet Loss..."
run_and_report "$IPERF_CMD_BASE -u -b $UDP_BANDWIDTH" "UDP Test (Jitter, Latency, Packet Loss)"

# 3. Packet Loss Calculation (already included in UDP test output)
echo "Packet loss is included in the UDP test results."

# 4. Full Performance Report
echo "Full performance report saved to: $REPORT_FILE"
echo "Network performance tests completed."

# Stop iperf3 server if started by this script
if [ -z "$SERVER_IP" ] && [ -n "$SERVER_PID" ]; then
    echo "Stopping iperf3 server (PID: $SERVER_PID)..."
    # Check if the process actually exists before trying to kill
    if ps -p $SERVER_PID > /dev/null; then
        kill $SERVER_PID
        wait $SERVER_PID 2>/dev/null # Wait for the process to actually terminate
        echo "Server stopped."
    else
        echo "Server process (PID: $SERVER_PID) already terminated."
    fi
fi

echo "Script finished."

exit 0
