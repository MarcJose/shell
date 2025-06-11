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
            'Docker.DockerDesktop',
            'ExclaimerLtd.CloudSignatureUpdateAgent',
            # 'IDRIX.VeraCrypt',
            # 'Microsoft.Edge',
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

function Install-Scoop {
    Write-Status "Checking Scoop installation..."

    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Status "Scoop is already installed" -Color "Green"
        return
    }

    try {
        Write-Status "Installing Scoop..."

        # Install Scoop
        Invoke-RestMethod get.scoop.sh | Invoke-Expression

        Write-Status "Scoop installed successfully" -Color "Green"
    }
    catch {
        Write-Status "Failed to install Scoop: $_" -Color "Red"
    }
}

function Install-ScoopPackages {
    try {
        Write-Status "Installing Scoop packages..." -Color "Yellow"

        # Install git first if not present
        if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
            Write-Status "Installing git..."
            scoop install main/git                       # Git
            reg import "$env:USERPROFILE\scoop\apps\git\current\install-context.reg"
            reg import "$env:USERPROFILE\scoop\apps\git\current\install-file-associations.reg"
            scoop install main/git-lfs                   # Git-LFS
            scoop install main/git-crypt                 # Git-Crypt
            scoop install main/gnupg                     # GNUPg Encryption and Signing Tool
            scoop install main/aria2                     # Aria2 Downloading Tool
            scoop install main/fzf                       # FZF
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
            'versions'      # Alternative versions of apps found in other buckets.
        )

        foreach ($bucket in $buckets) {
            Write-Status "Adding bucket: $bucket"
            scoop bucket add $bucket
        }

        scoop install main/7zip
        reg import "$env:USERPROFILE\scoop\apps\7zip\current\install-context.reg"

        scoop install extras/vcredist                    # Microsoft Visual C++ Redistributable
        scoop install extras/git-credential-manager      # Git Credentials Manager
        scoop install extras/keepassxc                   # KeePassXC Password Manager
        #scoop install extras/sysinternals                # Microsoft Sysinternals

        # Office
        #scoop install extras/libreoffice                 # LibreOffice
        #scoop install extras/onlyoffice-desktopeditors   # OnlyOffice
        scoop install extras/notepadplusplus             # Notepad++
        reg import "$env:USERPROFILE\scoop\apps\notepadplusplus\current\install-context.reg"
        #scoop install extras/obsidian                    # Obsidian
        #scoop install extras/krita                       # Krita
        #scoop install extras/kate                        # Kate
        #scoop install extras/okular                      # Okular

        # Media
        scoop install extras/vlc                         # VLC
        #scoop install extras/inkscape                    # Inkscape
        #scoop install extras/gimp                        # Gimp

        # Internet
        scoop install extras/firefox                     # Firefox
        scoop install extras/chromium                    # Chromium
        New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\Chromium\User Data" -Target "C:\Users\$env:USERNAME\scoop\apps\chromium\current\User Data"
        $regPath = "HKCR:\ChromiumHTM.5U2HY26ANXMR5BC3YLOQSZI5DU\shell\open\command"
        if (!(Test-Path $regPath)) {
          New-Item -Path $regPath -Force
        }
        $regValue = "`"C:\Users\$env:USERNAME\scoop\apps\chromium\current\chrome.exe`" --user-data-dir=`"C:\Users\$env:USERNAME\scoop\apps\chromium\current\User Data`" %1"
        Set-ItemProperty -Path $regPath -Name "(Default)" -Value $regValue

        # Programming / IDE's
        scoop install extras/vscode                      # Visual Studio Code
        reg import "$env:USERPROFILE\scoop\apps\vscode\current\install-context.reg"
        reg import "$env:USERPROFILE\scoop\apps\vscode\current\install-associations.reg"
        #scoop install extras/jetbrains-toolbox           # Jetbrains Toolbox

        # Communication
        #scoop install extras/mattermost                  # Mattermost
        #scoop install extras/slack                       # Slack
        #scoop install extras/element                     # Element
        #scoop install extras/rocketchat-client           # Rocket Chat
        #scoop install extras/signal                      # Signal
        #scoop install extras/telegram                    # Telegram
        #scoop install extras/zoom                        # Zoom

        # Windows
        scoop install extras/windows-terminal
        reg import "$env:USERPROFILE\scoop\apps\windows-terminal\current\install-context.reg"
        #scoop install extras/microsoft-teams
        #scoop install nonportable/office-365-apps-np
        scoop install extras/powertoys
        Invoke-Expression -Command "$env:USERPROFILE\scoop\apps\powertoys\current\install-context.ps1"

        # Nerd Fonts
        scoop install nerd-fonts/DejaVuSansMono-NF
        scoop install nerd-fonts/DejaVuSansMono-NF-Mono
        scoop install nerd-fonts/DejaVuSansMono-NF-Propo
        scoop install nerd-fonts/RobotoMono-NF
        scoop install nerd-fonts/RobotoMono-NF-Mono
        scoop install nerd-fonts/RobotoMono-NF-Propo
        scoop install nerd-fonts/JetBrainsMono-NF
        scoop install nerd-fonts/JetBrainsMono-NF-Mono
        scoop install nerd-fonts/JetBrainsMono-NF-Propo

        # Java
        scoop install java/openjdk
        #scoop install java/oraclejdk

        # Security
        #scoop install nonportable/protonvpn-np
        #scoop install extras/wireshark
        #& "$env:USERPROFILE\scoop\apps\wireshark\current\npcap-installer.exe"
        #& "$env:USERPROFILE\scoop\apps\wireshark\current\USBPcapSetup-installer.exe"
        #scoop install main/nmap

        # Virtualization
        #scoop install nonportable/virtualbox-with-extension-pack-np

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

            "ms-edgedevtools.vscode-edge-devtools",

            "EditorConfig.EditorConfig",                            # EditorConfig
            'esbenp.prettier-vscode',                               # Prettier
            "DavidAnson.vscode-markdownlint",                       # Markdown Linter
            'wayou.vscode-todo-highlight',                          # TODO Highlight
            "usernamehw.errorlens",                                 # Error Highlighter

            'ms-vscode-remote.remote-wsl',                          # WSL
            'ms-vscode-remote.remote-ssh',                          # Remote SSH
            "ms-vscode-remote.remote-ssh-edit"                      # Remote SSH (Configs)
            'ms-vscode.remote-explorer',                            # Remote Explorer
            "tomsaunders.vscode-workspace-explorer",                # Workspace Explorer

            'eamodio.gitlens',                                      # GitLens
            "github.vscode-github-actions",                         # GitHub Actions
            "GitHub.vscode-pull-request-github",                    # GitHub Pull Requests

            'ms-kubernetes-tools.vscode-aks-tools',
            'ms-codespaces-tools.ado-codespaces-auth',
            'ms-vscode.powershell',                                 # PowerShell

            'ms-vscode.hexeditor',                                  # Hex Editor
            'redhat.vscode-yaml',                                   # YAML
            "mechatroner.rainbow-csv",                              # CSV
            "jock.svg",                                             # SVG
            "bierner.markdown-checkbox",                            # Markdown Checkboxes
            "bierner.markdown-emoji",                               # Markdown Emojis
            "bierner.markdown-footnotes",                           # Markdown Footnotes
            "bierner.markdown-preview-github-styles",               # Markdown Preview Github
            "bierner.markdown-mermaid",                             # Markdown Mermaid Diagrams
            "bierner.markdown-yaml-preamble",                       # Markdown YAML
            "johnpapa.read-time",                                   # Reading Time
            "ms-vscode.wordcount",                                  # Word Count

            "ms-vscode.powershell",

            'ms-vscode.live-server',                                # Live Server
            'ms-vsliveshare.vsliveshare'                            # Live Share
        )

        foreach ($extension in $extensions) {
            Write-Status "Installing extension: $extension"
            code --install-extension $extension
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

        # Install WSL
        Write-Status "Installing WSL..."
        wsl --install --no-distribution

        # Set WSL 2 as default
        Write-Status "Setting WSL 2 as default..."
        wsl --set-default-version 2

        # Create WSL config
        $totalMemoryGB = [math]::Floor((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
        $WSL_MEMORY = if ($totalMemoryGB -gt 32) {
            16  # Cap at 16GB for high-memory systems
        } elseif ($totalMemoryGB -gt 16) {
            8   # 8GB for systems with 16-32GB
        } else {
            [math]::Floor($totalMemoryGB / 2)  # Half of available memory for low-memory systems
        }
        $totalCPUs = [Environment]::ProcessorCount
        $WSL_CPU_CORES = if ($totalCPUs -gt 16) {
            8   # Cap at 8 cores for high-CPU systems
        } else {
            [math]::Floor($totalCPUs / 2)  # Half of available cores
        }
        @"
[wsl2]
# Limits WSL2's memory to n gigabytes
memory=${WSL_MEMORY}GB
# Enable UI applications
guiApplications = true

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
            Install-Scoop
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
