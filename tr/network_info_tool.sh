#!/bin/bash

# Menü gösterim fonksiyonu
show_menu() {
    echo "============================="
    echo " Ağ Bilgileri Menüsü"
    echo "============================="
    echo "1. Ağ Arayüzlerini Göster (ifconfig)"
    echo "2. Ağ Arayüzlerini Göster (ip a)"
    echo "3. Ağ Durumunu Göster (netstat)"
    echo "4. Ağ Durumunu Göster (ss)"
    echo "5. DNS Bilgilerini Göster (nslookup)"
    echo "6. DNS Bilgilerini Göster (dig)"
    echo "7. Bir IP Adresi veya Alan Adını Ping Et"
    echo "8. Bir IP Adresi veya Alan Adresine Traceroute"
    echo "9. ARP Tablosunu Göster (arp -a)"
    echo "10. Yönlendirme Tablosunu Göster (route -n)"
    echo "11. Güvenlik Duvarı Kurallarını Göster (iptables -L)"
    echo "12. Aktif Bağlantıları Göster (lsof -i)"
    echo "13. Çıkış"
    echo "============================="
}

# Her bir seçenek için fonksiyonlar
network_interfaces_ifconfig() {
    echo "Ağ Arayüzleri (ifconfig):"
    ifconfig
}

network_interfaces_ip() {
    echo "Ağ Arayüzleri (ip a):"
    ip a
}

network_status_netstat() {
    echo "Ağ Durumu (netstat):"
    netstat
}

network_status_ss() {
    echo "Ağ Durumu (ss):"
    ss
}

dns_info_nslookup() {
    read -p "nslookup için bir alan adı veya IP adresi girin: " address
    nslookup $address
}

dns_info_dig() {
    read -p "dig için bir alan adı veya IP adresi girin: " address
    dig $address
}

ping_address() {
    read -p "Ping atmak için bir IP adresi veya alan adı girin: " address
    ping -c 4 $address
}

traceroute_address() {
    read -p "Traceroute için bir IP adresi veya alan adı girin: " address
    traceroute $address
}

arp_table() {
    echo "ARP Tablosu (arp -a):"
    arp -a
}

routing_table() {
    echo "Yönlendirme Tablosu (route -n):"
    route -n
}

firewall_rules() {
    echo "Güvenlik Duvarı Kuralları (iptables -L):"
    sudo iptables -L
}

active_connections() {
    echo "Aktif Bağlantılar (lsof -i):"
    sudo lsof -i
}

# Ana program
while true; do
    show_menu
    read -p "Bir seçenek seçin: " choice
    case $choice in
        1)
            network_interfaces_ifconfig
            ;;
        2)
            network_interfaces_ip
            ;;
        3)
            network_status_netstat
            ;;
        4)
            network_status_ss
            ;;
        5)
            dns_info_nslookup
            ;;
        6)
            dns_info_dig
            ;;
        7)
            ping_address
            ;;
        8)
            traceroute_address
            ;;
        9)
            arp_table
            ;;
        10)
            routing_table
            ;;
        11)
            firewall_rules
            ;;
        12)
            active_connections
            ;;
        13)
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
