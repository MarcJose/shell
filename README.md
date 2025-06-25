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

## Installation

### Linux/WSL (ZSH)

#### Archlinux

```shell
wget -O ~/.profile "https://raw.githubusercontent.com/MarcJose/shell/main/archlinux/.profile"
wget -O ~/.zshrc   "https://raw.githubusercontent.com/MarcJose/shell/main/archlinux/.zshrc"
```

#### Ubuntu 24.04 LTS

```shell
wget -O ~/.profile "https://raw.githubusercontent.com/MarcJose/shell/main/ubuntu/.profile"
wget -O ~/.zshrc   "https://raw.githubusercontent.com/MarcJose/shell/main/ubuntu/.zshrc"
```

#### Ubuntu 24.04 LTS (WSL)

```shell
wget -O ~/.profile "https://raw.githubusercontent.com/MarcJose/shell/main/wsl-ubuntu/.profile"
wget -O ~/.zshrc   "https://raw.githubusercontent.com/MarcJose/shell/main/wsl-ubuntu/.zshrc"
```

### Windows (PowerShell)

#### As Administrator

```powershell
Set-ExecutionPolicy Unrestricted -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex "& { $(irm https://raw.githubusercontent.com/MarcJose/shell/main/windows/install.ps1) } -CreateSymLink -Force -CreateLocalProfile"
```

#### As User

This script activates the [WSL](https://learn.microsoft.com/de-de/windows/wsl/about). So you will have to activate the "Windows Virtual Machine Platform" and "Windows Subsystem for Linux" features in the Windows settings.

You can do this by either using the Windows GUI or by running the following command in an elevated PowerShell session:

```powershell
# Enabling Windows Subsystem for Linux
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Enabling Virtual Machine Platform.
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Then you should restart so Windows can activate the required features before continuing with the installation script:

```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
iex "& { $(irm https://raw.githubusercontent.com/MarcJose/shell/main/windows/custom.ps1) } -Force"
```

If you want to enable certain services in WSL on boot you can execute this as administrator:

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
