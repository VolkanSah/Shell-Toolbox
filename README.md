# Shell Toolbox for Developers and Network Admins

### Debian/Ubuntu

## Introduction

This repository contains useful shell scripts designed for developers, network administrators, and Docker users. These scripts provide a menu-driven interface for executing common tasks, automating repetitive commands, and gathering essential system and network information.

## Scripts Overview

### 1. Developer Toolbox (`dev_toolbox.sh`)

This script offers options to update and clean the system, display system information, and manage memory and cache.

- **System Update**: Runs `apt-get update`.
- **System Upgrade**: Runs `apt-get upgrade`.
- **Autoclean**: Runs `apt-get autoclean`.
- **Clear RAM**: Clears the RAM cache.
- **Clear Cache**: Clears the system cache.
- **Show System Information**: Displays system information.

#### How to Use
1. Copy the script to `/usr/local/bin/`:
    ```bash
    sudo cp dev_toolbox.sh /usr/local/bin/dev_toolbox
    ```
2. Make the script executable:
    ```bash
    sudo chmod +x /usr/local/bin/dev_toolbox
    ```
3. Run the script:
    ```bash
    dev_toolbox
    ```

### 2. Network Admin Toolbox (`network_info_tool.sh`)

This script provides various network-related commands to help gather information and diagnose network issues.

- **Show Network Interfaces**: `ifconfig` and `ip a`
- **Show Network Status**: `netstat` and `ss`
- **DNS Information**: `nslookup` and `dig`
- **Ping**: Sends ICMP ECHO_REQUEST.
- **Traceroute**: Traces the route to a network host.
- **Show ARP Table**: Displays the ARP table.
- **Show Routing Table**: Displays the routing table.
- **Show Firewall Rules**: Displays iptables rules.
- **Show Active Connections**: Displays active network connections.

#### How to Use
1. Copy the script to `/usr/local/bin/`:
    ```bash
    sudo cp network_info_tool.sh /usr/local/bin/network_info_tool
    ```
2. Make the script executable:
    ```bash
    sudo chmod +x /usr/local/bin/network_info_tool
    ```
3. Run the script:
    ```bash
    network_info_tool
    ```

### 3. Docker Toolbox (`docker_toolbox.sh`)

This script provides a menu-driven interface for managing Docker containers, images, networks, and volumes.

- **Docker System Information**: `docker info` and `docker version`
- **Manage Containers**: `docker ps`, `docker start`, `docker stop`, `docker restart`, `docker rm`
- **Manage Images**: `docker images`, `docker rmi`, `docker pull`, `docker build`
- **Container Logs**: `docker logs`
- **Execute Commands in Containers**: `docker exec`
- **Network Information**: `docker network ls` and `docker network inspect`
- **Volume Information**: `docker volume ls` and `docker volume inspect`

#### How to Use
1. Copy the script to `/usr/local/bin/`:
    ```bash
    sudo cp docker_toolbox.sh /usr/local/bin/docker_toolbox
    ```
2. Make the script executable:
    ```bash
    sudo chmod +x /usr/local/bin/docker_toolbox
    ```
3. Run the script:
    ```bash
    sudo docker_toolbox
    ```

## Disclaimer

These scripts were created for fun and to automate common tasks. They are provided "as-is" without any warranty. Use them at your own risk and feel free to customize them as needed.

## Contributions

Contributions are welcome! If you have ideas for new features or improvements, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contact

If you have any questions or feedback, please contact [Your Name] at [Your Email].

---

Thank you for using the Shell Toolbox!
