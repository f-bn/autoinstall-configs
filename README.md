<div align="center">
  <img src="https://raw.githubusercontent.com/microsoft/vscode-icons/main/icons/light/gear.svg" alt="Config Logo" width="150"/>

  **Unattended configurations**

  ---
</div>

## 📋 Overview

[![License](https://img.shields.io/github/license/f-bn/unattended-configs)](./LICENSE)
[![GitHub](https://img.shields.io/badge/Repository-GitHub-181717?logo=github)](https://github.com/f-bn/unattended-configs)

This repository contains automated installation and provisioning configurations for my personal devices running Linux and Windows.

- 🔧 **Automated setup** - Fully unattended installations with minimal user interaction
- 🖥️ **Multi-platform** - Supports Ubuntu (bare-metal and WSL2), Fedora CoreOS and Windows
- 🔄 **Version-controlled** - Track and manage configuration changes over time

Complemented with dotfiles management via [`chezmoi`](https://github.com/f-bn/dotfiles).

## 📦 Available Configurations

| Device | Type | OS | Hardware | Configuration |
|--------|------|----|----------| --------------|
| **[buran](./desktops/buran/)** | Desktop | Ubuntu 26.04 | Custom desktop build | [autoinstall.user-data](./desktops/buran/ubuntu/26.04/autoinstall.user-data) |
| **[foton](./laptops/foton/)**  | Laptop | Ubuntu 26.04 | Thinkpad P14s Gen 5 | [autoinstall.user-data](./laptops/foton/ubuntu/26.04/autoinstall.user-data) |
| **[soyuz](./servers/soyuz/)**  | Server | Fedora CoreOS 43 | Beelink SER5 PRO | [ignition.yaml](./servers/soyuz/ignition.yaml) |

### Legacy Configurations

| Device | Type | OS | Hardware | Configuration |
|--------|------|----|---------| --------------|

| **[proton](./servers/proton/)** | Server | Ubuntu 24.04 LTS | ASRock DeskMini X300 | [autoinstall.user-data](./servers/proton/autoinstall.user-data) |

## 🚀 Quick Start

### Desktops, Laptops & Servers

All physical installations leverage Ventoy's `autoinstall` plugin to automatically pass configuration files to the respective installers:

- **Ubuntu (Desktop/Server)** - Subiquity format (`user-data`, inspired by Cloud-Init)
- **Fedora CoreOS** - Ignition format (`ignition.yaml`)
- **Windows** - `autounattend.xml` format

#### Ventoy setup

Create the following structure in the Ventoy partition:

```
/autoinstall/
├── desktops/
│   └── buran/
│       ├── 26.04/
│       │   └── autoinstall.user-data
│       └── win11/
│           └── unattended.xml
├── laptops/
│   └── foton/
│       ├── 25.10/
│       │   └── autoinstall.user-data
│       └── 26.04/
│           └── autoinstall.user-data
├── servers/
│   └── proton/
│       └── autoinstall.user-data
/ventoy/
└── ventoy.json
ubuntu-24.04.4-server.iso
ubuntu-25.10-desktop.iso
ubuntu-26.04-desktop.iso
win11-24h2.iso
...
```

Create a `ventoy.json` file to map ISOs to unattended configuration files:

```json
{
    "auto_install":[
        {
            "image": "/ubuntu-**.**-desktop.iso",
            "template": [
                "/autoinstall/laptops/foton/25.10/autoinstall.user-data",
                "/autoinstall/laptops/foton/26.04/autoinstall.user-data"
            ]
        },
        {
            "image": "/win11_****.iso",
            "template": [
                "/autoinstall/desktops/buran/unattended.xml"
            ]
        }
    ]
}
```

Boot the USB key, select an ISO, and choose the automated installation option.

## 📚 References

- [Cloud-Init](https://cloud-init.io/)
- [Ubuntu Autoinstall Reference](https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html)
- [Ventoy](https://www.ventoy.net/en/index.html)
- [Ventoy Autoinstall Plugin](https://www.ventoy.net/en/plugin_autoinstall.html)
- [Unattend Generator (Windows)](https://schneegans.de/windows/unattend-generator/)

## License

See [LICENSE](./LICENSE) file for details.
