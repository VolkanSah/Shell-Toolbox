#!/bin/bash

# Function to display the menu
show_menu() {
    echo "============================="
    echo " Developer Toolbox Menu"
    echo "============================="
    echo "1. System Update (apt-get update)"
    echo "2. System Upgrade (apt-get upgrade)"
    echo "3. Autoclean (apt-get autoclean)"
    echo "4. Clear RAM"
    echo "5. Clear Cache"
    echo "6. Show System Information"
    echo "7. Exit"
    echo "============================="
}

# Function for system update
system_update() {
    echo "Performing system update..."
    sudo apt-get update
}

# Function for system upgrade
system_upgrade() {
    echo "Performing system upgrade..."
    sudo apt-get upgrade -y
}

# Function for autoclean
autoclean() {
    echo "Performing autoclean..."
    sudo apt-get autoclean
}

# Function to clear RAM
clear_ram() {
    echo "Clearing RAM..."
    sudo sync
    sudo sysctl -w vm.drop_caches=3
}

# Function to clear cache
clear_cache() {
    echo "Clearing cache..."
    sudo sync
    echo 3 | sudo tee /proc/sys/vm/drop_caches
}

# Function to show system information
system_info() {
    echo "System Information:"
    uname -a
    lscpu
    free -h
    df -h
}

# Main program
while true; do
    show_menu
    read -p "Choose an option: " choice
    case $choice in
        1)
            system_update
            ;;
        2)
            system_upgrade
            ;;
        3)
            autoclean
            ;;
        4)
            clear_ram
            ;;
        5)
            clear_cache
            ;;
        6)
            system_info
            ;;
        7)
            echo "Exiting program."
            break
            ;;
        *)
            echo "Invalid choice, please try again."
            ;;
    esac
    echo "Press any key to return to the menu..."
    read -n 1
done
