#!/bin/bash
# Developer's Server Toolbox
# A lightweight, interactive Bash tool for managing and monitoring Linux servers.
# Version 2.1
# https://github.com/VolkanSah/Dev-Server-Toolbox/
# Copyright (C) 2008 - 2025 Volkan Kücükbudak
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# Color Definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Global list of services (can be modified in the menu for temp)
SERVICES=(
    "apache2"
    "mariadb"
    "tor"
    "ssh" # On most Debian/Ubuntu systems, the service is called 'ssh'
)

# Function to display the main menu
show_menu() {
    clear
    echo -e "${BLUE}========================================"
    echo "          Dev Server Toolbox v2.1"
    echo -e "========================================${NC}"
    echo "1.  Service Status Overview"
    echo "2.  Start Service"
    echo "3.  Stop Service"
    echo "4.  Restart Service"
    echo "5.  Reload Service"
    echo "6.  Restart All Active Services"
    echo "7.  Show System Resources"
    echo "8.  Clear RAM/Cache"
    echo "9.  Network Information"
    echo "10. Process Monitor"
    echo "11. View Service Logs (Live)"
    echo "12. Configure Services"
    echo "13. Exit"
    echo -e "${BLUE}========================================${NC}"
    echo -e "${YELLOW}Currently monitoring ${#SERVICES[@]} services${NC}"
}

# Function for command execution with feedback
execute_with_feedback() {
    echo -e "${YELLOW}Executing: $1${NC}"
    if eval "$1"; then
        echo -e "${GREEN}✓ Success${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed${NC}"
        return 1
    fi
}

# Function to list available services with status
list_services() {
    echo -e "${YELLOW}Available Services:${NC}"
    for i in "${!SERVICES[@]}"; do
        service="${SERVICES[$i]}"
        if systemctl list-unit-files | grep -q "^$service.service"; then
            status=$(systemctl is-active "$service" 2>/dev/null)
            enabled=$(systemctl is-enabled "$service" 2>/dev/null)
            
            # Status display with colors
            if [ "$status" = "active" ]; then
                status_color="${GREEN}"
            else
                status_color="${RED}"
            fi
            
            # Enabled/disabled text
            if [ "$enabled" = "enabled" ]; then
                enabled_text=", enabled"
            else
                enabled_text=", disabled"
            fi
            
            echo -e "$((i+1)). ${status_color}${service}${NC} (${status}${enabled_text})"
        else
            echo -e "$((i+1)). ${RED}${service} (not found!)${NC}"
        fi
    done
}

# Function to show a clear status overview
service_status() {
    clear
    echo -e "${BLUE}========== Service Status ==========${NC}"
    local active_count=0
    
    for service in "${SERVICES[@]}"; do
        if systemctl list-unit-files | grep -q "^$service.service"; then
            status=$(systemctl is-active "$service" 2>/dev/null)
            
            if [ "$status" = "active" ]; then
                echo -e "${GREEN}● $service (active)${NC}"
                ((active_count++))
            else
                echo -e "${RED}○ $service (inactive)${NC}"
            fi
        else
            echo -e "${RED}✗ $service (not installed)${NC}"
        fi
    done
    
    echo -e "${BLUE}\nSummary: $active_count of ${#SERVICES[@]} services are active${NC}"
}

# Function to perform a service action (start, stop, etc.)
service_action() {
    local action=$1
    
    clear
    echo -e "${BLUE}========== Select Service for Action: '$action' ==========${NC}"
    list_services
    echo
    
    read -p "Select service number (0 to cancel): " choice
    
    if [[ "$choice" == "0" ]]; then
        echo -e "${YELLOW}Action canceled.${NC}"
        return
    fi
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#SERVICES[@]} ]; then
        local selected_service="${SERVICES[$((choice-1))]}"
        echo

        case "$action" in
            start)
                execute_with_feedback "sudo systemctl start $selected_service"
                if ! systemctl is-enabled "$selected_service" &>/dev/null; then
                    echo -e "${YELLOW}Service is not enabled on boot.${NC}"
                    read -p "Enable on boot now? (y/n): " enable_choice
                    if [[ "$enable_choice" =~ ^[yY]$ ]]; then
                        execute_with_feedback "sudo systemctl enable $selected_service"
                    fi
                fi
                ;;
            *)
                execute_with_feedback "sudo systemctl $action $selected_service"
                ;;
        esac
    else
        echo -e "${RED}Invalid selection!${NC}"
    fi
}

# Function to restart all active services
restart_all() {
    clear
    echo -e "${YELLOW}========== Restarting All Active Services ==========${NC}"
    local count=0
    
    for service in "${SERVICES[@]}"; do
        if systemctl is-active "$service" &>/dev/null; then
            echo -e "Restarting: $service..."
            if execute_with_feedback "sudo systemctl restart $service"; then
                ((count++))
            fi
        fi
    done
    
    echo -e "${GREEN}\n$count services were restarted.${NC}"
}

# Function to show system resources
system_resources() {
    clear
    echo -e "${BLUE}========== System Resources ==========${NC}"
    
    echo -e "${YELLOW}Memory Usage:${NC}"
    free -h
    
    echo -e "\n${YELLOW}Disk Usage:${NC}"
    df -h | head -n 10
    
    echo -e "\n${YELLOW}CPU & Load Average:${NC}"
    uptime
    
    echo -e "\n${YELLOW}Top Processes:${NC}"
    top -bn1 | head -n 8
}

# Function to clear RAM and cache
clear_ram() {
    clear
    echo -e "${YELLOW}========== Clearing System Cache ==========${NC}"
    execute_with_feedback "sudo sync"
    execute_with_feedback "sudo sysctl vm.drop_caches=3"
    echo -e "${GREEN}✓ RAM and Cache have been cleared.${NC}"
}

# Function to show network information
network_info() {
    clear
    echo -e "${BLUE}========== Network Information ==========${NC}"
    
    echo -e "${YELLOW}Active Connections:${NC}"
    ss -tuln
    
    echo -e "\n${YELLOW}Network Interfaces:${NC}"
    ip -br addr show
}

# Function to monitor processes
process_monitor() {
    clear
    echo -e "${BLUE}========== Process Monitor ==========${NC}"
    
    echo -e "${YELLOW}CPU-Intensive Processes:${NC}"
    ps aux --sort=-%cpu | head -n 11
    
    echo -e "\n${YELLOW}Memory-Intensive Processes:${NC}"
    ps aux --sort=-%mem | head -n 11
}

# Function to show live logs for a service
show_logs() {
    clear
    echo -e "${BLUE}========== Select Service to View Logs ==========${NC}"
    list_services
    echo
    read -p "Select service number (0 to cancel): " choice
    
    if [[ "$choice" == "0" ]]; then echo -e "${YELLOW}Action canceled.${NC}"; return; fi

    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#SERVICES[@]} ]; then
        local service="${SERVICES[$((choice-1))]}"
        clear
        echo -e "${YELLOW}========== Live Logs for: $service ==========${NC}"
        echo -e "${BLUE}(Press CTRL+C to exit)${NC}"
        echo "========================================"
        sudo journalctl -u "$service" -f
    else
        echo -e "${RED}Invalid selection!${NC}"
    fi
}

# Function to configure the service list
configure_services() {
    while true; do
        clear
        echo -e "${BLUE}========== Configure Services ==========${NC}"
        echo "Current Services:"
        
        for i in "${!SERVICES[@]}"; do
            echo "$((i+1)). ${SERVICES[$i]}"
        done
        
        echo -e "\nOptions:"
        echo "1) Add Service"
        echo "2) Remove Service"
        echo "3) Reset to Default"
        echo "4) Back to Main Menu"
        echo
        
        read -p "Selection: " choice
        
        case $choice in
            1)
                read -p "Enter service name: " new_service
                if [ -n "$new_service" ]; then
                    SERVICES+=("$new_service")
                    echo -e "${GREEN}'$new_service' has been added.${NC}"
                    sleep 1
                fi
                ;;
            2)
                read -p "Enter number of service to remove: " num
                if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le ${#SERVICES[@]} ]; then
                    local removed="${SERVICES[$((num-1))]}"
                    unset "SERVICES[$((num-1))]"
                    SERVICES=("${SERVICES[@]}") # Re-index the array
                    echo -e "${GREEN}'$removed' has been removed.${NC}"
                    sleep 1
                else
                    echo -e "${RED}Invalid number!${NC}"
                    sleep 1
                fi
                ;;
            3)
                SERVICES=("apache2" "mariadb" "tor" "ssh")
                echo -e "${GREEN}Service list has been reset to default.${NC}"
                sleep 1
                ;;
            4)
                return
                ;;
            *)
                echo -e "${RED}Invalid option!${NC}"
                sleep 1
                ;;
        esac
    done
}

# Main program loop
while true; do
    show_menu
    read -p "Choose an option: " choice
    
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
            clear
            echo -e "${GREEN}Exiting...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option!${NC}"
            sleep 1
            ;;
    esac
    
    # Wait for user input on most actions before returning to menu
    if [[ ! "$choice" =~ ^(11|12|13)$ ]]; then
        echo
        read -p "Press Enter to continue..."
    fi
done
