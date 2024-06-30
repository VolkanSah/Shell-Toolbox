#!/bin/bash

# Menü gösterim fonksiyonu
show_menu() {
    echo "============================="
    echo " Geliştirici Araç Kutusu Menüsü"
    echo "============================="
    echo "1. Sistem Güncellemesi (apt-get update)"
    echo "2. Sistem Yükseltmesi (apt-get upgrade)"
    echo "3. Autoclean (apt-get autoclean)"
    echo "4. RAM Temizle"
    echo "5. Önbelleği Temizle"
    echo "6. Sistem Bilgilerini Göster"
    echo "7. Çıkış"
    echo "============================="
}

# Sistem güncelleme fonksiyonu
system_update() {
    echo "Sistem güncellemesi yapılıyor..."
    sudo apt-get update
}

# Sistem yükseltme fonksiyonu
system_upgrade() {
    echo "Sistem yükseltmesi yapılıyor..."
    sudo apt-get upgrade -y
}

# Autoclean fonksiyonu
autoclean() {
    echo "Autoclean yapılıyor..."
    sudo apt-get autoclean
}

# RAM temizleme fonksiyonu
clear_ram() {
    echo "RAM temizleniyor..."
    sudo sync
    sudo sysctl -w vm.drop_caches=3
}

# Önbelleği temizleme fonksiyonu
clear_cache() {
    echo "Önbellek temizleniyor..."
    sudo sync
    echo 3 | sudo tee /proc/sys/vm/drop_caches
}

# Sistem bilgilerini gösterme fonksiyonu
system_info() {
    echo "Sistem Bilgileri:"
    uname -a
    lscpu
    free -h
    df -h
}

# Ana program
while true; do
    show_menu
    read -p "Bir seçenek seçin: " choice
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
            echo "Programdan çıkılıyor."
            break
            ;;
        *)
            echo "Geçersiz seçim, lütfen tekrar deneyin."
            ;;
    esac
    echo "Menüye dönmek için herhangi bir tuşa basın..."
    read -n 1
done
