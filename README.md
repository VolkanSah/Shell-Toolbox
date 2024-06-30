
# Shell Toolbox (Developer and Network Admin Toolbox)
### Debian/Ubuntu

## Introduction

This repository contains two simple and useful shell scripts designed for developers and network administrators. These scripts provide a menu-driven interface for executing common tasks, automating repetitive commands, and gathering essential system and network information. Although created as a fun project, these scripts can be handy tools for daily use.

## Scripts Overview

### 1. Developer Toolbox (`dev_toolbox.sh`)

The Developer Toolbox script offers a range of options to update and clean the system, display system information, and manage memory and cache. Here are the available options:

- **System Update**: Runs `apt-get update` to update the package list.
- **System Upgrade**: Runs `apt-get upgrade` to upgrade all installed packages.
- **Autoclean**: Runs `apt-get autoclean` to remove outdated packages.
- **Clear RAM**: Clears the RAM cache.
- **Clear Cache**: Clears the system cache.
- **Show System Information**: Displays information about the system (kernel, CPU, memory, disk usage).

#### How to Use
1. Copy the script to `/usr/local/bin/`:
    ```bash
    sudo cp dev_toolbox.sh /usr/local/bin/dev_toolbox
    ```
2. Make the script executable:
    ```bash
    sudo chmod +x /usr/local/bin/dev_toolbox
    ```
3. Run the script from any location in the terminal:
    ```bash
    dev_toolbox
    ```

### 2. Network Admin Toolbox (`network_info_tool.sh`)

The Network Admin Toolbox script provides a menu with various network-related commands to help gather information and diagnose network issues. Here are the available options:

- **Show Network Interfaces (ifconfig)**: Displays network interfaces using `ifconfig`.
- **Show Network Interfaces (ip a)**: Displays network interfaces using `ip a`.
- **Show Network Status (netstat)**: Displays network connections, routing tables, interface statistics, masquerade connections, and multicast memberships.
- **Show Network Status (ss)**: Displays socket statistics.
- **DNS Lookup (nslookup)**: Performs a DNS lookup for a specified domain or IP address.
- **DNS Query (dig)**: Performs a DNS query for a specified domain or IP address.
- **Ping**: Sends ICMP ECHO_REQUEST to network hosts.
- **Traceroute**: Traces the route packets take to a network host.
- **Show ARP Table**: Displays the ARP table.
- **Show Routing Table**: Displays the kernel routing table.
- **Show Firewall Rules**: Displays the current iptables rules.
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
3. Run the script from any location in the terminal:
    ```bash
    network_info_tool
    ```

## Disclaimer

These scripts were created as a fun project to automate common tasks and gather useful information. While they can be useful in daily operations, they are provided "as-is" without any warranty. Use them at your own risk and feel free to customize them according to your needs.

## Contributions

Contributions are welcome! If you have ideas for new features or improvements, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contact

If you have any questions or feedback, please contact [Your Name] at [Your Email].

---

Thank you for using the Developer and Network Admin Toolbox!
