#!/bin/bash

# Docker Management Script
# This script provides a user-friendly interface for common Docker operations.
# Usage: ./docker_management.sh

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display the menu
show_menu() {
    echo -e "${YELLOW}============================="
    echo " Docker Management Menu"
    echo -e "=============================${NC}"
    echo "1. Container Operations"
    echo "2. Image Operations"
    echo "3. Network Operations"
    echo "4. Volume Operations"
    echo "5. System Information"
    echo "6. Help"
    echo "7. Exit"
    echo -e "${YELLOW}=============================${NC}"
}

# Function to execute docker commands
execute_docker_command() {
    local command=$1
    echo -e "${GREEN}Executing: $command${NC}"
    eval $command
    if [ $? -ne 0 ]; then
        echo -e "${RED}Command failed. Please check your input and try again.${NC}"
    fi
}

# Function to show help
show_help() {
    echo -e "${YELLOW}Docker Management Script Help${NC}"
    echo "This script provides an interface for common Docker operations."
    echo "Here are some examples of what you can do:"
    echo
    echo -e "${GREEN}Container Operations:${NC}"
    echo "- List running containers: docker ps"
    echo "- Start a container: docker start <container_id>"
    echo "- Stop a container: docker stop <container_id>"
    echo
    echo -e "${GREEN}Image Operations:${NC}"
    echo "- List images: docker images"
    echo "- Pull an image: docker pull <image_name>"
    echo "- Remove an image: docker rmi <image_id>"
    echo
    echo -e "${GREEN}Network Operations:${NC}"
    echo "- List networks: docker network ls"
    echo "- Inspect a network: docker network inspect <network_name>"
    echo
    echo -e "${GREEN}Volume Operations:${NC}"
    echo "- List volumes: docker volume ls"
    echo "- Inspect a volume: docker volume inspect <volume_name>"
}

# Main program
while true; do
    show_menu
    read -p "Choose an option: " choice
    case $choice in
        1) 
            echo "1. List Running Containers"
            echo "2. List All Containers"
            echo "3. Start a Container"
            echo "4. Stop a Container"
            read -p "Choose a container operation: " container_op
            case $container_op in
                1) execute_docker_command "docker ps" ;;
                2) execute_docker_command "docker ps -a" ;;
                3) 
                    read -p "Enter container ID to start: " container_id
                    execute_docker_command "docker start $container_id"
                    ;;
                4)
                    read -p "Enter container ID to stop: " container_id
                    execute_docker_command "docker stop $container_id"
                    ;;
                *) echo -e "${RED}Invalid choice${NC}" ;;
            esac
            ;;
        2)
            echo "1. List Images"
            echo "2. Pull an Image"
            echo "3. Remove an Image"
            read -p "Choose an image operation: " image_op
            case $image_op in
                1) execute_docker_command "docker images" ;;
                2)
                    read -p "Enter image name to pull: " image_name
                    execute_docker_command "docker pull $image_name"
                    ;;
                3)
                    read -p "Enter image ID to remove: " image_id
                    execute_docker_command "docker rmi $image_id"
                    ;;
                *) echo -e "${RED}Invalid choice${NC}" ;;
            esac
            ;;
        3)
            echo "1. List Networks"
            echo "2. Inspect a Network"
            read -p "Choose a network operation: " network_op
            case $network_op in
                1) execute_docker_command "docker network ls" ;;
                2)
                    read -p "Enter network name to inspect: " network_name
                    execute_docker_command "docker network inspect $network_name"
                    ;;
                *) echo -e "${RED}Invalid choice${NC}" ;;
            esac
            ;;
        4)
            echo "1. List Volumes"
            echo "2. Inspect a Volume"
            read -p "Choose a volume operation: " volume_op
            case $volume_op in
                1) execute_docker_command "docker volume ls" ;;
                2)
                    read -p "Enter volume name to inspect: " volume_name
                    execute_docker_command "docker volume inspect $volume_name"
                    ;;
                *) echo -e "${RED}Invalid choice${NC}" ;;
            esac
            ;;
        5)
            echo "1. Show Docker System Information"
            echo "2. Show Docker Version"
            read -p "Choose a system information option: " info_op
            case $info_op in
                1) execute_docker_command "docker info" ;;
                2) execute_docker_command "docker version" ;;
                *) echo -e "${RED}Invalid choice${NC}" ;;
            esac
            ;;
        6) show_help ;;
        7)
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
