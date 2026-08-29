<div align="center">
  <img src="https://raw.githubusercontent.com/microsoft/vscode-icons/main/icons/light/gear.svg" alt="Config Logo" width="150"/>

  **Unattended configurations**

  ---
</div>

## 📋 Overview

[![License](https://img.shields.io/github/license/f-bn/unattended-configs)](./LICENSE)
[![GitHub](https://img.shields.io/badge/Repository-GitHub-181717?logo=github)](https://github.com/f-bn/unattended-configs)

This repository contains automated installation and provisioning configurations for my personal devices running on Linux (almost exclusively on Fedora).

Complemented with dotfiles management via [`chezmoi`](https://github.com/f-bn/dotfiles).

## 📦 Available Configurations

| Device | Type | OS | Hardware | Configuration |
|--------|------|----|----------| --------------|
| **[buran](./desktops/buran/)** | Desktop | Fedora 44 | Custom desktop build | [Kickstart](./desktops/buran/fedora-44.ks) |
| **[foton](./laptops/foton/)**  | Laptop | Fedora 44 | Thinkpad P14s Gen 5 | [Kickstart](./laptops/foton/fedora-44.ks) |
| **[soyuz](./servers/soyuz/)**  | Server | Fedora CoreOS 44 | Beelink SER5 PRO | [Ignition](./servers/soyuz/ignition.yaml) |

> [!NOTE]
> Previously used configurations are stored in the [archive](./archive/) folder.

## 🚀 Quick Start

### Desktops, Laptops & Servers

All physical installations leverage Ventoy's `autoinstall` plugin to automatically pass configuration files to the respective installers:

- **Fedora** - Kickstart format (`fedora-*.ks`)
- **Fedora CoreOS** - Ignition format (`ignition.yaml`)
- **Ubuntu (Desktop/Server)** - Subiquity format (`user-data`, inspired by Cloud-Init)

#### Ventoy setup

Create the following structure in the Ventoy partition:

```
/autoinstall/
├── desktops/
│   └── buran/
│       └── fedora-44.ks
│
├── laptops/
│   └── foton/
│       └── fedora-44.ks
│
/ventoy/
└── ventoy.json
fedora-44.iso
...
```

Create a [`ventoy.json`](./ventoy.json) file to map ISOs to unattended configuration files:

```json
{
    "auto_install":[
        {
            "image": "/fedora-**.iso",
            "template": [
                "/autoinstall/desktops/buran/fedora-44.ks",
                "/autoinstall/laptops/foton/fedora-44.ks"
            ]
        }
    ]
}
```

Boot the USB key, select an ISO, and choose the desired automated installation option.

> [!NOTE]
> Fedora CoreOS ignition files are currently not handled by Ventoy, but rather downloaded at install time via the [`--ignition-url`](https://coreos.github.io/coreos-installer/cmd/install/) flag in the `coreos-installer` utility.

## 📚 References

- [Cloud-Init](https://cloud-init.io/)
- [CoreOS Installer](https://coreos.github.io/coreos-installer/)
- [Ignition](https://coreos.github.io/ignition/)
- [Kickstart Documentation](https://pykickstart.readthedocs.io/en/latest/kickstart-docs.html)
- [Ubuntu Autoinstall Reference](https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html)
- [Ventoy](https://www.ventoy.net/en/index.html)
- [Ventoy Autoinstall Plugin](https://www.ventoy.net/en/plugin_autoinstall.html)

## License

See [LICENSE](./LICENSE) file for details.
