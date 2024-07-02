#!/bin/bash

# Funktion zum Anzeigen des Menüs
show_menu() {
    echo "============================="
    echo " Docker-Verwaltungsmenü"
    echo "============================="
    echo "1. Docker-Systeminformationen anzeigen (docker info)"
    echo "2. Docker-Version anzeigen (docker version)"
    echo "3. Laufende Container auflisten (docker ps)"
    echo "4. Alle Container auflisten (docker ps -a)"
    echo "5. Einen Container starten (docker start <container_id>)"
    echo "6. Einen Container stoppen (docker stop <container_id>)"
    echo "7. Einen Container neu starten (docker restart <container_id>)"
    echo "8. Einen Container entfernen (docker rm <container_id>)"
    echo "9. Docker-Images auflisten (docker images)"
    echo "10. Ein Docker-Image entfernen (docker rmi <image_id>)"
    echo "11. Ein Docker-Image herunterladen (docker pull <image_name>)"
    echo "12. Ein Docker-Image bauen (docker build -t <image_name> <path>)"
    echo "13. Container-Logs anzeigen (docker logs <container_id>)"
    echo "14. Befehl in einem Container ausführen (docker exec -it <container_id> <command>)"
    echo "15. Docker-Netzwerke auflisten (docker network ls)"
    echo "16. Ein Docker-Netzwerk inspizieren (docker network inspect <network_name>)"
    echo "17. Docker-Volumes auflisten (docker volume ls)"
    echo "18. Ein Docker-Volume inspizieren (docker volume inspect <volume_name>)"
    echo "19. Beenden"
    echo "============================="
}

# Funktion zum Ausführen von Docker-Befehlen
execute_docker_command() {
    local command=$1
    echo "Ausführen: $command"
    eval $command
}

# Hauptprogramm
while true; do
    show_menu
    read -p "Wählen Sie eine Option: " choice
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
            read -p "Geben Sie die Container-ID zum Starten ein: " container_id
            execute_docker_command "docker start $container_id"
            ;;
        6)
            read -p "Geben Sie die Container-ID zum Stoppen ein: " container_id
            execute_docker_command "docker stop $container_id"
            ;;
        7)
            read -p "Geben Sie die Container-ID zum Neustarten ein: " container_id
            execute_docker_command "docker restart $container_id"
            ;;
        8)
            read -p "Geben Sie die Container-ID zum Entfernen ein: " container_id
            execute_docker_command "docker rm $container_id"
            ;;
        9)
            execute_docker_command "docker images"
            ;;
        10)
            read -p "Geben Sie die Image-ID zum Entfernen ein: " image_id
            execute_docker_command "docker rmi $image_id"
            ;;
        11)
            read -p "Geben Sie den Image-Namen zum Herunterladen ein: " image_name
            execute_docker_command "docker pull $image_name"
            ;;
        12)
            read -p "Geben Sie den Image-Namen zum Bauen ein: " image_name
            read -p "Geben Sie den Pfad zur Dockerfile ein: " path
            execute_docker_command "docker build -t $image_name $path"
            ;;
        13)
            read -p "Geben Sie die Container-ID zum Anzeigen der Logs ein: " container_id
            execute_docker_command "docker logs $container_id"
            ;;
        14)
            read -p "Geben Sie die Container-ID ein: " container_id
            read -p "Geben Sie den auszuführenden Befehl ein: " command
            execute_docker_command "docker exec -it $container_id $command"
            ;;
        15)
            execute_docker_command "docker network ls"
            ;;
        16)
            read -p "Geben Sie den Netzwerk-Namen zum Inspizieren ein: " network_name
            execute_docker_command "docker network inspect $network_name"
            ;;
        17)
            execute_docker_command "docker volume ls"
            ;;
        18)
            read -p "Geben Sie den Volume-Namen zum Inspizieren ein: " volume_name
            execute_docker_command "docker volume inspect $volume_name"
            ;;
        19)
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
