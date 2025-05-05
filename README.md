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
│   ├── .profile
│   └── setup.sh
└── windows/
    ├── custom.ps1
    ├── install.ps1
    └── Microsoft.PowerShell_profile.ps1
```

## Installation

### Linux/WSL (ZSH)

```shell
# Archlinux
wget -O ~/.profile "https://raw.githubusercontent.com/MarcJose/shell/main/archlinux/.profile"
wget -O ~/.zshrc   "https://raw.githubusercontent.com/MarcJose/shell/main/archlinux/.zshrc"

# Ubuntu 24.04 LTS
wget -O ~/.profile "https://raw.githubusercontent.com/MarcJose/shell/main/ubuntu/.profile"
wget -O ~/.zshrc   "https://raw.githubusercontent.com/MarcJose/shell/main/ubuntu/.zshrc"

# Ubuntu 24.04 LTS (WSL)
wget -O ~/.profile "https://raw.githubusercontent.com/MarcJose/shell/main/wsl-ubuntu/.profile"
wget -O ~/.zshrc   "https://raw.githubusercontent.com/MarcJose/shell/main/wsl-ubuntu/.zshrc"
```

### Windows (PowerShell)

```powershell
# As Administrator
Set-ExecutionPolicy Unrestricted -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex "& { $(irm https://raw.githubusercontent.com/MarcJose/shell/main/windows/install.ps1) } -CreateSymLink -Force -CreateLocalProfile"

# As user
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
iex "& { $(irm https://raw.githubusercontent.com/MarcJose/shell/main/windows/custom.ps1) } -Force"
```

If you want to enable certain servicesi n WSL on boot you can execute this as administrator:

```powershell
# Cron
$Action = New-ScheduledTaskAction -Execute "C:\Windows\System32\wsl.exe" -Argument "sudo /usr/sbin/service cron start"
$Trigger = New-ScheduledTaskTrigger -AtStartup
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
Register-ScheduledTask -TaskName "WSL Cron Service Startup" -InputObject $Task -User "SYSTEM"

# Docker
$Action = New-ScheduledTaskAction -Execute "C:\Windows\System32\wsl.exe" -Argument "sudo /usr/sbin/service docker start"
$Trigger = New-ScheduledTaskTrigger -AtStartup
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
Register-ScheduledTask -TaskName "WSL Docker Service Startup" -InputObject $Task -User "SYSTEM"
```

## Updates

Configurations automatically update on shell startup after system reboot by pulling the latest version from this repository.

## License

MIT
