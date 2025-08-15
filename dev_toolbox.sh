#!/bin/bash

# Farbdefinitionen
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Globale Service-Liste (ohne Konfigurationsdatei)
SERVICES=(
    "apache2"
    "mariadb"
    "tor"
    "sshd"
)

# Funktion zur Anzeige des Hauptmenüs
show_menu() {
    clear
    echo -e "${BLUE}========================================"
    echo "       Dev Server Toolbox v2.0"
    echo -e "========================================${NC}"
    echo "1.  Service-Status Übersicht"
    echo "2.  Service starten"
    echo "3.  Service stoppen"
    echo "4.  Service neustarten"
    echo "5.  Service neu laden"
    echo "6.  Alle aktiven Services neustarten"
    echo "7.  Systemressourcen anzeigen"
    echo "8.  RAM/Cache leeren"
    echo "9.  Netzwerkinformationen"
    echo "10. Prozessmonitor"
    echo "11. Service-Logs (Live)"
    echo "12. Services konfigurieren"
    echo "13. Beenden"
    echo -e "${BLUE}========================================${NC}"
    echo -e "${YELLOW}Aktuell überwachte Services: ${#SERVICES[@]}${NC}"
}

# Funktion für Ausführung mit Rückmeldung
execute_with_feedback() {
    echo -e "${YELLOW}Führe aus: $1${NC}"
    if eval "$1"; then
        echo -e "${GREEN}✓ Erfolgreich${NC}"
        return 0
    else
        echo -e "${RED}✗ Fehlgeschlagen${NC}"
        return 1
    fi
}

# Funktion zum Anzeigen verfügbarer Services
list_services() {
    echo -e "${YELLOW}Verfügbare Services:${NC}"
    local counter=1
    for service in "${SERVICES[@]}"; do
        if systemctl list-unit-files | grep -q "^$service"; then
            status=$(systemctl is-active "$service" 2>/dev/null)
            enabled=$(systemctl is-enabled "$service" 2>/dev/null)
            
            case "$status:$enabled" in
                "active:enabled")    color="${GREEN}" ;;
                "active:"*)           color="${GREEN}" ;;
                *":enabled")         color="${RED}" ;;
                *)                   color="${RED}" ;;
            esac
            
            echo -e "$counter. ${color}${service}${NC} (Status: $status, Aktiviert: $enabled)"
        else
            echo -e "$counter. ${RED}${service} (nicht gefunden!)${NC}"
        fi
        ((counter++))
    done
}

# Funktion zur Auswahl eines Services
select_service() {
    list_services
    echo
    read -p "Service-Nummer auswählen: " choice
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#SERVICES[@]} ]; then
        selected_service="${SERVICES[$((choice-1))]}"
        echo "$selected_service"
        return 0
    else
        echo -e "${RED}Ungültige Auswahl${NC}"
        return 1
    fi
}

# Service-Status Übersicht
service_status() {
    echo -e "${BLUE}Service-Status:${NC}"
    echo "========================================"
    local active_count=0
    
    for service in "${SERVICES[@]}"; do
        if systemctl list-unit-files | grep -q "^$service"; then
            status=$(systemctl is-active "$service" 2>/dev/null)
            
            if [ "$status" = "active" ]; then
                echo -e "${GREEN}● $service (aktiv)${NC}"
                ((active_count++))
            else
                echo -e "${RED}○ $service (inaktiv)${NC}"
            fi
        else
            echo -e "${RED}✗ $service (nicht installiert)${NC}"
        fi
    done
    
    echo -e "${BLUE}\nZusammenfassung: $active_count von ${#SERVICES[@]} Services aktiv${NC}"
}

# Service-Operationen ausführen
service_action() {
    local action=$1
    local service
    
    service=$(select_service)
    [ -z "$service" ] && return
    
    case "$action" in
        start)
            execute_with_feedback "sudo systemctl start $service"
            if ! systemctl is-enabled "$service" &>/dev/null; then
                echo -e "${YELLOW}Service ist nicht aktiviert.${NC}"
                read -p "Autostart aktivieren? (j/n): " choice
                [[ "$choice" =~ ^[jJ]$ ]] && execute_with_feedback "sudo systemctl enable $service"
            fi
            ;;
        *)
            execute_with_feedback "sudo systemctl $action $service"
            ;;
    esac
}

# Alle aktiven Services neustarten
restart_all() {
    echo -e "${YELLOW}Starte alle aktiven Services neu...${NC}"
    local count=0
    
    for service in "${SERVICES[@]}"; do
        if systemctl is-active "$service" &>/dev/null; then
            echo -e "Neustart: $service..."
            if execute_with_feedback "sudo systemctl restart $service"; then
                ((count++))
            fi
        fi
    done
    
    echo -e "${GREEN}$count Services wurden neu gestartet${NC}"
}

# Systemressourcen anzeigen
system_resources() {
    echo -e "${BLUE}Systemressourcen:${NC}"
    echo "========================================"
    
    echo -e "${YELLOW}Arbeitsspeicher:${NC}"
    free -h
    
    echo -e "\n${YELLOW}Festplattennutzung:${NC}"
    df -h | head -n 10
    
    echo -e "\n${YELLOW}CPU & Auslastung:${NC}"
    uptime
    
    echo -e "\n${YELLOW}Top-Prozesse:${NC}"
    top -bn1 | head -n 8
}

# RAM und Cache leeren
clear_ram() {
    echo -e "${YELLOW}Leere Systemcache...${NC}"
    execute_with_feedback "sudo sync"
    execute_with_feedback "sudo sysctl vm.drop_caches=3"
    echo -e "${GREEN}✓ RAM und Cache wurden geleert${NC}"
}

# Netzwerkinformationen
network_info() {
    echo -e "${BLUE}Netzwerkinformationen:${NC}"
    echo "========================================"
    
    echo -e "${YELLOW}Aktive Verbindungen:${NC}"
    ss -tuln
    
    echo -e "\n${YELLOW}Netzwerkinterfaces:${NC}"
    ip -br addr show
}

# Prozessmonitor
process_monitor() {
    echo -e "${BLUE}Prozessmonitor:${NC}"
    echo "========================================"
    
    echo -e "${YELLOW}CPU-intensive Prozesse:${NC}"
    ps aux --sort=-%cpu | head -n 11
    
    echo -e "\n${YELLOW}Speicherintensive Prozesse:${NC}"
    ps aux --sort=-%mem | head -n 11
}

# Live-Logs anzeigen
show_logs() {
    local service
    service=$(select_service)
    [ -z "$service" ] && return
    
    echo -e "${YELLOW}Live-Logs für $service (STRG+C zum Beenden):${NC}"
    echo "========================================"
    sudo journalctl -u "$service" -f
}

# Service-Konfiguration
configure_services() {
    while true; do
        clear
        echo -e "${BLUE}Service-Konfiguration${NC}"
        echo "========================================"
        echo "Aktuelle Services:"
        
        for i in "${!SERVICES[@]}"; do
            echo "$((i+1)). ${SERVICES[i]}"
        done
        
        echo -e "\nOptionen:"
        echo "1) Service hinzufügen"
        echo "2) Service entfernen"
        echo "3) Zurücksetzen auf Standard"
        echo "4) Zurück zum Hauptmenü"
        echo
        
        read -p "Auswahl: " choice
        
        case $choice in
            1)
                read -p "Service-Name: " new_service
                if [ -n "$new_service" ]; then
                    SERVICES+=("$new_service")
                    echo -e "${GREEN}$new_service wurde hinzugefügt${NC}"
                fi
                ;;
            2)
                read -p "Zu entfernende Service-Nummer: " num
                if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le ${#SERVICES[@]} ]; then
                    removed="${SERVICES[$((num-1))]}"
                    unset SERVICES[$((num-1))]
                    SERVICES=("${SERVICES[@]}")
                    echo -e "${GREEN}$removed wurde entfernt${NC}"
                else
                    echo -e "${RED}Ungültige Eingabe${NC}"
                fi
                ;;
            3)
                SERVICES=("apache2" "mariadb" "tor" "sshd")
                echo -e "${GREEN}Services auf Standard zurückgesetzt${NC}"
                ;;
            4)
                return
                ;;
            *)
                echo -e "${RED}Ungültige Option${NC}"
                ;;
        esac
        
        read -p "Enter drücken um fortzufahren..."
    done
}

# Hauptprogramm
while true; do
    show_menu
    read -p "Auswahl: " choice
    
    case $choice in
        1) service_status ;;
        2) service_action start ;;
        3) service_action stop ;;
        4) service_action restart ;;
        5) service_action reload ;;
        6) restart_all ;;
        7) system_resources ;;
        8) clear_ram ;;
        9) network_info ;;
        10) process_monitor ;;
        11) show_logs ;;
        12) configure_services ;;
        13)
            echo -e "${GREEN}Beende...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Ungültige Auswahl${NC}"
            ;;
    esac
    
    if [[ ! "$choice" =~ ^(11|12)$ ]]; then
        echo -e "\n${BLUE}Enter drücken um fortzufahren...${NC}"
        read
    fi
done
