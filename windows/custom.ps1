#Requires -Version 5.1
param(
    [switch]$Force,
    [switch]$SkipWinget,
    [switch]$SkipScoop,
    [switch]$SkipVSCode,
    [switch]$SkipWSL
)

$ErrorActionPreference = 'Stop'

function Write-Status {
    param(
        [string]$Message,
        [string]$Color = 'Cyan'
    )
    Write-Host ">>> $Message" -ForegroundColor $Color
}

function Install-WingetPackages {
    try {
        Write-Status "Installing Winget packages..." -Color "Yellow"

        $wingetPackages = @(
            'Microsoft.OpenSSH.Beta',
            'Microsoft.PowerShell',
            'ExclaimerLtd.CloudSignatureUpdateAgent',
            'IDRIX.VeraCrypt',
            'Microsoft.Edge',
            'Adobe.Acrobat.Reader.64-bit'
        )

        foreach ($package in $wingetPackages) {
            Write-Status "Installing $package..."
            winget install --exact --silent --accept-source-agreements --accept-package-agreements $package
        }

        Write-Status "Winget packages installed successfully" -Color "Green"
    }
    catch {
        Write-Status "Failed to install Winget packages: $_" -Color "Red"
        throw
    }
}

function Install-ScoopPackages {
    try {
        Write-Status "Installing Scoop packages..." -Color "Yellow"

        # Install git first if not present
        if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
            Write-Status "Installing git..."
            scoop install main/git
            reg import "$env:USERPROFILE\scoop\apps\git\current\install-context.reg"
            reg import "$env:USERPROFILE\scoop\apps\git\current\install-file-associations.reg"
            scoop install main/git-lfs
            scoop install main/git-crypt
            scoop install main/gnupg
            scoop install main/aria2
            scoop config aria2-warning-enabled false
        }

        # Ensure required buckets are added
        $buckets = @(
            'main',         # Default bucket which contains popular non-GUI apps.
            'extras',       # Apps that do not fit the main bucket's criteria.
            'games',        # Open-source and freeware video games and game-related tools.
            'nerd-fonts',   # Nerd Fonts.
            'nirsoft',      # A collection of over 250+ apps from Nirsoft.
            'sysinternals', # The Sysinternals suite from Microsoft.
            'java',         # A collection of Java development kits (JDKs) and Java runtime engines (JREs), Java's virtual machine debugging tools and Java based runtime engines.
            'nonportable',  # Non-portable apps (may trigger UAC prompts).
            'php',          # Installers for most versions of PHP.
            'versions',     # Alternative versions of apps found in other buckets.
        )

        foreach ($bucket in $buckets) {
            Write-Status "Adding bucket: $bucket"
            scoop bucket add $bucket
        }

        scoop install main/7zip
        reg import "$env:USERPROFILE\scoop\apps\7zip\current\install-context.reg"

        scoop install extras/vcredist
        scoop install extras/git-credential-manager
        scoop install extras/keepassxc

        scoop install extras/libreoffice
        scoop install extras/onlyoffice-desktopeditors
        scoop install extras/notepadplusplus
        reg import "$env:USERPROFILE\scoop\apps\notepadplusplus\current\install-context.reg"
        scoop install extras/obsidian
        scoop install extras/krita
        scoop install extras/kate
        scoop install extras/okular

        scoop install extras/vlc
        scoop install extras/inkscape
        scoop install extras/gimp

        scoop install extras/firefox
        scoop install extras/chromium

        scoop install extras/vscode
        reg import "$env:USERPROFILE\scoop\apps\vscode\current\install-context.reg"
        reg import "$env:USERPROFILE\scoop\apps\vscode\current\install-associations.reg"
        scoop install extras/jetbrains-toolbox

        scoop install extras/mattermost
        scoop install extras/slack
        scoop install extras/element
        scoop install extras/rocketchat-client
        scoop install extras/signal
        scoop install extras/telegram
        scoop install extras/zoom

        scoop install extras/windows-terminal
        reg import "$env:USERPROFILE\scoop\apps\windows-terminal\current\install-context.reg"
        scoop install extras/microsoft-teams

        scoop install nerd-fonts/DejaVuSansMono-NF
        scoop install nerd-fonts/DejaVuSansMono-NF-Mono
        scoop install nerd-fonts/DejaVuSansMono-NF-Propo
        scoop install nerd-fonts/RobotoMono-NF
        scoop install nerd-fonts/RobotoMono-NF-Mono
        scoop install nerd-fonts/RobotoMono-NF-Propo
        scoop install nerd-fonts/JetBrainsMono-NF
        scoop install nerd-fonts/JetBrainsMono-NF-Mono
        scoop install nerd-fonts/JetBrainsMono-NF-Propo

        scoop install java/openjdk
        scoop install java/oraclejdk

        scoop install nonportable/office-365-apps-np
        scoop install nonportable/powertoys-np
        scoop install nonportable/protonvpn-np
        scoop install nonportable/virtualbox-with-extension-pack-np

        # Update all installed packages
        Write-Status "Updating all packages..."
        scoop update *

        # Cleanup old versions
        Write-Status "Cleaning up old versions..."
        scoop cleanup *

        Write-Status "Scoop packages installed successfully" -Color "Green"

        # Optional: Show installed packages
        Write-Status "Installed packages:"
        scoop list
    }
    catch {
        Write-Status "Failed to install Scoop packages: $_" -Color "Red"
        throw
    }
}

function Install-VSCodeExtensions {
    try {
        Write-Status "Installing VSCode extensions..." -Color "Yellow"

        $extensions = @(
            "MS-CEINTL.vscode-language-pack-de",                    # German Language Pack
            "ms-dotnettools.vscode-dotnet-runtime",

            "VisualStudioExptTeam.vscodeintellicode",
            "VisualStudioExptTeam.intellicode-api-usage-examples",
            "VisualStudioExptTeam.vscodeintellicode-completions",
            "VisualStudioExptTeam.vscodeintellicode-insiders",


            "EditorConfig.EditorConfig",                            # EditorConfig
            'esbenp.prettier-vscode',                               # Prettier
            "DavidAnson.vscode-markdownlint",                       # Markdown Linter
            'wayou.vscode-todo-highlight',                          # TODO Highlight
            "usernamehw.errorlens",                                 # Error Highlighter

            'ms-vscode-remote.remote-wsl',                          # WSL
            'ms-vscode-remote.remote-ssh',                          # Remote SSH
            'ms-vscode.remote-explorer',                            # Remote Explorer
            "tomsaunders.vscode-workspace-explorer",                # Workspace Explorer

            'eamodio.gitlens',                                      # GitLens
            "github.vscode-github-actions",                         # GitHub Actions
            "GitHub.vscode-pull-request-github",                    # GitHub Pull Requests

            'ms-vscode.powershell',                                 # PowerShell
            'ms-vscode.hexeditor',                                  # Hex Editor
            'redhat.vscode-yaml',                                   # YAML
            "mechatroner.rainbow-csv",                              # CSV
            "jock.svg",                                             # SVG

            'ms-vscode.live-server',                                # Live Server
            'ms-vsliveshare.vsliveshare'                            # Live Share
        )

        foreach ($extension in $extensions) {
            Write-Status "Installing extension: $extension"
            "$env:USERPROFILE\scoop\apps\vscode\current\bin\code" --install-extension $extension
        }

        Write-Status "VSCode extensions installed successfully" -Color "Green"
    }
    catch {
        Write-Status "Failed to install VSCode extensions: $_" -Color "Red"
        throw
    }
}

function Setup-WSL {
    try {
        Write-Status "Setting up WSL..." -Color "Yellow"

        # Enable WSL feature
        Write-Status "Enabling Windows Subsystem for Linux..."
        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

        Write-Status "Enabling Virtual Machine Platform..."
        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

        # Install WSL
        Write-Status "Installing WSL..."
        wsl --install --no-distribution

        # Set WSL 2 as default
        Write-Status "Setting WSL 2 as default..."
        wsl --set-default-version 2

        # Create WSL config
        $WSL_CPU_CORES = [Environment]::ProcessorCount / 2
        $WSL_MEMORY = ((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum / 1gb) / 2
        @"
[wsl2]
# Limits WSL2's memory to n gigabytes
memory=${WSL_MEMORY}GB

# Allocates n virtual CPU cores to WSL2
processors=${WSL_CPU_CORES}

# Enables localhost forwarding between Windows and Linux
# Disabled due to mirrored network mode
#localhostForwarding=true

# Uses mirrored networking mode to share the Windows network interface
networkingMode=mirrored
"@ | Tee-Object -FilePath "$env:USERPROFILE\.wslconfig"

        # Install Ubuntu 24.04
        Write-Status "Installing Ubuntu 24.04..."
        wsl --install -d Ubuntu-24.04

        Write-Status "WSL setup completed successfully. A restart may be required." -Color "Green"
        Write-Status "After restart, Ubuntu will complete its setup on first launch." -Color "Yellow"
    }
    catch {
        Write-Status "Failed to setup WSL: $_" -Color "Red"
        throw
    }
}

# Main setup function
function Start-CustomSetup {
    Write-Status "Starting custom setup..." -Color "Yellow"

    try {
        # Install Winget packages
        if (-not $SkipWinget) {
            Install-WingetPackages
        }

        # Install Scoop packages
        if (-not $SkipScoop) {
            Install-ScoopPackages
        }

        # Install VSCode extensions
        if (-not $SkipVSCode) {
            if (Get-Command code -ErrorAction SilentlyContinue) {
                Install-VSCodeExtensions
            } else {
                Write-Status "VSCode not found. Skipping extension installation." -Color "Yellow"
            }
        }

        # Setup WSL
        if (-not $SkipWSL) {
            Setup-WSL
            Write-Status "NOTE: System restart required to complete WSL setup" -Color "Yellow"
        }

        Write-Status "Custom setup completed successfully!" -Color "Green"

        # Check if restart is needed
        if (-not $SkipWSL) {
            $restart = Read-Host "Would you like to restart now to complete WSL setup? (y/n)"
            if ($restart -eq 'y') {
                Restart-Computer -Force
            }
        }
    }
    catch {
        Write-Status "Setup failed: $_" -Color "Red"
        exit 1
    }
}

# Run setup
Start-CustomSetup
