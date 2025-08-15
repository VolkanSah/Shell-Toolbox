# server-toolbox.shell

### v2.1 — (2025) English 

##### Debian/Ubuntu

## Table of Contents

- [Introduction](#introduction)
- [Script Overview](#script-overview)

  - [Features](#features)
  - [Service Configuration](#service-configuration)
  - [How to Use](#how-to-use)
- [Example `.dev-toolbox-services`](#example-dev-toolbox-services)
- [Disclaimer](#disclaimer)
- [Contributions](#contributions)
- [License](#license)
- [Contact](#contact)

---

## Introduction

The **Dev Server Toolbox** is a powerful, menu-driven Bash script for developers and server administrators to manage and monitor system services, resources, and network information.
It allows you to configure your own list of services and provides quick access to start, stop, restart, and inspect them.

The toolbox is fully customizable — simply define the services you want to monitor in a `.dev-toolbox-services` file, or use the built-in defaults.

---

## Script Overview

### Features

* **Service Status Overview** — Check if configured services are active, inactive, enabled, or missing.
* **Start/Stop/Restart/Reload Service** — Control services directly from the menu.
* **Restart All Active Services** — Quickly restart all services currently running.
* **System Resources** — View memory, disk, CPU usage, and top processes.
* **Clear RAM/Cache** — Free up memory by clearing cache safely.
* **Network Information** — View active connections and network interfaces.
* **Process Monitor** — List top CPU and memory-consuming processes.
* **Live Service Logs** — Tail journal logs of a chosen service.
* **Configure Services** — Add, remove, or reset services in the `.dev-toolbox-services` config file.

---

### Service Configuration

The toolbox loads services from:

1. **Config file**: `~/.dev-toolbox-services` (customizable per server)
2. **Default list**: Used only if no config file exists

You can edit the services directly in the menu (**Option 12**: Configure Services).

---

### How to Use

1. Example

   ```bash
   mkdir /home/scripts
 
   sudo cp server-toolbox.sh /home/scripts
   ```
2. Make it executable:

   ```bash
   sudo chmod +x server-toolbox.sh
   ```
3. Run the toolbox:

   ```bash
   ./server-toolbox.sh
   ```

---

## Example `.dev-toolbox-services`

You can list any services that are managed by `systemctl`.
Example configuration file:

```
apache2
mariadb
tor
ssh
php8.1-fpm
```

Each entry should be the exact service name as recognized by `systemctl list-units --type=service`.

---

## Disclaimer

This script is provided “as is” without warranty.
Use it at your own risk — you are responsible for any changes made to your system.

---

## Contributions

Feel free to open issues or submit pull requests with improvements, new features, or bug fixes.

---

## License

This project is licensed under the MIT License.

---

## Contact

More projects and contact information: [https://volkansah.github.io](https://volkansah.github.io)

If you appreciate my work, you can support me here: [GitHub Sponsors](https://github.com/sponsors/volkansah)
