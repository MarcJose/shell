# Cross-Platform Dotfiles

Streamlined configuration files for zsh, bash, and PowerShell across Linux distributions and Windows.

## Supported Environments

- Arch Linux
- Ubuntu 24.04 LTS
- WSL Ubuntu 24.04 LTS
- Windows 11 (PowerShell)

## Features

- Consistent shell experience across platforms
- Platform-specific optimizations
- Automatic updates on shell startup
- Single source of truth for all configurations

## Directory Structure

```shell
.
├── archlinux/
│   ├── .zshrc
│   └── .profile
├── ubuntu/
│   ├── .zshrc
│   └── .profile
├── wsl-ubuntu/
│   ├── .zshrc
│   └── .profile
└── windows/
    └── Microsoft.PowerShell_profile.ps1
```

## Installation

### Linux/WSL (ZSH)

```shell
# Archlinux
wget -O ~/.profile "https://raw.githubusercontent.com/MarcJose/shell/main/archlinux/.profile"
wget -O ~/.zshrc   "https://raw.githubusercontent.com/MarcJose/shell/main/archlinux/.zshrc"

# Ubuntu 24.04LTS
wget -O ~/.profile "https://raw.githubusercontent.com/MarcJose/shell/main/ubuntu/.profile"
wget -O ~/.zshrc   "https://raw.githubusercontent.com/MarcJose/shell/main/ubuntu/.zshrc"

# Ubuntu 24.04LTS (WSL)
wget -O ~/.profile "https://raw.githubusercontent.com/MarcJose/shell/main/wsl-ubuntu/.profile"
wget -O ~/.zshrc   "https://raw.githubusercontent.com/MarcJose/shell/main/wsl-ubuntu/.zshrc"
```

### Windows (PowerShell)

```powershell
# As Administrator
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex "& { $(irm https://raw.githubusercontent.com/MarcJose/shell/main/windows/install.ps1) } -CreateSymLink -Force -CreateLocalProfile"

# As user
iex "& { $(irm https://raw.githubusercontent.com/MarcJose/shell/main/windows/custom.ps1) } -Force"
```

## Updates

Configurations automatically update on shell startup after system reboot by pulling the latest version from this repository.

## License

MIT
