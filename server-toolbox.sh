# Shell server-toolbox
# by Volkan sah
#!/bin/bash

# Farbdefinitionen
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Globale Service-Liste
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
    echo "       Dev Server Toolbox v2.1"
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
    for i in "${!SERVICES[@]}"; do
        service="${SERVICES[$i]}"
        if systemctl list-unit-files | grep -q "^$service"; then
            status=$(systemctl is-active "$service" 2>/dev/null)
            enabled=$(systemctl is-enabled "$service" 2>/dev/null)
            
            # Statusanzeige mit Farben
            if [ "$status" = "active" ]; then
                status_color="${GREEN}"
            else
                status_color="${RED}"
            fi
            
            # Aktivierungsstatus
            if [ "$enabled" = "enabled" ]; then
                enabled_text=", aktiviert"
            else
                enabled_text=", deaktiviert"
            fi
            
            echo -e "$(($i+1)). ${status_color}${service}${NC} (${status}${enabled_text})"
        else
            echo -e "$(($i+1)). ${RED}${service} (nicht gefunden!)${NC}"
        fi
    done
}

# Funktion zur Auswahl eines Services mit sichtbarer Liste
select_service() {
    while true; do
        clear
        echo -e "${BLUE}========== Service-Auswahl ==========${NC}"
        list_services
        echo
        read -p "Service-Nummer auswählen (0 zum Abbrechen): " choice
        
        # Abbruch
        if [ "$choice" == "0" ]; then
            return 1
        fi
        
        # Eingabe validieren
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#SERVICES[@]} ]; then
            selected_service="${SERVICES[$((choice-1))]}"
            echo "$selected_service"
            return 0
        else
            echo -e "${RED}Ungültige Auswahl! Bitte Nummer zwischen 1-${#SERVICES[@]} eingeben.${NC}"
            sleep 2
        fi
    done
}

# Service-Status Übersicht
service_status() {
    clear
    echo -e "${BLUE}========== Service-Status ==========${NC}"
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
    local action_name=$2
    
    service=$(select_service)
    if [ -z "$service" ]; then
        echo -e "${YELLOW}Abgebrochen.${NC}"
        return
    fi
    
    case "$action" in
        start)
            execute_with_feedback "sudo systemctl start $service"
            if ! systemctl is-enabled "$service" &>/dev/null; then
                echo -e "${YELLOW}Service ist nicht aktiviert.${NC}"
                read -p "Autostart aktivieren? (j/n): " choice
                if [[ "$choice" =~ ^[jJ]$ ]]; then
                    execute_with_feedback "sudo systemctl enable $service"
                fi
            fi
            ;;
        *)
            execute_with_feedback "sudo systemctl $action $service"
            ;;
    esac
}

# Alle aktiven Services neustarten
restart_all() {
    clear
    echo -e "${YELLOW}========== Starte alle aktiven Services neu ==========${NC}"
    local count=0
    
    for service in "${SERVICES[@]}"; do
        if systemctl is-active "$service" &>/dev/null; then
            echo -e "Neustart: $service..."
            if execute_with_feedback "sudo systemctl restart $service"; then
                ((count++))
            fi
        fi
    done
    
    echo -e "${GREEN}\n$count Services wurden neu gestartet${NC}"
}

# Systemressourcen anzeigen
system_resources() {
    clear
    echo -e "${BLUE}========== Systemressourcen ==========${NC}"
    
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
    clear
    echo -e "${YELLOW}========== Leere Systemcache ==========${NC}"
    execute_with_feedback "sudo sync"
    execute_with_feedback "sudo sysctl vm.drop_caches=3"
    echo -e "${GREEN}✓ RAM und Cache wurden geleert${NC}"
}

# Netzwerkinformationen
network_info() {
    clear
    echo -e "${BLUE}========== Netzwerkinformationen ==========${NC}"
    
    echo -e "${YELLOW}Aktive Verbindungen:${NC}"
    ss -tuln
    
    echo -e "\n${YELLOW}Netzwerkinterfaces:${NC}"
    ip -br addr show
}

# Prozessmonitor
process_monitor() {
    clear
    echo -e "${BLUE}========== Prozessmonitor ==========${NC}"
    
    echo -e "${YELLOW}CPU-intensive Prozesse:${NC}"
    ps aux --sort=-%cpu | head -n 11
    
    echo -e "\n${YELLOW}Speicherintensive Prozesse:${NC}"
    ps aux --sort=-%mem | head -n 11
}

# Live-Logs anzeigen
show_logs() {
    service=$(select_service)
    if [ -z "$service" ]; then
        echo -e "${YELLOW}Abgebrochen.${NC}"
        return
    fi
    
    clear
    echo -e "${YELLOW}========== Live-Logs für $service ==========${NC}"
    echo -e "${BLUE}(STRG+C zum Beenden)${NC}"
    echo "========================================"
    sudo journalctl -u "$service" -f
}

# Service-Konfiguration
configure_services() {
    while true; do
        clear
        echo -e "${BLUE}========== Service-Konfiguration ==========${NC}"
        echo "Aktuelle Services:"
        
        for i in "${!SERVICES[@]}"; do
            echo "$(($i+1)). ${SERVICES[$i]}"
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
                    sleep 1
                fi
                ;;
            2)
                read -p "Zu entfernende Service-Nummer: " num
                if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le ${#SERVICES[@]} ]; then
                    removed="${SERVICES[$((num-1))]}"
                    unset "SERVICES[$((num-1))]"
                    SERVICES=("${SERVICES[@]}")
                    echo -e "${GREEN}$removed wurde entfernt${NC}"
                    sleep 1
                else
                    echo -e "${RED}Ungültige Eingabe!${NC}"
                    sleep 1
                fi
                ;;
            3)
                SERVICES=("apache2" "mariadb" "tor" "sshd")
                echo -e "${GREEN}Services auf Standard zurückgesetzt${NC}"
                sleep 1
                ;;
            4)
                return
                ;;
            *)
                echo -e "${RED}Ungültige Option!${NC}"
                sleep 1
                ;;
        esac
    done
}

# Hauptprogramm
while true; do
    show_menu
    read -p "Auswahl: " choice
    
    case $choice in
        1) service_status ;;
        2) service_action start "Starten" ;;
        3) service_action stop "Stoppen" ;;
        4) service_action restart "Neustarten" ;;
        5) service_action reload "Neu laden" ;;
        6) restart_all ;;
        7) system_resources ;;
        8) clear_ram ;;
        9) network_info ;;
        10) process_monitor ;;
        11) show_logs ;;
        12) configure_services ;;
        13)
            clear
            echo -e "${GREEN}Beende...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Ungültige Auswahl!${NC}"
            sleep 1
            ;;
    esac
    
    # Bei den meisten Optionen auf Eingabe warten
    if [[ ! "$choice" =~ ^(11|12)$ ]]; then
        echo
        read -p "Enter drücken um fortzufahren..."
    fi
done
