#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Common services array - customize as needed
SERVICES=(
    "nginx"
    "apache2"
    "mysql" 
    "mariadb"
    "postgresql"
    "redis-server"
    "php7.4-fpm"
    "php8.0-fpm"
    "php8.1-fmp"
    "docker"
    "elasticsearch"
    "memcached"
)

show_menu() {
    clear
    echo -e "${BLUE}======================================"
    echo "       Dev Server Toolbox"
    echo -e "======================================${NC}"
    echo "1.  Service Status Overview"
    echo "2.  Start Service"
    echo "3.  Stop Service" 
    echo "4.  Restart Service"
    echo "5.  Restart All Active Services"
    echo "6.  System Resources"
    echo "7.  Clear RAM/Cache"
    echo "8.  Network Info"
    echo "9.  Process Monitor"
    echo "10. Service Logs"
    echo "11. Exit"
    echo -e "${BLUE}======================================${NC}"
}

execute_with_feedback() {
    echo -e "${YELLOW}Executing: $1${NC}"
    if eval $1; then
        echo -e "${GREEN}✓ Success${NC}"
    else
        echo -e "${RED}✗ Failed${NC}"
    fi
}

service_status_overview() {
    echo -e "${BLUE}Service Status Overview:${NC}"
    echo "=================================="
    for service in "${SERVICES[@]}"; do
        if systemctl list-unit-files | grep -q "^$service"; then
            if systemctl is-active --quiet "$service"; then
                echo -e "${service}: ${GREEN}●${NC} Active"
            else
                echo -e "${service}: ${RED}○${NC} Inactive"
            fi
        fi
    done
}

list_available_services() {
    echo -e "${YELLOW}Available services:${NC}"
    local counter=1
    AVAILABLE_SERVICES=()
    
    for service in "${SERVICES[@]}"; do
        if systemctl list-unit-files | grep -q "^$service"; then
            AVAILABLE_SERVICES+=("$service")
            status=$(systemctl is-active "$service" 2>/dev/null)
            if [ "$status" = "active" ]; then
                echo -e "$counter. ${service} ${GREEN}(running)${NC}"
            else
                echo -e "$counter. ${service} ${RED}(stopped)${NC}"
            fi
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

start_service() {
    list_available_services
    echo
    read -p "Enter service number: " choice
    
    service=$(get_service_by_number "$choice")
    if [ -z "$service" ]; then
        echo -e "${RED}Invalid selection${NC}"
        return 1
    fi
    
    execute_with_feedback "sudo systemctl start $service"
    
    if ! systemctl is-enabled --quiet "$service" 2>/dev/null; then
        echo -e "${YELLOW}Service is not enabled for auto-start.${NC}"
        read -p "Enable for auto-start on boot? (y/n): " enable_choice
        if [ "$enable_choice" = "y" ] || [ "$enable_choice" = "Y" ]; then
            execute_with_feedback "sudo systemctl enable $service"
        fi
    fi
}

stop_service() {
    list_available_services
    echo
    read -p "Enter service number: " choice
    
    service=$(get_service_by_number "$choice")
    if [ -z "$service" ]; then
        echo -e "${RED}Invalid selection${NC}"
        return 1
    fi
    
    execute_with_feedback "sudo systemctl stop $service"
}

restart_service() {
    list_available_services
    echo
    read -p "Enter service number: " choice
    
    service=$(get_service_by_number "$choice")
    if [ -z "$service" ]; then
        echo -e "${RED}Invalid selection${NC}"
        return 1
    fi
    
    execute_with_feedback "sudo systemctl restart $service"
}

restart_all_active() {
    echo -e "${YELLOW}Restarting all active services...${NC}"
    for service in "${SERVICES[@]}"; do
        if systemctl is-active --quiet "$service"; then
            echo -e "Restarting ${service}..."
            execute_with_feedback "sudo systemctl restart $service"
        fi
    done
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
    echo -e "${YELLOW}CPU Info:${NC}"
    top -bn1 | head -n 5
    echo
    echo -e "${YELLOW}Load Average:${NC}"
    uptime
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
    echo "Top 10 processes by CPU usage:"
    ps aux --sort=-%cpu | head -n 11
    echo
    echo "Top 10 processes by Memory usage:"
    ps aux --sort=-%mem | head -n 11
}

service_logs() {
    list_available_services
    echo
    read -p "Enter service number: " choice
    
    service=$(get_service_by_number "$choice")
    if [ -z "$service" ]; then
        echo -e "${RED}Invalid selection${NC}"
        return 1
    fi
    
    read -p "Number of lines (default 50): " lines
    lines=${lines:-50}
    
    echo -e "${YELLOW}Last $lines lines from $service:${NC}"
    sudo journalctl -u $service -n $lines --no-pager
}

# Main loop
while true; do
    show_menu
    read -p "Choose an option: " choice
    
    case $choice in
        1) service_status_overview ;;
        2) start_service ;;
        3) stop_service ;;
        4) restart_service ;;
        5) restart_all_active ;;
        6) system_resources ;;
        7) clear_system ;;
        8) network_info ;;
        9) process_monitor ;;
        10) service_logs ;;
        11) 
            echo -e "${GREEN}Exiting...${NC}"
            exit 0 
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            ;;
    esac
    
    echo
    echo -e "${BLUE}Press Enter to continue...${NC}"
    read
done
