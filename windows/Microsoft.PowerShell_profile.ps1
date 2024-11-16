# Enable TLS 1.2 for compatibility with older PowerShell versions
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$SCRIPT_VERSION = "1.0.0"
$GITHUB_REPO_URL = "https://raw.githubusercontent.com/MarcJose/shell/main/windows/Microsoft.PowerShell_profile.ps1"
$UPDATE_CHECK_FILE = Join-Path $env:TEMP "ps_profile_last_check.txt"

# Fix path for older versions of PowerShell
if ($null -eq $PSCommandPath) {
    function GetPSCommandPath() {
        return $MyInvocation.PSCommandPath
    }
    $PSCommandPath = GetPSCommandPath
}

# Helper function to install and import modules safely
function Install-RequiredModule {
    param(
        [string]$ModuleName,
        [string]$Scope = "CurrentUser",
        [switch]$AllowClobber,
        [switch]$SkipPublisherCheck,
        [switch]$Force
    )

    try {
        if (-not (Get-Module -ListAvailable -Name $ModuleName)) {
            Write-Host "Installing module: $ModuleName..."
            $params = @{
                Name = $ModuleName
                Scope = $Scope
                Force = $Force
                ErrorAction = 'Stop'
            }
            if ($AllowClobber) { $params.AllowClobber = $true }
            if ($SkipPublisherCheck) { $params.SkipPublisherCheck = $true }

            Install-Module @params
            Write-Host "Successfully installed $ModuleName"
        }

        Import-Module -Name $ModuleName -ErrorAction Stop
        Write-Host "Successfully imported $ModuleName"
    }
    catch {
        Write-Error "Failed to install/import $ModuleName : $_"
    }
}

# Install and import required modules
Install-RequiredModule -ModuleName Terminal-Icons -SkipPublisherCheck
Install-RequiredModule -ModuleName PSWindowsUpdate
Install-RequiredModule -ModuleName PSReadLine -Scope AllUsers

# Configure PSReadLine if in ConsoleHost
if ($host.Name -eq 'ConsoleHost') {
    try {
        Import-Module PSReadLine

        # Enhanced command history search
        Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
        Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

        # Add predictive IntelliSense (PowerShell 7.1+)
        if ($PSVersionTable.PSVersion.Major -ge 7) {
            Set-PSReadLineOption -PredictionSource History
            Set-PSReadLineOption -PredictionViewStyle ListView
        }
    }
    catch {
        Write-Error "Failed to configure PSReadLine: $_"
    }
}

# Enhanced terminal prompt with git integration
function Prompt {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal] $identity
    $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

    $ESC = [char]27
    $promptString = ""

    # Add last command status
    $promptString += if ($?) {
        "[$ESC[32m✔$ESC[0m]"
    } else {
        "[$ESC[31m✗$ESC[0m]"
    }

    # Add current date and time
    $promptString += "[$ESC[32m$(Get-Date -Format 'yyyy-MM-dd HH:mm')$ESC[0m]"

    # Add current user/admin status
    if (Test-Path variable:/PSDebugContext) {
        $promptString += "[$ESC[31mdebug$ESC[0m]"
    }
    elseif ($principal.IsInRole($adminRole)) {
        $promptString += "[$ESC[31madministrator$ESC[0m]"
    }
    else {
        $promptString += "[$ESC[32m$env:USERNAME$ESC[0m]"
    }

    # Add current directory
    $promptString += "[$ESC[34m$(Get-Location)$ESC[0m]"

    # Add git status if applicable
    if (Get-Command git -ErrorAction SilentlyContinue) {
        try {
            $gitStatus = git status -s -b 2>$null
            if ($gitStatus) {
                $branch = git symbolic-ref --short HEAD
                $promptString += "[$ESC[33m$branch$ESC[0m]"

                # Show dirty state
                $dirty = git status --porcelain
                if ($dirty) {
                    $promptString += "[$ESC[31m*$ESC[0m]"
                }
            }
        }
        catch {
            # Silently fail for non-git directories
        }
    }

    # Add PowerShell version
    $promptString += "[$ESC[36mPS $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)$ESC[0m]"

    return "$promptString`n➤ "
}

# Enhanced admin check function
function Test-AdminPrivileges {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]$identity
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Require admin privileges for a function
function Invoke-RequireAdmin {
    param([ScriptBlock]$ScriptBlock)

    if (-not (Test-AdminPrivileges)) {
        throw "Administrator privileges required!"
    }

    & $ScriptBlock
}

# Package Manager Installation Functions
function Install-Scoop {
    try {
        if (Get-Command scoop -ErrorAction SilentlyContinue) {
            Write-Host "Scoop is already installed"
            return
        }

        Write-Host "Installing Scoop..."
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Invoke-RestMethod get.scoop.sh | Invoke-Expression

        # Add extra buckets
        Write-Host "Adding extra buckets..."
        scoop bucket add extras
        scoop bucket add java
        scoop bucket add versions
        scoop bucket add nerd-fonts

        Write-Host "Updating Scoop..."
        scoop update

        Write-Host "Scoop installed successfully"
    }
    catch {
        Write-Error "Failed to install Scoop: $_"
    }
}

function Install-Chocolatey {
    try {
        if (Get-Command choco -ErrorAction SilentlyContinue) {
            Write-Host "Chocolatey is already installed"
            return
        }

        Write-Host "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

        Write-Host "Chocolatey installed successfully"
    }
    catch {
        Write-Error "Failed to install Chocolatey: $_"
    }
}

# Enhanced WSL management functions
function Enable-WSL {
    Invoke-RequireAdmin {
        try {
            Write-Host "Enabling Windows Subsystem for Linux..."
            dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

            Write-Host "Enabling Virtual Machine Platform..."
            dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

            Write-Host "Installing WSL..."
            wsl --install --no-distribution

            Write-Host "Setting WSL 2 as default..."
            wsl --set-default-version 2

            Write-Host "WSL setup completed successfully. Please restart your computer."
        }
        catch {
            Write-Error "Failed to enable WSL: $_"
        }
    }
}

# WSL Management Functions
function WSL-Restart {
    Invoke-RequireAdmin {
        try {
            Write-Host "Shutting down WSL..."
            wsl --shutdown

            Write-Host "Restarting LxssManager service..."
            Restart-Service LxssManager -Force

            Write-Host "WSL restarted successfully"
        }
        catch {
            Write-Error "Failed to restart WSL: $_"
        }
    }
}

function WSL-Status {
    try {
        Write-Host "Getting WSL status..." -NoNewline
        $status = wsl --status
        Write-Host "Done!"
        return $status
    }
    catch {
        Write-Error "Failed to get WSL status: $_"
    }
}

# Shutdown all running WSL instances.
function WSL-Shutdown {
    try {
        wsl --shutdown
        Write-Host "WSL instances shut down successfully"
    }
    catch {
        Write-Error "Failed to shutdown WSL: $_"
    }
}

# Enhanced internet connectivity test
function Test-InternetConnection {
    param(
        [string]$TestHost = "8.8.8.8",
        [int]$TimeoutSeconds = 5,
        [switch]$Detailed
    )

    try {
        $ping = Test-Connection -ComputerName $TestHost -Count 1 -ErrorAction Stop

        if ($Detailed) {
            return @{
                Connected = $true
                ResponseTime = $ping.ResponseTime
                Address = $ping.Address
            }
        }
        return $true
    }
    catch {
        if ($Detailed) {
            return @{
                Connected = $false
                Error = $_.Exception.Message
            }
        }
        return $false
    }
}

# Enhanced system maintenance functions
function Update-AllSoftware {
    Invoke-RequireAdmin {
        try {
            # Update Windows
            Write-Host "Checking for Windows updates..."
            $updates = Get-WindowsUpdate
            if ($updates.Count -gt 0) {
                Write-Host "Found $($updates.Count) updates"
                Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot
            }

            # Update winget packages
            if (Get-Command winget -ErrorAction SilentlyContinue) {
                Write-Host "Updating winget packages..."
                winget upgrade --silent --force --recurse --include-unknown --accept-source-agreements --accept-package-agreements --all
            }

            # Update Scoop packages
            if (Get-Command scoop -ErrorAction SilentlyContinue) {
                Write-Host "Updating Scoop and its packages..."
                scoop update *
                Write-Host "Cleaning Scoop cache..."
                scoop cleanup *
            }

            # Update Chocolatey packages
            if (Get-Command choco -ErrorAction SilentlyContinue) {
                Write-Host "Updating Chocolatey packages..."
                choco upgrade all -y
            }

            # Update PowerShell modules
            Write-Host "Updating PowerShell modules..."
            Update-Module -Force

            Write-Host "Software update completed successfully"
        }
        catch {
            Write-Error "Failed to update software: $_"
        }
    }
}

function Update-PackageManagers {
    try {
        # Update Scoop itself
        if (Get-Command scoop -ErrorAction SilentlyContinue) {
            Write-Host "Updating Scoop..."
            scoop update
        }

        # Update Chocolatey itself
        if (Get-Command choco -ErrorAction SilentlyContinue) {
            Write-Host "Updating Chocolatey..."
            choco upgrade chocolatey -y
        }
    }
    catch {
        Write-Error "Failed to update package managers: $_"
    }
}

function Get-PackageManagerStatus {
    try {
        $status = @{
            Winget = $false
            Scoop = $false
            Chocolatey = $false
        }

        if (Get-Command winget -ErrorAction SilentlyContinue) {
            $status.Winget = $true
        }

        if (Get-Command scoop -ErrorAction SilentlyContinue) {
            $status.Scoop = $true
        }

        if (Get-Command choco -ErrorAction SilentlyContinue) {
            $status.Chocolatey = $true
        }

        return [PSCustomObject]$status
    }
    catch {
        Write-Error "Failed to get package manager status: $_"
    }
}

# PowerShell Management Functions
function Update-PowerShell-Help {
    Invoke-RequireAdmin {
        try {
            Write-Host "Updating PowerShell help files..."
            Update-Help -Force -UICulture en-US -ErrorAction SilentlyContinue
            Update-Help -Force -UICulture de-DE -ErrorAction SilentlyContinue
            Write-Host "PowerShell help updated successfully"
        }
        catch {
            Write-Error "Failed to update PowerShell help: $_"
        }
    }
}

# Enhanced system cleanup
function Clear-SystemCache {
    Invoke-RequireAdmin {
        $paths = @(
            "C:\Windows\SoftwareDistribution\Download",
            "C:\Windows\SoftwareDistribution\DataStore\*",
            "C:\Windows\SoftwareDistribution\PostRebootEventCache.V2\*",
            "C:\Windows\Temp",
            "$env:TEMP",
            "$env:USERPROFILE\AppData\Local\Temp",
            "$env:USERPROFILE\AppData\Local\Microsoft\Terminal Server Client\Cache",
            "$env:USERPROFILE\AppData\Local\Microsoft\Windows\WER",
            "$env:USERPROFILE\AppData\Local\Microsoft\Windows\AppCache",
            "$env:USERPROFILE\AppData\Local\CrashDumps"
        )

        foreach ($path in $paths) {
            if (Test-Path $path) {
                try {
                    Remove-Item -Path "$path\*" -Recurse -Force -ErrorAction Continue
                    Write-Host "Cleared cache in: $path"
                }
                catch {
                    Write-Warning "Failed to clear some items in $path"
                }
            }
        }
    }
}

# Network Management Functions
function Clear-DNS-Cache {
    try {
        Write-Host "Current DNS servers:"
        Get-DnsClientServerAddress

        Write-Host "`nClearing DNS cache..."
        Clear-DnsClientCache

        Write-Host "DNS cache cleared successfully"
    }
    catch {
        Write-Error "Failed to clear DNS cache: $_"
    }
}

# Path Management
function Reload-Path {
    try {
        Write-Host "Reloading system PATH..."

        if (Test-AdminPrivileges) {
            [Environment]::SetEnvironmentVariable(
                "Path",
                [Environment]::GetEnvironmentVariable("Path", "Machine"),
                "Machine"
            )
        }

        [Environment]::SetEnvironmentVariable(
            "Path",
            [Environment]::GetEnvironmentVariable("Path", "User"),
            "User"
        )

        # Refresh current session's PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                   [System.Environment]::GetEnvironmentVariable("Path", "User")

        Write-Host "PATH reloaded successfully"
    }
    catch {
        Write-Error "Failed to reload PATH: $_"
    }
}

# SMB Management Functions
function Enable-SMB1 {
    Invoke-RequireAdmin {
        try {
            Write-Host "Enabling SMBv1..."
            Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol
            Set-SmbServerConfiguration -EnableSMB1Protocol $true -Force
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" `
                           -Name "SMB1" -Type DWORD -Value 1 -Force
            Write-Host "SMBv1 enabled successfully"
        }
        catch {
            Write-Error "Failed to enable SMBv1: $_"
        }
    }
}

function Disable-SMB1 {
    Invoke-RequireAdmin {
        try {
            Write-Host "Disabling SMBv1..."
            Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" `
                           -Name "SMB1" -Type DWORD -Value 0 -Force
            Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol
            Write-Host "SMBv1 disabled successfully"
        }
        catch {
            Write-Error "Failed to disable SMBv1: $_"
        }
    }
}

function Enable-SMB2 {
    Invoke-RequireAdmin {
        try {
            Write-Host "Enabling SMBv2..."
            Set-SmbServerConfiguration -EnableSMB2Protocol $true -Force
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" `
                           -Name "SMB2" -Type DWORD -Value 1 -Force
            Write-Host "SMBv2 enabled successfully"
        }
        catch {
            Write-Error "Failed to enable SMBv2: $_"
        }
    }
}

function Disable-SMB2 {
    Invoke-RequireAdmin {
        try {
            Write-Host "Disabling SMBv2..."
            Set-SmbServerConfiguration -EnableSMB2Protocol $false -Force
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" `
                           -Name "SMB2" -Type DWORD -Value 0 -Force
            Write-Host "SMBv2 disabled successfully"
        }
        catch {
            Write-Error "Failed to disable SMBv2: $_"
        }
    }
}

function Show-SMB {
    try {
        Write-Host "Getting SMB configuration..."
        $config = Get-SmbServerConfiguration |
                 Select-Object EnableSMB1Protocol, EnableSMB2Protocol

        Write-Host "`nSMB Configuration:"
        Write-Host "SMBv1: $($config.EnableSMB1Protocol)"
        Write-Host "SMBv2: $($config.EnableSMB2Protocol)"
    }
    catch {
        Write-Error "Failed to get SMB configuration: $_"
    }
}

# Enhanced file system functions
function Get-DirectorySize {
    param(
        [string]$Path = ".",
        [switch]$Recurse
    )

    try {
        $params = @{
            Path = $Path
            File = $true
        }
        if ($Recurse) { $params.Recurse = $true }

        $size = Get-ChildItem @params | Measure-Object -Property Length -Sum

        return @{
            Path = $Path
            Size = $size.Sum
            SizeGB = [math]::Round($size.Sum / 1GB, 2)
            SizeMB = [math]::Round($size.Sum / 1MB, 2)
            FileCount = $size.Count
        }
    }
    catch {
        Write-Error "Failed to get directory size: $_"
    }
}

# Enhanced network functions
function Get-NetworkInfo {
    try {
        $publicIP = (Invoke-WebRequest -Uri "http://ifconfig.me/ip" -UseBasicParsing).Content
        $interfaces = Get-NetAdapter | Where-Object Status -eq "Up"

        return @{
            PublicIP = $publicIP
            Interfaces = $interfaces | ForEach-Object {
                @{
                    Name = $_.Name
                    Status = $_.Status
                    LinkSpeed = $_.LinkSpeed
                    MacAddress = $_.MacAddress
                }
            }
        }
    }
    catch {
        Write-Error "Failed to get network information: $_"
    }
}

# Enhanced Unix-like commands
function which {
    param([string]$command)

    try {
        $cmd = Get-Command $command -ErrorAction Stop
        return @{
            Name = $cmd.Name
            Version = $cmd.Version
            Source = $cmd.Source
            CommandType = $cmd.CommandType
        }
    }
    catch {
        Write-Error "Command not found: $command"
    }
}

function grep {
    param(
        [Parameter(Mandatory)]
        [string]$Pattern,
        [string]$Path = "*",
        [switch]$CaseSensitive,
        [switch]$RecurseDirectories
    )

    $params = @{
        Path = $Path
        Pattern = $Pattern
    }

    if (-not $CaseSensitive) { $params.CaseSensitive = $false }
    if ($RecurseDirectories) { $params.Recurse = $true }

    try {
        Select-String @params
    }
    catch {
        Write-Error "Failed to search files: $_"
    }
}

# List files.
# https://www.man7.org/linux/man-pages/man1/ls.1.html
function ls {
    param(
        [string]$Path = ".",
        [switch]$Full
    )

    try {
        $items = Get-ChildItem -Path $Path -Force
        if ($Full) {
            return $items | Format-Table -AutoSize
        }
        else {
            return $items | Format-Wide -AutoSize
        }
    }
    catch {
        Write-Error "Failed to list directory: $_"
    }
}

# List files (including hidden).
# https://www.man7.org/linux/man-pages/man1/ls.1.html
function lsh {
    param([string]$Path = ".")

    try {
        Get-ChildItem -Path $Path -Force -Hidden | Format-Table -AutoSize
    }
    catch {
        Write-Error "Failed to list hidden files: $_"
    }
}

# Kill process based on name.
# https://linux.die.net/man/1/pkill
function pkill {
    param(
        [Parameter(Mandatory)]
        [string]$Name,
        [switch]$Force
    )

    try {
        $processes = Get-Process $Name -ErrorAction Stop
        if ($Force) {
            $processes | Stop-Process -Force
        }
        else {
            $processes | Stop-Process
        }
        Write-Host "Successfully terminated process(es): $Name"
    }
    catch {
        Write-Error "Failed to kill process '$Name': $_"
    }
}

# Get process based on name.
# https://www.man7.org/linux/man-pages/man1/pgrep.1.html
function pgrep {
    param(
        [Parameter(Mandatory)]
        [string]$Name,
        [switch]$Detailed
    )

    try {
        $processes = Get-Process $Name -ErrorAction Stop
        if ($Detailed) {
            return $processes | Select-Object Id, Name, CPU, WorkingSet, Path
        }
        else {
            return $processes | Select-Object Id, Name
        }
    }
    catch {
        Write-Error "Failed to find process '$Name': $_"
    }
}

# Print first n lines of file.
# https://www.man7.org/linux/man-pages/man1/head.1.html
function head {
    param(
        [Parameter(Mandatory)]
        [string]$Path,
        [int]$Lines = 10
    )

    try {
        Get-Content $Path -Head $Lines
    }
    catch {
        Write-Error "Failed to read file: $_"
    }
}

# Print last n lines of file.
# https://www.man7.org/linux/man-pages/man1/tail.1.html
function tail {
    param(
        [Parameter(Mandatory)]
        [string]$Path,
        [int]$Lines = 10,
        [switch]$Wait
    )

    try {
        Get-Content $Path -Tail $Lines -Wait:$Wait
    }
    catch {
        Write-Error "Failed to read file: $_"
    }
}

# Replace content in file.
# https://www.man7.org/linux/man-pages/man1/sed.1.html
function sed {
    param(
        [Parameter(Mandatory)]
        [string]$File,
        [Parameter(Mandatory)]
        [string]$Find,
        [Parameter(Mandatory)]
        [string]$Replace
    )

    try {
        (Get-Content $File) |
        ForEach-Object { $_ -replace $Find, $Replace } |
        Set-Content $File
        Write-Host "Successfully replaced text in: $File"
    }
    catch {
        Write-Error "Failed to modify file: $_"
    }
}

# Check if command exists.
function Test-CommandExists {
    param(
        [Parameter(Mandatory)]
        [string]$Command
    )

    $exists = $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
    return $exists
}

# Create environment variable.
# https://www.man7.org/linux/man-pages/man1/export.1p.html
function export {
    param(
        [Parameter(Mandatory)]
        [string]$Name,
        [Parameter(Mandatory)]
        [string]$Value
    )

    try {
        [Environment]::SetEnvironmentVariable($Name, $Value, 'Process')
        Write-Host "Environment variable set: $Name=$Value"
    }
    catch {
        Write-Error "Failed to set environment variable: $_"
    }
}

# Extract compressed files in a ZIP archive.
# https://linux.die.net/man/1/unzip
function unzip {
    param(
        [Parameter(Mandatory)]
        [string]$File,
        [string]$Destination = "."
    )

    try {
        Write-Host "Extracting $File to $Destination..."
        Expand-Archive -Path $File -DestinationPath $Destination
        Write-Host "Extraction completed successfully"
    }
    catch {
        Write-Error "Failed to extract archive: $_"
    }
}

# Tell how long the system has been running.
# https://www.man7.org/linux/man-pages/man1/uptime.1.html
function uptime {
    try {
        if ($PSVersionTable.PSVersion.Major -eq 5) {
            $bootTime = (Get-WmiObject win32_operatingsystem).LastBootUpTime
            $uptime = (Get-Date) - [Management.ManagementDateTimeConverter]::ToDateTime($bootTime)
        }
        else {
            $bootTime = Get-CimInstance Win32_OperatingSystem | Select-Object LastBootUpTime
            $uptime = (Get-Date) - $bootTime.LastBootUpTime
        }

        return [PSCustomObject]@{
            Days = $uptime.Days
            Hours = $uptime.Hours
            Minutes = $uptime.Minutes
            Seconds = $uptime.Seconds
            TotalHours = [math]::Round($uptime.TotalHours, 2)
        }
    }
    catch {
        Write-Error "Failed to get uptime: $_"
    }
}

# Create a new empty file.
# https://www.man7.org/linux/man-pages/man1/touch.1.html
function touch {
    param(
        [Parameter(Mandatory)]
        [string]$File
    )

    try {
        if (Test-Path $File) {
            (Get-Item $File).LastWriteTime = Get-Date
        }
        else {
            New-Item -ItemType File -Path $File
        }
    }
    catch {
        Write-Error "Failed to touch file: $_"
    }
}

# Report file system space usage.
# https://www.man7.org/linux/man-pages/man1/df.1.html
function df {
    try {
        Get-Volume | Select-Object DriveLetter, FileSystemLabel,
                              @{N='Size(GB)';E={[math]::Round($_.Size/1GB,2)}},
                              @{N='FreeSpace(GB)';E={[math]::Round($_.SizeRemaining/1GB,2)}},
                              @{N='FreeSpace(%)';E={[math]::Round($_.SizeRemaining/$_.Size*100,2)}}
    }
    catch {
        Write-Error "Failed to get disk information: $_"
    }
}

# Run command with admin privileges.
function sudo {
    param([string[]]$Command)

    try {
        if ($Command.Count -gt 0) {
            $argList = "& {$($Command -join ' ')}"
            Start-Process pwsh -Verb RunAs -ArgumentList "-NoExit", "-Command", $argList
        }
        else {
            Start-Process pwsh -Verb RunAs
        }
    }
    catch {
        Write-Error "Failed to elevate privileges: $_"
    }
}

# Edit current profile.
function Edit-Profile {
    try {
        if (Test-CommandExists $EDITOR) {
            & $EDITOR $PROFILE.CurrentUserAllHosts
        }
        else {
            Write-Error "Default editor not found: $EDITOR"
        }
    }
    catch {
        Write-Error "Failed to open profile: $_"
    }
}

# Function to get the actual profile path
function Get-PowerShellPaths {
    try {
        # Get actual Documents folder location from registry
        $shell = New-Object -ComObject Shell.Application
        $documents = $shell.Namespace('shell:Personal').Self.Path

        # Build paths for both PowerShell 5 and 7
        $paths = @{
            PS5 = @{
                Directory = Join-Path $documents "WindowsPowerShell"
                Profile = Join-Path $documents "WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
            }
            PS7 = @{
                Directory = Join-Path $documents "PowerShell"
                Profile = Join-Path $documents "PowerShell\Microsoft.PowerShell_profile.ps1"
            }
            CurrentVersion = $PSVersionTable.PSVersion.Major
            DocumentsPath = $documents
        }

        # Add current profile path based on PowerShell version
        $paths.CurrentProfilePath = if ($PSVersionTable.PSVersion.Major -ge 6) {
            $paths.PS7.Profile
        } else {
            $paths.PS5.Profile
        }

        return $paths
    }
    catch {
        Write-Error "Failed to get PowerShell paths: $_"
    }
    finally {
        if ($null -ne $shell) {
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | Out-Null
        }
    }
}

# Function to check if we already checked for updates since last boot
function Test-UpdateCheckedSinceBoot {
    try {
        if (-not (Test-Path $UPDATE_CHECK_FILE)) {
            return $false
        }

        $lastCheck = Get-Content $UPDATE_CHECK_FILE -ErrorAction Stop

        # Get last boot time
        if ($PSVersionTable.PSVersion.Major -eq 5) {
            $lastBoot = (Get-WmiObject win32_operatingsystem).LastBootUpTime
            $lastBootTime = [Management.ManagementDateTimeConverter]::ToDateTime($lastBoot)
        } else {
            $lastBoot = Get-CimInstance Win32_OperatingSystem | Select-Object LastBootUpTime
            $lastBootTime = $lastBoot.LastBootUpTime
        }

        # Convert stored time back to datetime
        $lastCheckTime = [datetime]::ParseExact($lastCheck, "yyyy-MM-dd HH:mm:ss", $null)

        # Return true if we've checked since last boot
        return $lastCheckTime -gt $lastBootTime
    }
    catch {
        Write-Error "Failed to check update status: $_"
        return $false
    }
}

# Function to mark that we've checked for updates
function Set-UpdateChecked {
    try {
        Get-Date -Format "yyyy-MM-dd HH:mm:ss" | Out-File $UPDATE_CHECK_FILE -Force
    }
    catch {
        Write-Error "Failed to set update check status: $_"
    }
}

# Enhanced Update-PowerShell-Profile function
function Update-PowerShell-Profile {
    try {
        if (-not (Test-InternetConnection)) {
            throw "No internet connection available"
        }

        Write-Host "Checking for profile updates..."
        $tempFile = Join-Path $env:TEMP "Microsoft.PowerShell_profile.ps1"
        $paths = Get-PowerShellPaths

        # Create directories if they don't exist
        @($paths.PS5.Directory, $paths.PS7.Directory) | ForEach-Object {
            if (-not (Test-Path $_)) {
                Write-Host "Creating directory: $_"
                New-Item -Type Directory -Path $_ -Force | Out-Null
            }
        }

        # Download new profile
        Invoke-WebRequest -Uri $GITHUB_REPO_URL -OutFile $tempFile

        # Compare hashes
        $currentHash = Get-FileHash $PROFILE -ErrorAction SilentlyContinue
        $newHash = Get-FileHash $tempFile

        if ($newHash.Hash -ne $currentHash.Hash) {
            Write-Host "New profile version found. Updating..."

            # Update profile
            Copy-Item -Path $tempFile -Destination $paths.PS7.Profile -Force
            Write-Host "Profile updated successfully"

            # Create SymLink for PWSH 5
            Write-Host "Creating symbolic link for PowerShell 5..."
            if (Test-Path $paths.PS5.Profile) {
                Remove-Item $paths.PS5.Profile -Force
            }
            New-Item -ItemType SymbolicLink -Path $paths.PS5.Profile -Target $paths.PS7.Profile

            # Reload profile
            Write-Host "Profile initialization complete!"
            Write-Host "You may need to restart PowerShell for changes to take effect."
            return $true
        }
        else {
            Write-Host "Profile is already up to date"
            return $false
        }
    }
    catch {
        Write-Error "Failed to update profile: $_"
        return $false
    }
    finally {
        Remove-Item $tempFile -ErrorAction SilentlyContinue
        Set-UpdateChecked
    }
}

# Set default editor.
$EDITOR = if (Test-CommandExists notepad++) { 'notepad++' }
          elseif (Test-CommandExists code) { 'code' }
          elseif (Test-CommandExists vim) { 'vim' }
          else { 'notepad' }
Set-Alias -Name edit -Value $EDITOR

# Create common aliases
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name touch -Value New-Item
Set-Alias -Name whereis -Value which
Set-Alias -Name sudo -Value Start-ProcessAsAdmin

# Check for updates once per boot
if (-not (Test-UpdateCheckedSinceBoot)) {
    Write-Host "Checking for profile updates since last boot..."
    Update-PowerShell-Profile
}

# Initialize profile
Write-Host "PowerShell Profile v$SCRIPT_VERSION loaded successfully"
if (Test-AdminPrivileges) {
    Write-Host "Running with administrator privileges" -ForegroundColor Red
}

# Load local user settings if they exist
if (Test-Path $PROFILE_LOCAL) {
    try {
        . $PROFILE_LOCAL
        Write-Host "Loaded local profile customizations"
    }
    catch {
        Write-Error "Failed to load local profile: $_"
    }
}
