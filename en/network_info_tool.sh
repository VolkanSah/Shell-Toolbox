#!/bin/bash

# Function to display the menu
show_menu() {
    echo "============================="
    echo " Network Information Menu"
    echo "============================="
    echo "1. Show Network Interfaces (ifconfig)"
    echo "2. Show Network Interfaces (ip a)"
    echo "3. Show Network Status (netstat)"
    echo "4. Show Network Status (ss)"
    echo "5. Show DNS Information (nslookup)"
    echo "6. Show DNS Information (dig)"
    echo "7. Ping an IP Address or Domain"
    echo "8. Traceroute to an IP Address or Domain"
    echo "9. Show ARP Table (arp -a)"
    echo "10. Show Routing Table (route -n)"
    echo "11. Show Firewall Rules (iptables -L)"
    echo "12. Show Active Connections (lsof -i)"
    echo "13. Exit"
    echo "============================="
}

# Functions for each option
network_interfaces_ifconfig() {
    echo "Network Interfaces (ifconfig):"
    ifconfig
}

network_interfaces_ip() {
    echo "Network Interfaces (ip a):"
    ip a
}

network_status_netstat() {
    echo "Network Status (netstat):"
    netstat
}

network_status_ss() {
    echo "Network Status (ss):"
    ss
}

dns_info_nslookup() {
    read -p "Enter a domain or IP address for nslookup: " address
    nslookup $address
}

dns_info_dig() {
    read -p "Enter a domain or IP address for dig: " address
    dig $address
}

ping_address() {
    read -p "Enter an IP address or domain to ping: " address
    ping -c 4 $address
}

traceroute_address() {
    read -p "Enter an IP address or domain for traceroute: " address
    traceroute $address
}

arp_table() {
    echo "ARP Table (arp -a):"
    arp -a
}

routing_table() {
    echo "Routing Table (route -n):"
    route -n
}

firewall_rules() {
    echo "Firewall Rules (iptables -L):"
    sudo iptables -L
}

active_connections() {
    echo "Active Connections (lsof -i):"
    sudo lsof -i
}

# Main program
while true; do
    show_menu
    read -p "Choose an option: " choice
    case $choice in
        1)
            network_interfaces_ifconfig
            ;;
        2)
            network_interfaces_ip
            ;;
        3)
            network_status_netstat
            ;;
        4)
            network_status_ss
            ;;
        5)
            dns_info_nslookup
            ;;
        6)
            dns_info_dig
            ;;
        7)
            ping_address
            ;;
        8)
            traceroute_address
            ;;
        9)
            arp_table
            ;;
        10)
            routing_table
            ;;
        11)
            firewall_rules
            ;;
        12)
            active_connections
            ;;
        13)
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
