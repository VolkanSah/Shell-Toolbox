#!/bin/bash

# Funktion zum Anzeigen des Menüs
show_menu() {
    echo "============================="
    echo " Netzwerk-Informations Menü"
    echo "============================="
    echo "1. Netzwerkinterfaces anzeigen (ifconfig)"
    echo "2. Netzwerkinterfaces anzeigen (ip a)"
    echo "3. Netzwerkstatus anzeigen (netstat)"
    echo "4. Netzwerkstatus anzeigen (ss)"
    echo "5. DNS-Informationen anzeigen (nslookup)"
    echo "6. DNS-Informationen anzeigen (dig)"
    echo "7. Pingen einer IP-Adresse oder Domain"
    echo "8. Traceroute zu einer IP-Adresse oder Domain"
    echo "9. ARP-Tabelle anzeigen (arp -a)"
    echo "10. Routing-Tabelle anzeigen (route -n)"
    echo "11. Firewall-Regeln anzeigen (iptables -L)"
    echo "12. Aktive Verbindungen anzeigen (lsof -i)"
    echo "13. Beenden"
    echo "============================="
}

# Funktionen für die einzelnen Optionen
network_interfaces_ifconfig() {
    echo "Netzwerkinterfaces (ifconfig):"
    ifconfig
}

network_interfaces_ip() {
    echo "Netzwerkinterfaces (ip a):"
    ip a
}

network_status_netstat() {
    echo "Netzwerkstatus (netstat):"
    netstat
}

network_status_ss() {
    echo "Netzwerkstatus (ss):"
    ss
}

dns_info_nslookup() {
    read -p "Geben Sie eine Domain oder IP-Adresse für nslookup ein: " address
    nslookup $address
}

dns_info_dig() {
    read -p "Geben Sie eine Domain oder IP-Adresse für dig ein: " address
    dig $address
}

ping_address() {
    read -p "Geben Sie eine IP-Adresse oder Domain zum Pingen ein: " address
    ping -c 4 $address
}

traceroute_address() {
    read -p "Geben Sie eine IP-Adresse oder Domain für Traceroute ein: " address
    traceroute $address
}

arp_table() {
    echo "ARP-Tabelle (arp -a):"
    arp -a
}

routing_table() {
    echo "Routing-Tabelle (route -n):"
    route -n
}

firewall_rules() {
    echo "Firewall-Regeln (iptables -L):"
    sudo iptables -L
}

active_connections() {
    echo "Aktive Verbindungen (lsof -i):"
    sudo lsof -i
}

# Hauptprogramm
while true; do
    show_menu
    read -p "Wählen Sie eine Option: " choice
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
            echo "Programm wird beendet."
            break
            ;;
        *)
            echo "Ungültige Auswahl, bitte erneut versuchen."
            ;;
    esac
    echo "Drücken Sie eine beliebige Taste, um zum Menü zurückzukehren..."
    read -n 1
done
