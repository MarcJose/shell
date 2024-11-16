#Requires -Version 5.1
param(
    [switch]$CreateSymLink,
    [switch]$Force,
    [switch]$CreateLocalProfile,
    [switch]$SkipPackageManagers
)

$ErrorActionPreference = 'Stop'
$GITHUB_REPO_URL = "https://raw.githubusercontent.com/MarcJose/shell/main/windows/Microsoft.PowerShell_profile.ps1"

function Write-Status {
    param(
        [string]$Message,
        [string]$Color = 'Cyan'
    )
    Write-Host ">>> $Message" -ForegroundColor $Color
}

function Test-AdminPrivileges {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]$identity
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}



function Remove-DefaultBloat {
    $apps = @(
        "Microsoft.549981C3F5F10"
        "Microsoft.3DBuilder"
        "Microsoft.Appconnector"
        "Microsoft.BingFinance"
        "Microsoft.BingNews"
        "Microsoft.BingSports"
        "Microsoft.BingTranslator"
        "Microsoft.BingWeather"
        "Microsoft.FreshPaint"
        "Microsoft.GamingServices"
        "Microsoft.Microsoft3DViewer"
        "Microsoft.MicrosoftPowerBIForWindows"
        "Microsoft.MicrosoftSolitaireCollection"
        "Microsoft.MicrosoftStickyNotes"
        "Microsoft.MinecraftUWP"
        "Microsoft.NetworkSpeedTest"
        "Microsoft.People"
        "Microsoft.Print3D"
        "Microsoft.SkypeApp"
        "Microsoft.Wallet"
        "Microsoft.WindowsAlarms"
        "microsoft.windowscommunicationsapps"
        "Microsoft.WindowsMaps"
        "Microsoft.WindowsPhone"
        "Microsoft.WindowsSoundRecorder"
        "Microsoft.Xbox.TCUI"
        "Microsoft.XboxApp"
        "Microsoft.XboxGameOverlay"
        "Microsoft.XboxGamingOverlay"
        "Microsoft.XboxSpeechToTextOverlay"
        "Microsoft.YourPhone"
        "Microsoft.ZuneMusic"
        "Microsoft.ZuneVideo"
        "Microsoft.CommsPhone"
        "Microsoft.ConnectivityStore"
        "Microsoft.GetHelp"
        "Microsoft.Getstarted"
        "Microsoft.Messaging"
        "Microsoft.OneConnect"
        "Microsoft.WindowsFeedbackHub"
        "Microsoft.Microsoft3DViewer"
        "Microsoft.BingFoodAndDrink"
        "Microsoft.BingHealthAndFitness"
        "Microsoft.BingTravel"
        "Microsoft.WindowsReadingList"
        "Microsoft.MixedReality.Portal"
        "Microsoft.ScreenSketch"
        "Microsoft.XboxGamingOverlay"
        "Microsoft.YourPhone"
        "2FE3CB00.PicsArt-PhotoStudio"
        "46928bounde.EclipseManager"
        "4DF9E0F8.Netflix"
        "613EBCEA.PolarrPhotoEditorAcademicEdition"
        "6Wunderkinder.Wunderlist"
        "7EE7776C.LinkedInforWindows"
        "89006A2E.AutodeskSketchBook"
        "9E2F88E3.Twitter"
        "A278AB0D.DisneyMagicKingdoms"
        "A278AB0D.MarchofEmpires"
        "ActiproSoftwareLLC.562882FEEB491"
        "CAF9E577.Plex"
        "ClearChannelRadioDigital.iHeartRadio"
        "D52A8D61.FarmVille2CountryEscape"
        "D5EA27B7.Duolingo-LearnLanguagesforFree"
        "DB6EA5DB.CyberLinkMediaSuiteEssentials"
        "DolbyLaboratories.DolbyAccess"
        "DolbyLaboratories.DolbyAccess"
        "Drawboard.DrawboardPDF"
        "Facebook.Facebook"
        "Fitbit.FitbitCoach"
        "Flipboard.Flipboard"
        "GAMELOFTSA.Asphalt8Airborne"
        "KeeperSecurityInc.Keeper"
        "NORDCURRENT.COOKINGFEVER"
        "PandoraMediaInc.29680B314EFC2"
        "Playtika.CaesarsSlotsFreeCasino"
        "ShazamEntertainmentLtd.Shazam"
        "SlingTVLLC.SlingTV"
        "SpotifyAB.SpotifyMusic"
        "TheNewYorkTimes.NYTCrossword"
        "ThumbmunkeysLtd.PhototasticCollage"
        "TuneIn.TuneInRadio"
        "WinZipComputing.WinZipUniversal"
        "XINGAG.XING"
        "flaregamesGmbH.RoyalRevolt2"
        "king.com.*"
        "king.com.BubbleWitch3Saga"
        "king.com.CandyCrushSaga"
        "king.com.CandyCrushSodaSaga"
        "Microsoft.Advertising.Xaml"
    )

    Write-Status "Removing bloat packages..." -Color "Yellow"
    foreach ($app in $apps) {
        try {
            $appVersion = (Get-AppxPackage -Name $app).Version
              Get-AppxPackage -Name $app -AllUsers `
                    | Remove-AppxPackage -AllUsers
                Get-AppXProvisionedPackage -Online `
                    | Where-Object DisplayName -EQ $app `
                    | Remove-AppxProvisionedPackage -Online
                $appPath="$Env:LOCALAPPDATA\Packages\$app*"
                Remove-Item $appPath -Recurse -Force -ErrorAction 0
        }
        catch {
          Write-Status "Failed to remove bloat package: $_" -Color "Red"
        }
    }
}

function Install-NPipeRelay {
    try {
        Write-Status "Installing npiperelay..." -Color "Yellow"

        $url = "https://github.com/jstarks/npiperelay/releases/latest/download/npiperelay_windows_amd64.zip"
        $DestinationFolder = "C:\Program Files\npiperelay"
        $Temp = $env:TEMP

        if (-not (Test-Path $DestinationFolder)) {
            New-Item -ItemType Directory -Path $DestinationFolder | Out-Null
        }

        Invoke-WebRequest -Uri $url -OutFile "$Temp\npiperelay.zip"
        Expand-Archive -Path "$Temp\npiperelay.zip" -DestinationPath $DestinationFolder -Force
        Remove-Item -Path "$Temp\npiperelay.zip" -Force

        Write-Status "npiperelay installed successfully" -Color "Green"
    }
    catch {
        Write-Status "Failed to install npiperelay: $_" -Color "Red"
        throw
    }
}

function Install-WinGet {
    Write-Status "Checking WinGet installation..."

    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Status "WinGet is already installed" -Color "Green"
        return
    }

    try {
        Write-Status "Installing WinGet..."

        # Check Windows version (requires Windows 10 1809 or later)
        $osVersion = [System.Environment]::OSVersion.Version
        if ($osVersion.Major -lt 10 -or ($osVersion.Major -eq 10 -and $osVersion.Build -lt 17763)) {
            throw "WinGet requires Windows 10 1809 or later"
        }

        # Install WinGet using the Microsoft Store app installer
        $hasPackageManager = Get-AppxPackage -Name "Microsoft.DesktopAppInstaller"

        if (-not $hasPackageManager) {
            # Download latest release from GitHub
            $releases = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
            $download = (Invoke-RestMethod -Uri $releases).assets |
                       Where-Object { $_.browser_download_url -like "*msixbundle" } |
                       Select-Object -First 1 -ExpandProperty browser_download_url

            $installer = Join-Path $env:TEMP "winget.msixbundle"
            Invoke-WebRequest -Uri $download -OutFile $installer

            # Install the package
            Add-AppxPackage -Path $installer
            Remove-Item $installer -Force
        }

        # Verify installation
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            Write-Status "WinGet installed successfully" -Color "Green"
        } else {
            throw "WinGet installation failed verification"
        }
    }
    catch {
        Write-Status "Failed to install WinGet: $_" -Color "Red"
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

        # Set execution policy for current user
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

        # Install Scoop
        Invoke-RestMethod get.scoop.sh | Invoke-Expression

        # Add extra buckets
        Write-Status "Adding Scoop buckets..."
        scoop bucket add extras
        scoop bucket add versions
        scoop bucket add nerd-fonts

        # Update Scoop
        Write-Status "Updating Scoop..."
        scoop update

        Write-Status "Scoop installed successfully" -Color "Green"
    }
    catch {
        Write-Status "Failed to install Scoop: $_" -Color "Red"
    }
}

function Install-Chocolatey {
    Write-Status "Checking Chocolatey installation..."

    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Status "Chocolatey is already installed" -Color "Green"
        return
    }

    try {
        Write-Status "Installing Chocolatey..."

        # Set execution policy and TLS
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

        # Install Chocolatey
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

        # Verify installation
        if (Get-Command choco -ErrorAction SilentlyContinue) {
            Write-Status "Chocolatey installed successfully" -Color "Green"
        } else {
            throw "Chocolatey installation failed verification"
        }
    }
    catch {
        Write-Status "Failed to install Chocolatey: $_" -Color "Red"
    }
}

function Get-PowerShellPaths {
    $shell = New-Object -ComObject Shell.Application
    try {
        $documents = $shell.Namespace('shell:Personal').Self.Path

        return @{
            PS5 = @{
                Directory = Join-Path $documents "WindowsPowerShell"
                Profile = Join-Path $documents "WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
            }
            PS7 = @{
                Directory = Join-Path $documents "PowerShell"
                Profile = Join-Path $documents "PowerShell\Microsoft.PowerShell_profile.ps1"
            }
            DocumentsPath = $documents
        }
    }
    finally {
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | Out-Null
    }
}

function New-LocalProfileTemplate {
    param([string]$Path)

    if (Test-Path $Path) {
        Write-Warning "Local profile already exists at: $Path"
        return
    }

    @'
# Local PowerShell Profile Customizations
# This file won't be overwritten by updates from the repository

# Example: Custom environment variables
# $env:MY_CUSTOM_VAR = "my-value"

# Example: Custom aliases
# Set-Alias -Name myalias -Value MyFunction

# Example: Custom prompt modifications
# function Prompt {
#     $original = $global:Prompt
#     "$env:COMPUTERNAME $original"
# }

# Example: Custom functions
# function My-CustomFunction {
#     Write-Host "This is my custom function"
# }

Write-Host "Loaded local profile customizations"
'@ | Out-File -FilePath $Path -Encoding utf8NoBOM

    Write-Host "Created local profile template at: $Path"
}

function Install-PowerShellProfile {
    try {
        Write-Status "Starting PowerShell profile installation..." -Color "Yellow"

        # Check admin privileges and warn if not admin
        if (-not (Test-AdminPrivileges)) {
            Write-Status "Warning: Running without administrator privileges. Some features may be limited." -Color "Yellow"
            $continue = Read-Host "Do you want to continue? (Y/N)"
            if ($continue -ne 'Y') {
                Write-Status "Installation aborted. Please run as Administrator for full functionality." -Color "Red"
                return
            }
        }

        # Install package managers if not skipped
        if (-not $SkipPackageManagers) {
            Write-Status "Setting up package managers..." -Color "Yellow"

            if (Test-AdminPrivileges) {
                Install-WinGet
                Install-Chocolatey
            } else {
                Write-Status "Skipping WinGet and Chocolatey installation (requires admin privileges)" -Color "Yellow"
            }
            # Scoop can be installed without admin privileges
            Install-Scoop
        }

        # Get profile paths
        $paths = Get-PowerShellPaths
        Write-Status "Documents folder located at: $($paths.DocumentsPath)"

        # Create directories
        @($paths.PS5.Directory, $paths.PS7.Directory) | ForEach-Object {
            if (-not (Test-Path $_)) {
                Write-Status "Creating directory: $_"
                New-Item -Type Directory -Path $_ -Force | Out-Null
            }
        }

        # Download profile
        $tempFile = Join-Path $env:TEMP "Microsoft.PowerShell_profile.ps1"
        Write-Status "Downloading profile from GitHub..."
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $GITHUB_REPO_URL -OutFile $tempFile

        # Deploy profile
        if ($CreateSymLink) {
            Write-Status "Deploying with symbolic link..."

            # Deploy to PS7 location
            if (Test-Path $paths.PS7.Profile) {
                if ($Force) {
                    Remove-Item $paths.PS7.Profile -Force
                } else {
                    throw "PowerShell 7 profile already exists. Use -Force to overwrite."
                }
            }
            Copy-Item -Path $tempFile -Destination $paths.PS7.Profile -Force

            # Create symlink for PS5
            if (Test-Path $paths.PS5.Profile) {
                if ($Force) {
                    Remove-Item $paths.PS5.Profile -Force
                } else {
                    throw "PowerShell 5 profile already exists. Use -Force to overwrite."
                }
            }
            New-Item -ItemType SymbolicLink -Path $paths.PS5.Profile -Target $paths.PS7.Profile
        } else {
            Write-Status "Deploying separate profiles..."
            Copy-Item -Path $tempFile -Destination $paths.PS5.Profile -Force
            Copy-Item -Path $tempFile -Destination $paths.PS7.Profile -Force
        }

        # Create local profile if requested
        if ($CreateLocalProfile) {
            @($paths.PS5.Directory, $paths.PS7.Directory) | ForEach-Object {
                $localProfile = Join-Path $_ "Microsoft.PowerShell_profile.local.ps1"
                if (-not (Test-Path $localProfile)) {
                    Write-Status "Creating local profile at: $localProfile"
                    New-LocalProfileTemplate -Path $localProfile
                }
            }
        }

        Write-Status "Installation completed successfully!" -Color "Green"
        Write-Status "PowerShell 5 profile: $($paths.PS5.Profile)"
        Write-Status "PowerShell 7 profile: $($paths.PS7.Profile)"
        Write-Status "Please restart PowerShell for changes to take effect."
    }
    catch {
        Write-Status "Installation failed: $_" -Color "Red"
    }
    finally {
        Remove-Item $tempFile -ErrorAction SilentlyContinue
    }
}

# Run the installation
Remove-DefaultBloat
Install-NPipeRelay
Install-PowerShellProfile -CreateSymLink:$CreateSymLink -Force:$Force -CreateLocalProfile:$CreateLocalProfile
