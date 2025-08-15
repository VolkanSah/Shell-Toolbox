# Dev Server Toolbox v2.1

A lightweight, interactive Bash tool for managing and monitoring services, system resources, and logs on Linux servers.  
Ideal for quick DevOps tasks, local development environments, or small server setups.


## Features

- **Service Management**
  - View status of monitored services (active/inactive/not installed)
  - Start, stop, restart, or reload services
  - Restart all currently active services in one go
  - Enable services on boot if desired
  - Live service log viewer (`journalctl -f`)

- **Customizable Service List**
  - Add or remove services from the monitored list
  - Reset service list to default

- **System Monitoring**
  - Memory, disk, CPU, and load average overview
  - List top CPU and memory consuming processes
  - View active network connections and interfaces

- **Maintenance Tools**
  - Clear RAM and cache (`sync` + `drop_caches`)
  - Quick process monitoring

---

## Default Monitored Services

- `apache2` (Web server)
- `mariadb` (Database server)
- `tor` (Tor service)
- `ssh` (SSH server)

You can add or remove services at any time from the **Configure Services** menu.


## Requirements

- Linux system with `systemd`
- `sudo` privileges for service management
- Recommended packages:
  - `systemctl` (usually part of `systemd`)
  - `ss` (from `iproute2`)
  - `ip` (from `iproute2`)
  - `journalctl` (from `systemd`)

## Installation

1. **Download the script**

```bash
   wget https://example.com/server-toolbox.sh
   chmod +x server-toolbox.sh
  ```

2. **Run it**

```bash
   ./server-toolbox.sh
```

---

## Example Screenshots
```
**Main Menu**


========================================
          Dev Server Toolbox v2.1
========================================
1.  Service Status Overview
2.  Start Service
3.  Stop Service
4.  Restart Service
5.  Reload Service
6.  Restart All Active Services
7.  Show System Resources
8.  Clear RAM/Cache
9.  Network Information
10. Process Monitor
11. View Service Logs (Live)
12. Configure Services
13. Exit
========================================
Currently monitoring 4 services
```

---

## License

GPL 3 License
Feel free to modify, distribute, or integrate into your own tools.

---



