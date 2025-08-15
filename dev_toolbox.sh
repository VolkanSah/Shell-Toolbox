#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration file for this server's services
CONFIG_FILE="$HOME/.dev-toolbox-services"

# Default fallback services if no config exists
DEFAULT_SERVICES=(
    "apache2"
    "mariadb"
    "tor"
    "sshd"
)

load_services() {
    if [ -f "$CONFIG_FILE" ]; then
        mapfile -t SERVICES < "$CONFIG_FILE"
        echo -e "${GREEN}Loaded services from config file${NC}"
    else
        SERVICES=("${DEFAULT_SERVICES[@]}")
        echo -e "${YELLOW}No config file found, using defaults${NC}"
        echo -e "${YELLOW}You can configure services with option 12${NC}"
    fi
}

save_services() {
    printf '%s\n' "${SERVICES[@]}" > "$CONFIG_FILE"
    echo -e "${GREEN}Services saved to $CONFIG_FILE${NC}"
}

show_menu() {
    clear
    echo -e "${BLUE}======================================"
    echo "       Dev Server Toolbox"
    echo -e "======================================${NC}"
    echo "1.  Service Status Overview"
    echo "2.  Start Service"
    echo "3.  Stop Service"
    echo "4.  Restart Service"
    echo "5.  Reload Service"
    echo "6.  Restart All Active Services"
    echo "7.  System Resources"
    echo "8.  Clear RAM/Cache"
    echo "9.  Network Info"
    echo "10. Process Monitor"
    echo "11. Service Logs (Live)"
    echo "12. Configure Services"
    echo "13. Exit"
    echo -e "${BLUE}======================================${NC}"
    echo -e "${YELLOW}Current server services: ${#SERVICES[@]} configured${NC}"
}

execute_with_feedback() {
    echo -e "${YELLOW}Executing: $1${NC}"
    if eval $1; then
        echo -e "${GREEN}✓ Success${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed${NC}"
        return 1
    fi
}

list_available_services() {
    echo -e "${YELLOW}Configured services for this server:${NC}"
    local counter=1
    AVAILABLE_SERVICES=()
    
    for service in "${SERVICES[@]}"; do
        # Skip empty lines
        [ -z "$service" ] && continue
        
        if systemctl list-unit-files | grep -q "^$service"; then
            AVAILABLE_SERVICES+=("$service")
            status=$(systemctl is-active "$service" 2>/dev/null)
            enabled=$(systemctl is-enabled "$service" 2>/dev/null)
            
            if [ "$status" = "active" ]; then
                if [ "$enabled" = "enabled" ]; then
                    echo -e "$counter. ${service} ${GREEN}(active, enabled)${NC}"
                else
                    echo -e "$counter. ${service} ${GREEN}(active)${NC} ${YELLOW}(not enabled)${NC}"
                fi
            else
                if [ "$enabled" = "enabled" ]; then
                    echo -e "$counter. ${service} ${RED}(inactive)${NC} ${YELLOW}(enabled)${NC}"
                else
                    echo -e "$counter. ${service} ${RED}(inactive, disabled)${NC}"
                fi
            fi
            counter=$((counter + 1))
        else
            echo -e "$counter. ${service} ${RED}(not found on system)${NC}"
            counter=$((counter + 1))
        fi
    done
}

get_service_by_number() {
    local choice=$1
    local max_services=${#AVAILABLE_SERVICES[@]}
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$max_services" ]; then
        echo "${AVAILABLE_SERVICES[$((choice-1))]}"
        return 0
    else
        echo ""
        return 1
    fi
}

service_status_overview() {
    echo -e "${BLUE}Service Status Overview:${NC}"
    echo "===================================="
    local active_count=0
    local total_count=0
    
    for service in "${SERVICES[@]}"; do
        [ -z "$service" ] && continue
        
        if systemctl list-unit-files | grep -q "^$service"; then
            total_count=$((total_count + 1))
            if systemctl is-active --quiet "$service"; then
                echo -e "${service}: ${GREEN}● Active${NC}"
                active_count=$((active_count + 1))
            else
                echo -e "${service}: ${RED}○ Inactive${NC}"
            fi
        else
            echo -e "${service}: ${RED}✗ Not found${NC}"
        fi
    done
    echo
    echo -e "${BLUE}Summary: ${active_count}/${total_count} services active${NC}"
}

# Generic service operation function
service_operation() {
    local operation=$1
    local operation_name=$2
    
    list_available_services
    echo
    read -p "Enter service number: " choice
    
    service=$(get_service_by_number "$choice")
    if [ -z "$service" ]; then
        echo -e "${RED}Invalid selection${NC}"
        return 1
    fi
    
    case $operation in
        "start")
            execute_with_feedback "sudo systemctl start $service"
            if ! systemctl is-enabled --quiet "$service" 2>/dev/null; then
                echo -e "${YELLOW}Service is not enabled for auto-start.${NC}"
                read -p "Enable for auto-start on boot? (y/n): " enable_choice
                if [[ "$enable_choice" =~ ^[yY]$ ]]; then
                    execute_with_feedback "sudo systemctl enable $service"
                fi
            fi
            ;;
        *)
            execute_with_feedback "sudo systemctl $operation $service"
            ;;
    esac
}

restart_all_active() {
    echo -e "${YELLOW}Restarting all active services...${NC}"
    local restarted_count=0
    
    for service in "${SERVICES[@]}"; do
        [ -z "$service" ] && continue
        
        if systemctl is-active --quiet "$service"; then
            echo -e "Restarting ${service}..."
            if execute_with_feedback "sudo systemctl restart $service"; then
                restarted_count=$((restarted_count + 1))
            fi
        fi
    done
    
    echo -e "${GREEN}Restarted $restarted_count services${NC}"
}

system_resources() {
    echo -e "${BLUE}System Resources:${NC}"
    echo "===================="
    echo -e "${YELLOW}Memory:${NC}"
    free -h
    echo
    echo -e "${YELLOW}Disk Usage:${NC}"
    df -h | head -n 10
    echo
    echo -e "${YELLOW}CPU & Load:${NC}"
    uptime
    echo
    echo -e "${YELLOW}Top processes:${NC}"
    top -bn1 | head -n 8
}

clear_system() {
    echo -e "${YELLOW}Clearing system caches...${NC}"
    execute_with_feedback "sudo sync"
    execute_with_feedback "echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null"
    echo -e "${GREEN}✓ RAM and cache cleared${NC}"
}

network_info() {
    echo -e "${BLUE}Network Information:${NC}"
    echo "====================="
    echo -e "${YELLOW}Active connections:${NC}"
    ss -tuln | head -n 10
    echo
    echo -e "${YELLOW}Network interfaces:${NC}"
    ip -br addr show
}

process_monitor() {
    echo -e "${BLUE}Process Monitor:${NC}"
    echo "=================="
    echo "Top processes by CPU:"
    ps aux --sort=-%cpu | head -n 11
    echo
    echo "Top processes by Memory:"
    ps aux --sort=-%mem | head -n 11
}

service_logs_live() {
    list_available_services
    echo
    read -p "Enter service number: " choice
    
    service=$(get_service_by_number "$choice")
    if [ -z "$service" ]; then
        echo -e "${RED}Invalid selection${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}Live logs for $service (Ctrl+C to exit):${NC}"
    echo "========================================="
    sudo journalctl -u $service -f
}

configure_services() {
    while true; do
        clear
        echo -e "${BLUE}Service Configuration${NC}"
        echo "====================="
        echo "Current services:"
        for i in "${!SERVICES[@]}"; do
            echo "$((i+1)). ${SERVICES[i]}"
        done
        echo
        echo "Options:"
        echo "a) Add service"
        echo "d) Delete service by number"
        echo "r) Reset to defaults"
        echo "s) Save and return"
        echo "q) Return without saving"
        echo
        
        read -p "Choose option: " config_choice
        
        case $config_choice in
            a|A)
                read -p "Enter service name: " new_service
                if [ -n "$new_service" ]; then
                    SERVICES+=("$new_service")
                    echo -e "${GREEN}Added: $new_service${NC}"
                fi
                ;;
            d|D)
                read -p "Enter service number to delete: " del_num
                if [[ "$del_num" =~ ^[0-9]+$ ]] && [ "$del_num" -ge 1 ] && [ "$del_num" -le "${#SERVICES[@]}" ]; then
                    removed="${SERVICES[$((del_num-1))]}"
                    unset 'SERVICES[$((del_num-1))]'
                    SERVICES=("${SERVICES[@]}")  # Reindex array
                    echo -e "${GREEN}Removed: $removed${NC}"
                else
                    echo -e "${RED}Invalid number${NC}"
                fi
                ;;
            r|R)
                SERVICES=("${DEFAULT_SERVICES[@]}")
                echo -e "${GREEN}Reset to defaults${NC}"
                ;;
            s|S)
                save_services
                break
                ;;
            q|Q)
                load_services  # Reload from file
                break
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                ;;
        esac
        
        if [[ "$config_choice" =~ ^[adAD]$ ]]; then
            read -p "Press Enter to continue..." 
        fi
    done
}

# Initialize
load_services

# Main loop
while true; do
    show_menu
    read -p "Choose an option: " choice
    
    case $choice in
        1) service_status_overview ;;
        2) service_operation "start" "Start" ;;
        3) service_operation "stop" "Stop" ;;
        4) service_operation "restart" "Restart" ;;
        5) service_operation "reload" "Reload" ;;
        6) restart_all_active ;;
        7) system_resources ;;
        8) clear_system ;;
        9) network_info ;;
        10) process_monitor ;;
        11) service_logs_live ;;
        12) configure_services ;;
        13) 
            echo -e "${GREEN}Exiting...${NC}"
            exit 0 
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            ;;
    esac
    
    if [ "$choice" != "11" ] && [ "$choice" != "12" ]; then
        echo
        echo -e "${BLUE}Press Enter to continue...${NC}"
        read
    fi
done
