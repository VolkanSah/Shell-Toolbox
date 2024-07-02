#!/bin/bash

# Menü gösterim fonksiyonu
show_menu() {
    echo "============================="
    echo " Docker Yönetim Menüsü"
    echo "============================="
    echo "1. Docker Sistem Bilgilerini Göster (docker info)"
    echo "2. Docker Sürümünü Göster (docker version)"
    echo "3. Çalışan Konteynerleri Listele (docker ps)"
    echo "4. Tüm Konteynerleri Listele (docker ps -a)"
    echo "5. Bir Konteyner Başlat (docker start <container_id>)"
    echo "6. Bir Konteyner Durdur (docker stop <container_id>)"
    echo "7. Bir Konteyner Yeniden Başlat (docker restart <container_id>)"
    echo "8. Bir Konteyner Kaldır (docker rm <container_id>)"
    echo "9. Docker İmajlarını Listele (docker images)"
    echo "10. Bir Docker İmajını Kaldır (docker rmi <image_id>)"
    echo "11. Bir Docker İmajı İndir (docker pull <image_name>)"
    echo "12. Bir Docker İmajı Oluştur (docker build -t <image_name> <path>)"
    echo "13. Konteyner Loglarını Göster (docker logs <container_id>)"
    echo "14. Konteynerde Komut Çalıştır (docker exec -it <container_id> <command>)"
    echo "15. Docker Ağlarını Listele (docker network ls)"
    echo "16. Bir Docker Ağını İncele (docker network inspect <network_name>)"
    echo "17. Docker Volümlerini Listele (docker volume ls)"
    echo "18. Bir Docker Volümünü İncele (docker volume inspect <volume_name>)"
    echo "19. Çıkış"
    echo "============================="
}

# Docker komutlarını çalıştırma fonksiyonu
execute_docker_command() {
    local command=$1
    echo "Çalıştırılıyor: $command"
    eval $command
}

# Ana program
while true; do
    show_menu
    read -p "Bir seçenek seçin: " choice
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
            read -p "Başlatmak için konteyner ID'si girin: " container_id
            execute_docker_command "docker start $container_id"
            ;;
        6)
            read -p "Durdurmak için konteyner ID'si girin: " container_id
            execute_docker_command "docker stop $container_id"
            ;;
        7)
            read -p "Yeniden başlatmak için konteyner ID'si girin: " container_id
            execute_docker_command "docker restart $container_id"
            ;;
        8)
            read -p "Kaldırmak için konteyner ID'si girin: " container_id
            execute_docker_command "docker rm $container_id"
            ;;
        9)
            execute_docker_command "docker images"
            ;;
        10)
            read -p "Kaldırmak için imaj ID'si girin: " image_id
            execute_docker_command "docker rmi $image_id"
            ;;
        11)
            read -p "İndirmek için imaj adı girin: " image_name
            execute_docker_command "docker pull $image_name"
            ;;
        12)
            read -p "Oluşturmak için imaj adı girin: " image_name
            read -p "Dockerfile yolunu girin: " path
            execute_docker_command "docker build -t $image_name $path"
            ;;
        13)
            read -p "Logları göstermek için konteyner ID'si girin: " container_id
            execute_docker_command "docker logs $container_id"
            ;;
        14)
            read -p "Konteyner ID'si girin: " container_id
            read -p "Çalıştırılacak komutu girin: " command
            execute_docker_command "docker exec -it $container_id $command"
            ;;
        15)
            execute_docker_command "docker network ls"
            ;;
        16)
            read -p "İncelemek için ağ adını girin: " network_name
            execute_docker_command "docker network inspect $network_name"
            ;;
        17)
            execute_docker_command "docker volume ls"
            ;;
        18)
            read -p "İncelemek için volüm adını girin: " volume_name
            execute_docker_command "docker volume inspect $volume_name"
            ;;
        19)
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
