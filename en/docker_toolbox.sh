#!/bin/bash

# Function to display the menu
show_menu() {
    echo "============================="
    echo " Docker Management Menu"
    echo "============================="
    echo "1. Show Docker System Information (docker info)"
    echo "2. Show Docker Version (docker version)"
    echo "3. List Running Containers (docker ps)"
    echo "4. List All Containers (docker ps -a)"
    echo "5. Start a Container (docker start <container_id>)"
    echo "6. Stop a Container (docker stop <container_id>)"
    echo "7. Restart a Container (docker restart <container_id>)"
    echo "8. Remove a Container (docker rm <container_id>)"
    echo "9. List Docker Images (docker images)"
    echo "10. Remove a Docker Image (docker rmi <image_id>)"
    echo "11. Pull a Docker Image (docker pull <image_name>)"
    echo "12. Build a Docker Image (docker build -t <image_name> <path>)"
    echo "13. Show Container Logs (docker logs <container_id>)"
    echo "14. Execute Command in Container (docker exec -it <container_id> <command>)"
    echo "15. List Docker Networks (docker network ls)"
    echo "16. Inspect a Docker Network (docker network inspect <network_name>)"
    echo "17. List Docker Volumes (docker volume ls)"
    echo "18. Inspect a Docker Volume (docker volume inspect <volume_name>)"
    echo "19. Exit"
    echo "============================="
}

# Function to execute docker commands
execute_docker_command() {
    local command=$1
    echo "Executing: $command"
    eval $command
}

# Main program
while true; do
    show_menu
    read -p "Choose an option: " choice
    case $choice in
        1)
            execute_docker_command "docker info"
            ;;
        2)
            execute_docker_command "docker version"
            ;;
        3)
            execute_docker_command "docker ps"
            ;;
        4)
            execute_docker_command "docker ps -a"
            ;;
        5)
            read -p "Enter container ID to start: " container_id
            execute_docker_command "docker start $container_id"
            ;;
        6)
            read -p "Enter container ID to stop: " container_id
            execute_docker_command "docker stop $container_id"
            ;;
        7)
            read -p "Enter container ID to restart: " container_id
            execute_docker_command "docker restart $container_id"
            ;;
        8)
            read -p "Enter container ID to remove: " container_id
            execute_docker_command "docker rm $container_id"
            ;;
        9)
            execute_docker_command "docker images"
            ;;
        10)
            read -p "Enter image ID to remove: " image_id
            execute_docker_command "docker rmi $image_id"
            ;;
        11)
            read -p "Enter image name to pull: " image_name
            execute_docker_command "docker pull $image_name"
            ;;
        12)
            read -p "Enter image name to build: " image_name
            read -p "Enter path to Dockerfile: " path
            execute_docker_command "docker build -t $image_name $path"
            ;;
        13)
            read -p "Enter container ID to show logs: " container_id
            execute_docker_command "docker logs $container_id"
            ;;
        14)
            read -p "Enter container ID: " container_id
            read -p "Enter command to execute: " command
            execute_docker_command "docker exec -it $container_id $command"
            ;;
        15)
            execute_docker_command "docker network ls"
            ;;
        16)
            read -p "Enter network name to inspect: " network_name
            execute_docker_command "docker network inspect $network_name"
            ;;
        17)
            execute_docker_command "docker volume ls"
            ;;
        18)
            read -p "Enter volume name to inspect: " volume_name
            execute_docker_command "docker volume inspect $volume_name"
            ;;
        19)
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
