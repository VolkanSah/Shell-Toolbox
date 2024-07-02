# Shell Toolbox for Developers and Network Admins
##### Debian/Ubuntu


## Table of Contents

- [Introduction](#introduction)
- [Scripts Overview](#scripts-overview)
  - [Developer Toolbox (`dev_toolbox.sh`)](#1-developer-toolbox-dev_toolboxsh)
    - [How to Use](#how-to-use)
  - [Network Admin Toolbox (`network_info_tool.sh`)](#2-network-admin-toolbox-network_info_toolsh)
    - [How to Use](#how-to-use-1)
  - [Docker Toolbox (`docker_toolbox.sh`)](#3-docker-toolbox-docker_toolboxsh)
    - [How to Use](#how-to-use-2)
- [Disclaimer](#disclaimer)
- [Contributions](#contributions)
- [License](#license)
- [Contact](#contact)


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
3. Run the script (Docker needs root access):
    ```bash
    sudo docker_toolbox
    ```


## Disclaimer

These scripts were created for fun and to automate common tasks. They are provided "as-is" without any warranty. Use them at your own risk and feel free to customize them as needed.

## Contributions

Contributions are welcome! If you have ideas for new features or improvements, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License.

## Contact

If you have any questions or feedback, please contact [Your Name] at [Your Email].

---

Thank you for using the Shell Toolbox!

### Your Support
If you find this project useful and want to support it, there are several ways to do so:

- If you find the white paper helpful, please ⭐ it on GitHub. This helps make the project more visible and reach more people.
- Become a Follower: If you're interested in updates and future improvements, please follow my GitHub account. This way you'll always stay up-to-date.
- Learn more about my work: I invite you to check out all of my work on GitHub and visit my developer site https://volkansah.github.io. Here you will find detailed information about me and my projects.
- Share the project: If you know someone who could benefit from this project, please share it. The more people who can use it, the better.
**If you appreciate my work and would like to support it, please visit my [GitHub Sponsor page](https://github.com/sponsors/volkansah). Any type of support is warmly welcomed and helps me to further improve and expand my work.**

Thank you for your support! ❤️
