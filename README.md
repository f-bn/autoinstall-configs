<div align="center">
  <img src="https://raw.githubusercontent.com/microsoft/vscode-icons/main/icons/light/gear.svg" alt="Config Logo" width="150"/>

  **Unattended configurations**

  ---
</div>

## 📋 Overview

[![License](https://img.shields.io/github/license/f-bn/unattended-configs)](./LICENSE)
[![GitHub](https://img.shields.io/badge/Repository-GitHub-181717?logo=github)](https://github.com/f-bn/unattended-configs)

This repository contains automated installation and provisioning configurations for my personal devices running Linux and Windows.

Complemented with dotfiles management via [`chezmoi`](https://github.com/f-bn/dotfiles).

## 📦 Available Configurations

| Device | Type | OS | Hardware | Configuration |
|--------|------|----|----------| --------------|
| **[buran](./desktops/buran/)** | Desktop | Fedora 44 | Custom desktop build | [kickstart.ks](./desktops/buran/fedora/44/kickstart.ks) |
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
- **Fedora** - Kickstart format (`kickstart.ks`)
- **Fedora CoreOS** - Ignition format (`ignition.yaml`)

#### Ventoy setup

Create the following structure in the Ventoy partition:

```
/autoinstall/
├── desktops/
│   └── buran/
│       ├── ubuntu/
│       │   └── 26.04/
│       │       └── autoinstall.user-data
│       └── fedora/
│           └── 44/
│               └── kickstart.ks
│
├── laptops/
│   └── foton/
│       ├── ubuntu/
│       │   └── 26.04/
│       │       └── autoinstall.user-data
│       └── fedora/
│           └── 44/
│               └── kickstart.ks
│
├── servers/
│   └── proton/
│       └── autoinstall.user-data
/ventoy/
└── ventoy.json
fedora-44.iso
ubuntu-24.04.4-server.iso
ubuntu-26.04-desktop.iso
...
```

Create a `ventoy.json` file to map ISOs to unattended configuration files:

```json
{
    "auto_install":[
        {
            "image": "/ubuntu-**.**-desktop-******.iso",
            "template": [
                "/autoinstall/laptops/foton/ubuntu/26.04/autoinstall.user-data",
                "/autoinstall/desktops/buran/ubuntu/26.04/autoinstall.user-data"
            ]
        },
        {
            "image": "/ubuntu-**.**-desktop.iso",
            "template": [
                "/autoinstall/laptops/foton/ubuntu/26.04/autoinstall.user-data",
                "/autoinstall/desktops/buran/ubuntu/26.04/autoinstall.user-data"
            ]
        },
        {
            "image": "/fedora-**.iso",
            "template": [
                "/autoinstall/desktops/buran/fedora/44/kickstart.ks",
                "/autoinstall/laptops/foton/fedora/44/kickstart.ks"
            ]
        }
    ]
}
```

Boot the USB key, select an ISO, and choose the desired automated installation option.

## 📚 References

- [Cloud-Init](https://cloud-init.io/)
- [Ubuntu Autoinstall Reference](https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html)
- [Ventoy](https://www.ventoy.net/en/index.html)
- [Ventoy Autoinstall Plugin](https://www.ventoy.net/en/plugin_autoinstall.html)
- [Unattend Generator (Windows)](https://schneegans.de/windows/unattend-generator/)

## License

See [LICENSE](./LICENSE) file for details.
