#!/bin/bash

# Funktion zum Anzeigen des Menüs
show_menu() {
    echo "============================="
    echo " Entwickler-Toolbox Menü"
    echo "============================="
    echo "1. System-Update (apt-get update)"
    echo "2. System-Upgrade (apt-get upgrade)"
    echo "3. Autoclean (apt-get autoclean)"
    echo "4. RAM bereinigen"
    echo "5. Cache bereinigen"
    echo "6. Systeminformationen anzeigen"
    echo "7. Beenden"
    echo "============================="
}

# Funktion für System-Update
system_update() {
    echo "System-Update wird ausgeführt..."
    sudo apt-get update
}

# Funktion für System-Upgrade
system_upgrade() {
    echo "System-Upgrade wird ausgeführt..."
    sudo apt-get upgrade -y
}

# Funktion für Autoclean
autoclean() {
    echo "Autoclean wird ausgeführt..."
    sudo apt-get autoclean
}

# Funktion zum Bereinigen des RAM
clear_ram() {
    echo "RAM wird bereinigt..."
    sudo sync
    sudo sysctl -w vm.drop_caches=3
}

# Funktion zum Bereinigen des Cache
clear_cache() {
    echo "Cache wird bereinigt..."
    sudo sync
    echo 3 | sudo tee /proc/sys/vm/drop_caches
}

# Funktion zum Anzeigen von Systeminformationen
system_info() {
    echo "Systeminformationen:"
    uname -a
    lscpu
    free -h
    df -h
}

# Hauptprogramm
while true; do
    show_menu
    read -p "Wählen Sie eine Option: " choice
    case $choice in
        1)
            system_update
            ;;
        2)
            system_upgrade
            ;;
        3)
            autoclean
            ;;
        4)
            clear_ram
            ;;
        5)
            clear_cache
            ;;
        6)
            system_info
            ;;
        7)
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
