#!/bin/bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display the menu
show_menu() {
    echo -e "${YELLOW}============================="
    echo " Network Information Menu"
    echo "=============================${NC}"
    echo "1. Show Network Interfaces"
    echo "2. Show Network Status"
    echo "3. DNS Information"
    echo "4. Ping an IP Address or Domain"
    echo "5. Traceroute to an IP Address or Domain"
    echo "6. Show ARP Table"
    echo "7. Show Routing Table"
    echo "8. Show Firewall Rules"
    echo "9. Show Active Connections"
    echo "10. Network Speed Test"
    echo "11. Exit"
    echo -e "${YELLOW}=============================${NC}"
}

# Function to execute commands and handle errors
execute_command() {
    echo -e "${GREEN}Executing: $1${NC}"
    eval $1
    if [ $? -ne 0 ]; then
        echo -e "${RED}Command failed. Please check your permissions or try again.${NC}"
    fi
}

# Functions for each option
network_interfaces() {
    echo -e "${YELLOW}Network Interfaces:${NC}"
    echo "1. Using ifconfig"
    echo "2. Using ip a"
    read -p "Choose an option: " interface_choice
    case $interface_choice in
        1) execute_command "ifconfig" ;;
        2) execute_command "ip a" ;;
        *) echo -e "${RED}Invalid choice${NC}" ;;
    esac
}

network_status() {
    echo -e "${YELLOW}Network Status:${NC}"
    echo "1. Using netstat"
    echo "2. Using ss"
    read -p "Choose an option: " status_choice
    case $status_choice in
        1) execute_command "netstat -tuln" ;;
        2) execute_command "ss -tuln" ;;
        *) echo -e "${RED}Invalid choice${NC}" ;;
    esac
}

dns_info() {
    echo -e "${YELLOW}DNS Information:${NC}"
    echo "1. Using nslookup"
    echo "2. Using dig"
    read -p "Choose an option: " dns_choice
    read -p "Enter a domain or IP address: " address
    case $dns_choice in
        1) execute_command "nslookup $address" ;;
        2) execute_command "dig $address" ;;
        *) echo -e "${RED}Invalid choice${NC}" ;;
    esac
}

ping_address() {
    read -p "Enter an IP address or domain to ping: " address
    execute_command "ping -c 4 $address"
}

traceroute_address() {
    read -p "Enter an IP address or domain for traceroute: " address
    execute_command "traceroute $address"
}

arp_table() {
    echo -e "${YELLOW}ARP Table:${NC}"
    execute_command "arp -a"
}

routing_table() {
    echo -e "${YELLOW}Routing Table:${NC}"
    execute_command "route -n"
}

firewall_rules() {
    echo -e "${YELLOW}Firewall Rules:${NC}"
    execute_command "sudo iptables -L"
}

active_connections() {
    echo -e "${YELLOW}Active Connections:${NC}"
    execute_command "sudo lsof -i"
}

network_speed_test() {
    echo -e "${YELLOW}Network Speed Test:${NC}"
    if command -v speedtest-cli &> /dev/null; then
        execute_command "speedtest-cli"
    else
        echo -e "${RED}speedtest-cli is not installed. Would you like to install it? (y/n)${NC}"
        read install_choice
        if [ "$install_choice" = "y" ]; then
            execute_command "sudo apt-get update && sudo apt-get install speedtest-cli -y"
            execute_command "speedtest-cli"
        else
            echo "Skipping speed test."
        fi
    fi
}

# Main program
while true; do
    show_menu
    read -p "Choose an option: " choice
    case $choice in
        1) network_interfaces ;;
        2) network_status ;;
        3) dns_info ;;
        4) ping_address ;;
        5) traceroute_address ;;
        6) arp_table ;;
        7) routing_table ;;
        8) firewall_rules ;;
        9) active_connections ;;
        10) network_speed_test ;;
        11)
            echo "Exiting program."
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice, please try again.${NC}"
            ;;
    esac
    echo "Press Enter to return to the menu..."
    read
done
