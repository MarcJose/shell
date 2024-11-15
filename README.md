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
cp $os/.profile ~/.profile
cp $os/.zshrc ~/.zshrc
```

### Windows (PowerShell)

```powershell
Copy-Item windows/Microsoft.PowerShell_profile.ps1 $PROFILE
```

## Updates

Configurations automatically update on shell startup after system reboot by pulling the latest version from this repository.

## License

MIT
