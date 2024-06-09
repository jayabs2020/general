#!/bin/bash

# Define the Bluetooth MAC address of the device
BT_MAC="AA:BB:CC:DD:EE:FF" #replace me

# Number of connection attempts
MAX_ATTEMPTS=10
ATTEMPT=1

# Delay between attempts in seconds
DELAY=10

#Some FM streaming sites, a few examples below
#Suryan FM: http://live.suryanfm.in:8000/suryanfm
#Radio Mirchi: http://peridot.streamguys.com:7150/Mirchi

# Online Tamil radio URL
RADIO_URL="http://peridot.streamguys.com:7150/Mirchi"

# Function to connect to the Bluetooth device
connect_bt() {
    echo "Attempt $ATTEMPT to connect to $BT_MAC..."
    bluetoothctl << EOF
connect $BT_MAC
EOF
}

# Function to play the Tamil radio stream
play_radio() {
    echo "Playing Tamil radio..."
    # Uncomment one of the following lines depending on the player you prefer
    # mpv --no-video "$RADIO_URL"
    cvlc --no-video "$RADIO_URL"
}

# Loop to try connecting up to MAX_ATTEMPTS times
while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    connect_bt

    # Check the connection status
    if bluetoothctl info $BT_MAC | grep -q "Connected: yes"; then
        echo "Successfully connected to $BT_MAC."
        play_radio
        exit 0
    else
        echo "Failed to connect. Retrying in $DELAY seconds..."
        sleep $DELAY
    fi

    ATTEMPT=$((ATTEMPT+1))
done

echo "Failed to connect to $BT_MAC after $MAX_ATTEMPTS attempts. Quitting."
exit 1
