#==============================================================================
# ~/.profile: User Environment Configuration
#==============================================================================
# This file serves as the main configuration file for user environment setup.
# It is sourced by login shells and sets up:
# - Environment variables
# - XDG base directories
# - Application-specific configurations
# - System detection and environment setup
# - Shell functions and utilities
# - Common aliases and shortcuts
#------------------------------------------------------------------------------


#==============================================================================
# Terminal Color Definitions
#==============================================================================
# These ANSI escape codes define colors and text effects for terminal output.
# Format: \e[<code>m where <code> defines the color or effect
#------------------------------------------------------------------------------
# Text Effects
#------------------------------------------------------------------------------
# Hidden text (same color as background)
HIDDEN="\e[8m"
# Inverted colors (swap foreground/background)
INVERT="\e[7m"
# Underlined text
UNDERLINED="\e[4m"
# Dimmed text intensity
DIM="\e[2m"
# Bold text
BOLD="\e[1m"
#------------------------------------------------------------------------------
# Foreground Colors (Text Colors)
#------------------------------------------------------------------------------
# Standard Colors (30-37)
FG_BLACK="\e[30m"
FG_RED="\e[31m"
FG_GREEN="\e[32m"
FG_YELLOW="\e[33m"
FG_BLUE="\e[34m"
FG_MAGENTA="\e[35m"
FG_CYAN="\e[36m"
FG_LIGHTGREY="\e[37m"
# Bright Colors (90-97)
FG_GREY="\e[90m"
FG_LIGHTRED="\e[91m"
FG_LIGHTGREEN="\e[92m"
FG_LIGHTYELLOW="\e[93m"
FG_LIGHTBLUE="\e[94m"
FG_LIGHTMAGENTA="\e[95m"
FG_LIGHTCYAN="\e[96m"
FG_WHITE="\e[97m"
#------------------------------------------------------------------------------
# Background Colors
#------------------------------------------------------------------------------
# Standard Colors (40-47)
BG_BLACK="\e[40m"
BG_RED="\e[41m"
BG_GREEN="\e[42m"
BG_YELLOW="\e[43m"
BG_BLUE="\e[44m"
BG_MAGENTA="\e[45m"
BG_CYAN="\e[46m"
BG_LIGHTGREY="\e[47m"
# Bright Colors (100-107)
BG_GREY="\e[100m"
BG_LIGHTRED="\e[101m"
BG_LIGHTGREEN="\e[102m"
BG_LIGHTYELLOW="\e[103m"
BG_LIGHTBLUE="\e[104m"
BG_LIGHTMAGENTA="\e[105m"
BG_LIGHTCYAN="\e[106m"
BG_WHITE="\e[107m"
# Reset Code
# Reset all colors and effects
ENDENC="\e[0m"


#==============================================================================
# XDG Base Directory Specification
#==============================================================================
# Implementation of XDG Base Directory Specification
# See: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
# Core XDG Directories
#------------------------------------------------------------------------------
# User-specific configuration files
XDG_CONFIG_HOME="${HOME}/.config"
# User-specific non-essential data
XDG_CACHE_HOME="${HOME}/.cache"
# User-specific data files
XDG_DATA_HOME="${HOME}/.local/share"
# User-specific state files
XDG_STATE_HOME="${HOME}/.local/state"
# User-specific runtime files
XDG_RUNTIME_DIR="/run/user/$(id -u)"
# System-wide directories
# System data directories
XDG_DATA_DIRS="/usr/local/share:/usr/share"
# System config directories
XDG_CONFIG_DIRS="/etc/xdg"
#------------------------------------------------------------------------------
# Application-Specific XDG Configurations
#------------------------------------------------------------------------------
# Development Tools
#------------------------------------------------------------------------------
BUN_INSTALL="${XDG_DATA_HOME}/bun"
# Rust package manager
CARGO_HOME="${XDG_DATA_HOME}/cargo"
GDBHISTFILE="${XDG_DATA_HOME}/gdb/history"
CONDARC="${XDG_CONFIG_HOME}/conda/condarc"
# Go modules cache
GOMODCACHE="${XDG_CACHE_HOME}/go/mod"
# Go workspace
GOPATH="${XDG_DATA_HOME}/go"
# Gradle build tool
GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle"
# NPM configuration
NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
# Python version manager
PYENV_ROOT="${XDG_DATA_HOME}/pyenv"
PYLINTHOME="${XDG_CACHE_HOME}/pylint"
PYLINTRC="${XDG_CONFIG_HOME}/pylint/pylintrc"
PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
PYTHONUSERBASE="${XDG_DATA_HOME}/python"
PYTHON_EGG_CACHE="${XDG_CACHE_HOME}/python-eggs"
PYTHON_HISTORY="${XDG_STATE_HOME}/python/history"
# Rust toolchain manager
RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
_JAVA_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java -Djavafx.cachedir=${XDG_CACHE_HOME}/openjfx -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"
JAVA_TOOL_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java -Djavafx.cachedir=${XDG_CACHE_HOME}/openjfx -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"
JDK_JAVA_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java -Djavafx.cachedir=${XDG_CACHE_HOME}/openjfx -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"
JULIAUP_DEPOT_PATH="${XDG_DATA_HOME}/julia"
JULIA_DEPOT_PATH="${XDG_DATA_HOME}/julia:${JULIA_DEPOT_PATH}"
JUPYTER_PLATFORM_DIRS="1"
R_HISTFILE="${XDG_CONFIG_HOME}/R/history"
R_HOME_USER="${XDG_CONFIG_HOME}/R"
R_PROFILE_USER="${XDG_CONFIG_HOME}/R/profile"
#------------------------------------------------------------------------------
# Shell and Terminal
#------------------------------------------------------------------------------
BASH_COMPLETION_USER_FILE="${XDG_CONFIG_HOME}/bash-completion/bash_completion"
# Readline configuration
INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
# Screen configuration
SCREENRC="${XDG_CONFIG_HOME}/screen/screenrc"
# Terminal information
TERMINFO="${XDG_DATA_HOME}/terminfo"
TERMINFO_DIRS="${XDG_DATA_HOME}/terminfo:/usr/share/terminfo"
VIMINIT='let $MYVIMRC="${XDG_CONFIG_HOME}/vim/vimrc" | source ${MYVIMRC}'
GVIMINIT='let $MYGVIMRC="${XDG_CONFIG_HOME}/vim/gvimrc" | source ${MYGVIMRC}'
# ZSH configuration directory
ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
#------------------------------------------------------------------------------
# Version Control Systems
#------------------------------------------------------------------------------
# Git configuration
GIT_CONFIG_GLOBAL="${XDG_CONFIG_HOME}/git/config"
# GPG configuration
GNUPGHOME="${XDG_DATA_HOME}/gnupg"
# SVN configuration
SVN_CONFIG_DIR="${XDG_CONFIG_HOME}/subversion"
#------------------------------------------------------------------------------
# Development Environments and IDEs
#------------------------------------------------------------------------------
# Atom editor
ATOM_HOME="${XDG_DATA_HOME}/atom"
JUPYTER_CONFIG_DIR="${XDG_CONFIG_HOME}/jupyter"
JUPYTER_PLATFORM_DIRS="1"
# VS Code
VSCODE_PORTABLE="${XDG_DATA_HOME}/vscode"
MYPY_CACHE_DIR="${XDG_CACHE_HOME}/mypy"
#------------------------------------------------------------------------------
# Build and Package Management
#------------------------------------------------------------------------------
# Gradle
GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle"
# Rust/Cargo
CARGO_HOME="${XDG_DATA_HOME}/cargo"
# Ruby gems
GEM_HOME="${XDG_DATA_HOME}/gem"
GEM_SPEC_CACHE="${XDG_CACHE_HOME}/gem"
# Maven
MAVEN_USER_HOME="${XDG_CONFIG_HOME}/maven"
NVM_DIR="${XDG_DATA_HOME}/nvm"
#------------------------------------------------------------------------------
# Cloud and Infrastructure Tools
#------------------------------------------------------------------------------
AWS_CONFIG_FILE="${XDG_CONFIG_HOME}/aws/config"
AWS_SHARED_CREDENTIALS_FILE="${XDG_CONFIG_HOME}/aws/credentials"
AZURE_CONFIG_DIR="${XDG_DATA_HOME}/azure"
DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
KUBECONFIG="${XDG_CONFIG_HOME}/kube"
KUBECACHEDIR="${XDG_CACHE_HOME}/kube"
K9SCONFIG="${XDG_CONFIG_HOME}/k9s"
MACHINE_STORAGE_PATH="${XDG_DATA_HOME}/docker-machine"
MINIKUBE_HOME="${XDG_DATA_HOME}/minikube"
#------------------------------------------------------------------------------
# Database Tools
#------------------------------------------------------------------------------
MYSQL_HISTFILE="${XDG_DATA_HOME}/mysql_history"
PSQLRC="${XDG_CONFIG_HOME}/pg/psqlrc"
PGPASSFILE="${XDG_CONFIG_HOME}/pg/pgpass"
SQLITE_HISTORY="${XDG_DATA_HOME}/sqlite_history"
#------------------------------------------------------------------------------
# Multimedia Applications
#------------------------------------------------------------------------------
MPLAYER_HOME="${XDG_CONFIG_HOME}/mplayer"
FFMPEG_DATADIR="${XDG_CONFIG_HOME}/ffmpeg"
#------------------------------------------------------------------------------
# Other Applications
#------------------------------------------------------------------------------
ACKRC="${XDG_CONFIG_HOME}/ack/ackrc"
ANSIBLE_CONFIG="${XDG_CONFIG_HOME}/ansible.cfg"
ANSIBLE_GALAXY_CACHE_DIR="${XDG_CACHE_HOME}/ansible/galaxy_cache"
ANSIBLE_HOME="${XDG_CONFIG_HOME}/ansible"
CUDA_CACHE_PATH="${XDG_CACHE_HOME}/nv"
# Shell history
HISTFILE="${XDG_STATE_HOME}/history/history"
# Less pager history
LESSHISTFILE="${XDG_CACHE_HOME}/less/history"
WGETRC="${XDG_CONFIG_HOME}/wgetrc"
ASDF_CONFIG_FILE="${XDG_CONFIG_HOME}/asdf/asdfrc"
ASDF_DATA_DIR="${XDG_DATA_HOME}/asdf"
ASPELL_CONF="per-conf ${XDG_CONFIG_HOME}/aspell/aspell.conf; personal ${XDG_CONFIG_HOME}/aspell/en.pws; repl ${XDG_CONFIG_HOME}/aspell/en.prepl"
BOGOFILTER_DIR="${XDG_DATA_HOME}/bogofilter"
C3270PRO="${XDG_CONFIG_HOME}/c3270/config"
CALCHISTFILE="${XDG_CACHE_HOME}/calc_history"
CD_BOOKMARK_FILE="${XDG_CONFIG_HOME}/cd-bookmark/bookmarks"
CGDB_DIR="${XDG_CONFIG_HOME}/cgdb"
CHKTEXRC="${XDG_CONFIG_HOME}/chktex"
CIN_CONFIG="${XDG_CONFIG_HOME}/bcast5"
CONAN_USER_HOME="${XDG_CONFIG_HOME}"
CRAWL_DIR="${XDG_DATA_HOME}/crawl/"
DISCORD_USER_DATA_DIR="${XDG_DATA_HOME}"
DOT_SAGE="${XDG_CONFIG_HOME}/sage"
DVDCSS_CACHE="${XDG_DATA_HOME}/dvdcss"
EASYOCR_MODULE_PATH="${XDG_CONFIG_HOME}/EasyOCR"
ELECTRUMDIR="${XDG_DATA_HOME}/electrum"
ELINKS_CONFDIR="${XDG_CONFIG_HOME}/elinks"
ELM_HOME="${XDG_CONFIG_HOME}/elm"
EM_CACHE="${XDG_CACHE_HOME}/emscripten/cache"
EM_CONFIG="${XDG_CONFIG_HOME}/emscripten/config"
EM_PORTS="${XDG_DATA_HOME}/emscripten/cache"
FCEUX_HOME="${XDG_CONFIG_HOME}/fceux"
GETIPLAYERUSERPREFS="${XDG_DATA_HOME}/get_iplayer"
GHCUP_USE_XDG_DIRS="true"
GHCUP_USE_XDG_DIRS=true
GQRC="${XDG_CONFIG_HOME}/gqrc"
GQSTATE="${XDG_DATA_HOME}/gq/gq-state"
GRC_PREFS_PATH="${XDG_CONFIG_HOME}/gnuradio/grc.conf"
GRIPHOME="${XDG_CONFIG_HOME}/grip"
GR_PREFS_PATH="${XDG_CONFIG_HOME}/gnuradio"
GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"
GTK_RC_FILES="${XDG_CONFIG_HOME}/gtk-1.0/gtkrc"
HOUDINI_USER_PREF_DIR="${XDG_CACHE_HOME}/houdini__HVER__"
ICEAUTHORITY="${XDG_CACHE_HOME}/ICEauthority"
IMAPFILTER_HOME="${XDG_CONFIG_HOME}/imapfilter"
IPFS_PATH="${XDG_DATA_HOME}/ipfs"
IRBRC="${XDG_CONFIG_HOME}/irb/irbrc"
KDEHOME="${XDG_CONFIG_HOME}/kde"
KODI_DATA="${XDG_DATA_HOME}/kodi"
KSCRIPT_CACHE_DIR="${XDG_CACHE_HOME}/kscript"
LEDGER_FILE="${XDG_DATA_HOME}/hledger.journal"
LEIN_HOME="${XDG_DATA_HOME}/lein"
LYNX_CFG_PATH="${XDG_CONFIG_HOME}/lynx.cfg"
MATHEMATICA_USERBASE="${XDG_CONFIG_HOME}/mathematica"
MAXIMA_USERDIR="${XDG_CONFIG_HOME}/maxima"
MEDNAFEN_HOME="${XDG_CONFIG_HOME}/mednafen"
MIX_XDG="true"
MOST_INITFILE="${XDG_CONFIG_HOME}/mostrc"
NODENV_ROOT="${XDG_DATA_HOME}/nodenv"
NODE_REPL_HISTORY="${XDG_DATA_HOME}/node_repl_history"
NUGET_PACKAGES="${XDG_CACHE_HOME}/NuGetPackages"
N_PREFIX="${XDG_DATA_HOME}/n"
OCTAVE_HISTFILE="${XDG_CACHE_HOME}/octave-hsts"
OCTAVE_SITE_INITFILE="${XDG_CONFIG_HOME}/octave/octaverc"
OLLAMA_MODELS="${XDG_DATA_HOME}/ollama/models"
OMNISHARPHOME="${XDG_CONFIG_HOME}/omnisharp"
OPAMROOT="${XDG_DATA_HOME}/opam"
PARALLEL_HOME="${XDG_CONFIG_HOME}/parallel"
PASSWORD_STORE_DIR="${XDG_DATA_HOME}/pass"
PGSERVICEFILE="${XDG_CONFIG_HOME}/pg/pg_service.conf"
PLATFORMIO_CORE_DIR="${XDG_DATA_HOME}/platformio"
PLTUSERHOME="${XDG_DATA_HOME}/racket"
PSQL_HISTORY="${XDG_STATE_HOME}/psql_history"
RBENV_ROOT="${XDG_DATA_HOME}/rbenv"
RECOLL_CONFDIR="${XDG_CONFIG_HOME}/recoll"
REDISCLI_HISTFILE="${XDG_DATA_HOME}/redis/rediscli_history"
REDISCLI_RCFILE="${XDG_CONFIG_HOME}/redis/redisclirc"
RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"
RLWRAP_HOME="${XDG_DATA_HOME}/rlwrap"
RUFF_CACHE_DIR="${XDG_CACHE_HOME}/ruff"
RXVT_SOCKET="${XDG_RUNTIME_DIR}/urxvtd"
SINGULARITY_CACHEDIR="${XDG_CACHE_HOME}/singularity"
SINGULARITY_CONFIGDIR="${XDG_CONFIG_HOME}/singularity"
SOLARGRAPH_CACHE="${XDG_CACHE_HOME}/solargraph"
SPACEMACSDIR="${XDG_CONFIG_HOME}/spacemacs"
SSB_HOME="${XDG_DATA_HOME}/zoom"
STACK_ROOT="${XDG_DATA_HOME}/stack"
STACK_XDG=1
STARSHIP_CACHE="${XDG_CACHE_HOME}/starship"
STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship.toml"
TEXMACS_HOME_PATH="${XDG_STATE_HOME}/texmacs"
TEXMFCONFIG="${XDG_CONFIG_HOME}/texlive/texmf-config"
TEXMFHOME="${XDG_DATA_HOME}/texmf"
TEXMFVAR="${XDG_CACHE_HOME}/texlive/texmf-var"
TRAVIS_CONFIG_PATH="${XDG_CONFIG_HOME}/travis"
TS3_CONFIG_DIR="${XDG_CONFIG_HOME}/ts3client"
UNCRUSTIFY_CONFIG="${XDG_CONFIG_HOME}/uncrustify/uncrustify.cfg"
UNISON="${XDG_DATA_HOME}/unison"
VAGRANT_ALIAS_FILE="${XDG_DATA_HOME}/vagrant/aliases"
VAGRANT_HOME="${XDG_DATA_HOME}/vagrant"
VIMPERATOR_INIT=":source ${XDG_CONFIG_HOME}/vimperator/vimperatorrc"
VIMPERATOR_RUNTIME="${XDG_CONFIG_HOME}/vimperator"
W3M_DIR="${XDG_STATE_HOME}/w3m"
WAKATIME_HOME="${XDG_CONFIG_HOME}/wakatime"
WINEPREFIX="${XDG_DATA_HOME}/wineprefixes/default"
WORKON_HOME="${XDG_DATA_HOME}/virtualenvs"
X3270PRO="${XDG_CONFIG_HOME}/x3270/config"
# Deactivated as it seems to break java/awt applications
#export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"
XCOMPOSECACHE="${XDG_CACHE_HOME}/X11/xcompose"
XCOMPOSEFILE="${XDG_CONFIG_HOME}/X11/xcompose"
XINITRC="${XDG_CONFIG_HOME}/X11/xinitrc"
XSERVERRC="${XDG_CONFIG_HOME}/X11/xserverrc"
_Z_DATA="${XDG_DATA_HOME}/z"


#==============================================================================
# System Detection and Environment Setup
#==============================================================================
#------------------------------------------------------------------------------
# Graphics Driver Detection and Configuration
#------------------------------------------------------------------------------
# Detect graphics hardware and configure appropriate drivers
GPU_VENDOR=$(lspci -vnn | grep 'VGA compatible controller')
if echo "${GPU_VENDOR}" | grep -qi 'nvidia'; then
    # NVIDIA GPU configuration
    # VA-API driver
    export LIBVA_DRIVER_NAME='nvidia'
    # VDPAU driver
    export VDPAU_DRIVER='nvidia'
    # Generic Buffer Management backend
    export GBM_BACKEND='nvidia-drm'
    # GLX provider
    export __GLX_VENDOR_LIBRARY_NAME='nvidia'
elif echo "${GPU_VENDOR}" | grep -Eiq 'amd|radeon'; then
    # AMD GPU configuration
    # VA-API driver for AMD
    export LIBVA_DRIVER_NAME='radeonsi'
    # Use VA-API as VDPAU backend
    export VDPAU_DRIVER='va_gl'
elif echo "${GPU_VENDOR}" | grep -iq 'intel'; then
    # Intel GPU configuration
    # VA-API driver for Intel
    export LIBVA_DRIVER_NAME='i965'
    # Use VA-API as VDPAU backend
    export VDPAU_DRIVER='va_gl'
fi
#------------------------------------------------------------------------------
# Display Server Detection and Configuration
#------------------------------------------------------------------------------
# Configure environment for Wayland or X11
#Let Electron choose platform
export ELECTRON_OZONE_PLATFORM_HINT="auto"
if [ "${XDG_SESSION_TYPE}" = "wayland" ]; then
    # Wayland-specific configuration
    # Enable Wayland support in Firefox
    export MOZ_ENABLE_WAYLAND=1
    # QT: Try Wayland, fallback to X11
    export QT_QPA_PLATFORM="wayland;xcb"
    # Use Wayland for Clutter
    export CLUTTER_BACKEND="wayland"
    # SDL: Try Wayland, fallback to X11
    export SDL_VIDEODRIVER="wayland,x11"
else
    # X11-specific configuration
    # QT: Use X11
    export QT_QPA_PLATFORM="xcb"
    # Use X11 for Clutter
    export CLUTTER_BACKEND="x11"
    # SDL: Use X11
    export SDL_VIDEODRIVER="x11"
    # Rust winit: Use X11
    export WINIT_UNIX_BACKEND="x11"
fi
#------------------------------------------------------------------------------
# System Information Collection
#------------------------------------------------------------------------------
# Gather various system details for environment setup and monitoring
# Current kernel version
export KERNEL="$(uname --kernel-release)"
# CPU information: model name from /proc/cpuinfo
export CPU="$(grep -m 1 'model name' /proc/cpuinfo | awk '{print $4 " " $5 " " $6 " " $7 " " $9 " " $10}')"
# GPU information: extract from lspci output
export GPU="$(lspci | grep ' VGA ' | grep -E -o -m 1 '\[.*\]' | cut -c 2- | rev | cut -c 2- | rev)"
# RAM size in GB
export RAM="$(expr "$(grep -m 1 'MemTotal' /proc/meminfo | awk '{print $2}')" / 1000 / 1000)"
# MAC address of first network interface
export MAC="$(macchanger -s "$(ls /sys/class/net | awk '{print $1}' | head -n 1)" | head -n 1 | awk '{print $3}')"
# Public IP address with fallback
export IP="$(curl -s -m 3  http://my.ip.fi/ || echo 'No connection')"
#------------------------------------------------------------------------------
# Shell Environment Configuration
#------------------------------------------------------------------------------
# Basic shell behavior and interaction settings
# Default text editor
export EDITOR='nano'
# GPG terminal device
export GPG_TTY=$(tty)
# Shell history size
export HISTSIZE=1000000
# Saved history size
export SAVEHIST=1000000
# Less pager settings
export LESS='-R --use-color -Dd+r$Du+b'
# Man page viewer
export MANPAGER="less -R --use-color -Dd+r -Du+b"
# Man page formatting
export MANROFFOPT="-P -c"
# Python I/O encoding
export PYTHONIOENCODING='UTF-8'
# Editor for sudo operations
export SUDO_EDITOR='nano'
# Visual editor
export VISUAL='nano'
# Disable WSL installation prompts
export DONT_PROMPT_WSL_INSTALL='yes'
# SSH agent socket
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
#------------------------------------------------------------------------------
# Database and Development Settings
#------------------------------------------------------------------------------
# IBM DB2 Configuration
export IBM_DB_HOME='${XDG_DATA_HOME}/python/lib/python3.12/site-packages/clidriver'
export LD_LIBRARY_PATH='${IBM_DB_HOME}/lib:${LD_LIBRARY_PATH}'
#------------------------------------------------------------------------------
# FZF (Fuzzy Finder) Configuration
#------------------------------------------------------------------------------
# Configure the fuzzy finder tool behavior
# Enable ANSI color support
export FZF_DEFAULT_OPTS="--ansi"
# Define default command to use for file search
export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*' -not -path '*/\.terraform/*'"
# Configure specific commands for different operations
# Ctrl-T file search
export FZF_CTRL_T_OPTS="
  --walker-skip .git,.next,.terraform,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
  --header 'Find files (Ctrl + / to switch preview)'"
# Alt-C directory search
export FZF_ALT_C_OPTS="
  --walker-skip .git,.next,.terraform,node_modules,target
  --preview 'tree -C {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
  --header 'Find subdirectories (Ctrl + / to switch preview)'"
export FZF_CTRL_R_OPTS="
  --color header:italic
  --header 'Search history'"
#------------------------------------------------------------------------------
# Path Configuration
#------------------------------------------------------------------------------
# Set default umask for file creation
# User: rwx, Group: r-x, Others: ---
umask 027
# Add user-specific binary directories to PATH
if [ -d "${HOME}/bin" ]; then
    # Personal binaries
    PATH="${HOME}/bin:${PATH}"
fi
if [ -d "${HOME}/.local/bin" ]; then
    # Local user binaries
    PATH="${HOME}/.local/bin:${PATH}"
fi
# Add language-specific paths
if [ -d "${BUN_INSTALL}" ]; then
    # Bun runtime
    PATH="${BUN_INSTALL}:${PATH}"
fi
# Add development tool paths
if [ -d "${XDG_DATA_HOME}/JetBrains/Toolbox/scripts" ]; then
    # JetBrains tools
    PATH="${XDG_DATA_HOME}/JetBrains/Toolbox/scripts:${PATH}"
fi


#==============================================================================
# Function Definitions
#==============================================================================
#------------------------------------------------------------------------------
# System Configuration and Tools
#------------------------------------------------------------------------------
# Evaluate dircolors if available
if [ -d "${XDG_CONFIG_HOME}/dircolors" ]; then
    eval "$(dircolors "${XDG_CONFIG_HOME}/dircolors")"
fi
# Setup Anaconda environment if installed
if [ -d '/opt/anaconda/bin' ]; then
    __conda_setup="$('/opt/anaconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ ${?} -eq 0 ]; then
        eval "${__conda_setup}"
    else
        if [ -f "/opt/anaconda/etc/profile.d/conda.sh" ]; then
            . "/opt/anaconda/etc/profile.d/conda.sh"
        else
            export PATH="/opt/anaconda/bin:${PATH}"
        fi
    fi
    unset __conda_setup
fi
# Load Node Version Manager if available
if [ -f /usr/share/nvm/init-nvm.sh ]; then
    . /usr/share/nvm/init-nvm.sh > /dev/null
fi
# Load Deno if available
if [ -f "${HONE}/deno/env" ]; then
    . "${HONE}/deno/env" > /dev/null
fi
#------------------------------------------------------------------------------
# Output Formatting Functions
#------------------------------------------------------------------------------
# Colored message output functions for different types of messages
# Error messages
__error()   { printf "${FG_RED}[ERROR]: %b${ENDENC}\n" "$*" >&2; }
# Warning messages
__warning() { printf "${FG_YELLOW}[WARN]: %b${ENDENC}\n" "$*" >&2; }
# Information messages
__info()    { printf "${FG_WHITE}[INFO]: %b${ENDENC}\n" "$*" >&1; }
# Debug messages
__debug()   { printf "${FG_GREY}[DEBUG]: %b${ENDENC}\n" "$*" >&1; }
#------------------------------------------------------------------------------
# FZF Integration Functions
#------------------------------------------------------------------------------
# FZF command completion runner with preview windows
_fzf_comprun() {
    command=$1
    shift

    case "${command}" in
        # Directory preview
        cd)           fzf --preview 'ls -lah {} | head 100' "$@";;
        # Environment variable preview
        export|unset) fzf --preview "eval 'echo \$'{}" "$@";;
        # SSH host preview
        ssh)          fzf --preview 'dig {}' "$@";;
        # Default file preview
        *)            fzf --preview 'bat -n -f -r :500 {} ' "$@";;
    esac
}
# Interactive directory navigation with FZF
fcd() {
    directory=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) && \
    cd "${directory}"
}
# Find in files using grep and edit
fif() {
    if [ ! "$#" -gt 0 ]; then
        echo "Need a string to search for!"
        return 1
    fi

    fileToEdit=$(find . -type f -not -path '*/\.git/*' -not -path '*/\.terraform/*' -exec grep -l "$1" {} \; | fzf --preview "grep -n -C 3 '$1' {}") && \
    [ -n "${fileToEdit}" ] && ${EDITOR:-vim} "${fileToEdit}"
}
# Interactive environment variable viewer
fenv() {
    outEnv=$(env | fzf)
    echo $(echo ${outEnv} | cut -d= -f2)
}
# Interactive process killer
fkill() {
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    [ "x$pid" != "x" ] && echo $pid | xargs kill -${1:-9}
}
# SSH host selector
fssh() {
    if [ -f ~/.ssh/config ]; then
        sshhost=$(grep "^Host " ~/.ssh/config | grep -v "[?*]" | cut -d ' ' -f 2- | fzf)
        [ ! -z "$sshhost" ] && ssh "$sshhost"
    else
        echo "No SSH config file found"
    fi
}
#------------------------------------------------------------------------------
# Git Integration Functions
#------------------------------------------------------------------------------
# Interactive git add with preview
gadd() {
    git ls-files -m -o --exclude-standard | fzf -m --preview 'git diff --color=always {} | head -500' | xargs -r git add
}
# Create .gitignore file using gitignore.io
gitignore() {
    if [ -z "$1" ] || [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
        AVAILABLE_FORMATS="$(curl --silent --fail --location https://www.gitignore.io/api/list | tr ',' '\n' | column --fillrows)"
        echo 'Available formats:'
        echo "${AVAILABLE_FORMATS}"
        echo 'Use with gitignore <comma separated list of templates> > .gitignore.'
    else
        curl --silent --location --write-out '\n' https://www.gitignore.io/api/$@
    fi
}
# Fetch and pull all git branches
gitPullAll() {
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]; then
        git branch -r | \
        grep -v '\->' | \
        sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | \
        while read -r remote; do
            git branch --track "${remote#origin/}" "$remote"
        done

        git fetch --all
        git pull --all
    fi
}
#------------------------------------------------------------------------------
# AWS Integration Functions
#------------------------------------------------------------------------------
# AWS profile selector
aws_profile() {
    if [ -f ~/.aws/credentials ]; then
        profile=$(grep '^\[.*\]' ~/.aws/credentials | sed 's/\[\(.*\)\]/\1/' | fzf)
        if [ ! -z "$profile" ]; then
            export AWS_PROFILE="$profile"
            echo "AWS Profile set to: $profile"
        fi
    else
        echo "AWS credentials file not found"
        return 1
    fi
}
# AWS region selector
aws_region() {
    regions="
        af-south-1
        ap-east-1
        ap-northeast-1
        ap-northeast-2
        ap-northeast-3
        ap-south-1
        ap-south-2
        ap-southeast-1
        ap-southeast-2
        ap-southeast-3
        ap-southeast-4
        ap-southeast-5
        ca-central-1
        ca-west-1
        eu-central-1
        eu-central-2
        eu-north-1
        eu-south-1
        eu-south-2
        eu-west-1
        eu-west-2
        eu-west-3
        il-central-1
        me-central-1
        me-south-1
        sa-east-1
        us-east-1
        us-east-2
        us-west-1
        us-west-2
    "
    region=$(echo "$regions" | tr -d ' ' | fzf)
    [ ! -z "$region" ] && export AWS_DEFAULT_REGION="$region" && echo "AWS Region set to: $region"
}
# Combined AWS setup function
aws_setup() {
    aws_profile && aws_region
}
# AWS resource explorer
aws_resource_search() {
    resource_types="
        ec2:instances
        ec2:volumes
        rds:instances
        s3:buckets
        lambda:functions
        iam:roles
        eks:clusters
    "
    resource_type=$(echo "$resource_types" | grep -v '^$' | fzf)
    if [ ! -z "$resource_type" ]; then
        service=$(echo "$resource_type" | cut -d: -f1)
        resource=$(echo "$resource_type" | cut -d: -f2)
        aws $service describe-$resource | less
    fi
}
#------------------------------------------------------------------------------
# Terraform Management Functions
#------------------------------------------------------------------------------
# Terraform workspace selector
tf_workspace() {
    if [ -d .terraform ]; then
        terraform workspace list | grep -v "^*" | sed 's/^  //' | fzf | xargs terraform workspace select
    else
        echo "Not a Terraform directory"
        return 1
    fi
}
# Terraform state viewer
tf_state_view() {
    if [ -f terraform.tfstate ]; then
        terraform state list | fzf --preview "terraform state show {}"
    else
        echo "No terraform.tfstate file found"
        return 1
    fi
}
# Interactive Terraform plan
tf_plan() {
    if [ ! -d .terraform ]; then
        echo "Not a Terraform directory or not initialized"
        return 1
    fi

    workspace=$(terraform workspace show)
    changes=$(git status -s)

    if [ ! -z "$changes" ]; then
        echo "Warning: You have uncommitted changes:"
        echo "$changes"
        echo "Continue? (y/N)"
        read -r response
        if [ "$response" != "y" ] && [ "$response" != "Y" ]; then
            return 1
        fi
    fi

    plan_file="tfplan_${workspace}_$(date +%Y%m%d_%H%M%S)"
    plan_output=$(terraform plan -out="$plan_file" 2>&1)
    plan_exit=$?

    if [ $plan_exit -eq 0 ]; then
        echo "$plan_output"
        echo "Plan saved to: $plan_file"
        echo "Plan summary:"
        terraform show "$plan_file" | grep -E '^\s*[~+-]'

        echo "View full plan? (y/N)"
        read -r response
        [ "$response" = "y" ] || [ "$response" = "Y" ] && terraform show "$plan_file" | less
    else
        echo "Plan failed!"
        echo "$plan_output"
        return 1
    fi
}
# Terraform plan viewer
tf_plan_view() {
    find . -name "*.tfplan" | fzf --preview "terraform show {}"
}
# Apply latest Terraform plan
tf_apply() {
    latest_plan=$(find . -name "tfplan_*" -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" ")
    if [ ! -z "$latest_plan" ]; then
        echo "Found latest plan: $latest_plan"
        echo "Apply this plan? (y/N)"
        read -r response
        [ "$response" = "y" ] || [ "$response" = "Y" ] && terraform apply "$latest_plan"
    else
        echo "No plan files found"
        return 1
    fi
}
# Safe Terraform destroy with confirmations
tf_destroy() {
    if [ ! -d .terraform ]; then
        echo "Not a Terraform directory or not initialized"
        return 1
    fi

    workspace=$(terraform workspace show)

    echo "WARNING: You are about to destroy infrastructure in workspace: $workspace"
    echo "Type the workspace name to confirm: "
    read -r confirmation

    if [ "$confirmation" != "$workspace" ]; then
        echo "Abort: Workspace name does not match"
        return 1
    fi

    if echo "$workspace" | grep -iq "prod"; then
        echo "WARNING: This appears to be a production workspace!"
        echo "Type 'yes-destroy-production' to confirm: "
        read -r prod_confirmation
        if [ "$prod_confirmation" != "yes-destroy-production" ]; then
            echo "Abort: Production destroy not confirmed"
            return 1
        fi
    fi

    destroy_plan="tfdestroy_${workspace}_$(date +%Y%m%d_%H%M%S)"
    plan_output=$(terraform plan -destroy -out="$destroy_plan" 2>&1)
    plan_exit=$?

    if [ $plan_exit -eq 0 ]; then
        echo "$plan_output"
        echo "Destroy plan saved to: $destroy_plan"
        echo "Resources to be destroyed:"
        terraform show "$destroy_plan" | grep -E '^\s*-'

        echo "Review the destroy plan? (Y/n)"
        read -r review_response
        if [ "$review_response" != "n" ] && [ "$review_response" != "N" ]; then
            terraform show "$destroy_plan" | less
        fi

        echo "Proceed with destroy? Type 'destroy' to confirm: "
        read -r destroy_confirmation

        if [ "$destroy_confirmation" = "destroy" ]; then
            echo "Executing destroy plan..."
            terraform apply "$destroy_plan"
        else
            echo "Destroy aborted"
            return 1
        fi
    else
        echo "Plan failed!"
        echo "$plan_output"
        return 1
    fi
}
#------------------------------------------------------------------------------
# Utility Functions
#------------------------------------------------------------------------------
# Secure file copy over SSH using rsync
ssh_copy() {
    HOST="${1}"
    PORT="${2}"
    USER="${3}"
    SOURCE="${4}"
    TARGET="${5}"

    if [ -z "${HOST}" ] || [ -z "${PORT}" ] || [ -z "${USER}" ] || [ -z "${SOURCE}" ] || [ -z "${TARGET}" ]; then
        __error "Please call as ssh-copy HOST PORT USER SOURCE TARGET"
        return 1
    fi

    if ! ping -c 1 "${HOST}" > /dev/null 2>&1; then
        __error "Could not reach host: ${HOST}"
        return 1
    fi

    if [ ! -f "${SOURCE}" ] && [ ! -d "${SOURCE}" ]; then
        __error "Source file(s) not found at: ${SOURCE}"
        return 1
    fi

    rsync -vcrlptgoDHEAXh --delete --progress --stats \
        --rsh="ssh -p ${PORT}" "${SOURCE}" "${USER}"@"${HOST}":"${TARGET}"
}
# GPG key management
__gpg_upload() {
    fingerprint="${1}"

    # Upload to multiple keyservers for redundancy
    gpg --keyserver pgp.mit.edu --send-keys "${fingerprint}"
    gpg --keyserver keyring.debian.org --send-keys "${fingerprint}"
    gpg --keyserver keyserver.ubuntu.com --send-keys "${fingerprint}"
    gpg --keyserver pgp.surf.nl --send-keys "${fingerprint}"
    gpg --keyserver pgpkeys.eu --send-keys "${fingerprint}"
    gpg --export "${fingerprint}" | curl -T - "https://keys.openpgp.org"
}


#==============================================================================
# Alias Definitions
#==============================================================================
#------------------------------------------------------------------------------
# XDG Base Directory Compliance Aliases
#------------------------------------------------------------------------------
# These aliases modify default program behavior to respect XDG base directories
# Pattern: Redirect config/data files to standard XDG locations
# Development Tools
alias abook='abook --config "${XDG_CONFIG_HOME}/abook/abookrc" --datafile "${XDG_DATA_HOME}/abook/addressbook"'
alias bashdb='bashdb -x ${XDG_CONFIG_HOME:-$HOME/.config}/bashdb/bashdbinit'
alias cargo='cargo --config "${XDG_CONFIG_HOME}/cargo/config"'
alias gem='gem --config-file "${XDG_CONFIG_HOME}/gem/config"'
alias mvn='mvn -gs "${XDG_CONFIG_HOME}/maven/settings.xml"'
alias npm='npm --userconfig "${XDG_CONFIG_HOME}/npm/npmrc"'
# Shell and Terminal
alias petite='petite --eehistory "${XDG_DATA_HOME}/chezscheme/history"'
alias screen='screen -c "${XDG_CONFIG_HOME}/screen/screenrc"'
alias tmux='tmux -f "${XDG_CONFIG_HOME}/tmux/tmux.conf"'
# System Tools
alias wget='wget --quiet --hsts-file="${XDG_CACHE_HOME}/wget-hsts" --continue --show-progress'
alias ltrace='ltrace -F "${XDG_CONFIG_HOME}/ltrace/ltrace.conf"'
alias gpg='gpg --homedir "${XDG_DATA_HOME}/gnupg"'
alias gpg2='gpg2 --homedir "${XDG_DATA_HOME}/gnupg"'
# Desktop Applications
alias conky='conky --config="${XDG_CONFIG_HOME}/conky/conkyrc"'
alias dosbox='dosbox -conf "${XDG_CONFIG_HOME}/dosbox/dosbox.conf"'
alias mplayer='mplayer -config "${XDG_CONFIG_HOME}/mplayer/config"'
alias nvidia-settings='nvidia-settings --config="${XDG_CONFIG_HOME}/nvidia/settings"'
# Development Environments
alias code='code --extensions-dir "${XDG_DATA_HOME}/vscode"'
alias vscodium='vscodium --extensions-dir "${XDG_DATA_HOME}/vscode"'
# Build Tools
alias emcc='emcc --em-config "${XDG_CONFIG_HOME}/emscripten/config" --em-cache "${XDG_CACHE_HOME}/emscripten/cache"'
# Communication Tools
alias irssi='irssi --config="${XDG_CONFIG_HOME}/irssi/config" --home="${XDG_DATA_HOME}/irssi"'
alias claws-mail='claws-mail --alternate-config-dir "${XDG_DATA_HOME}/claws-mail"'
alias mbsync='mbsync -c "${XDG_CONFIG_HOME}/isync/mbsyncrc"'
# System Configuration
alias xbindkeys='xbindkeys -f "${XDG_CONFIG_HOME}/xbindkeys/config"'
alias xrdb='xrdb -load "${XDG_CONFIG_HOME}/X11/xresources"'
alias keychain='keychain --absolute --dir "${XDG_RUNTIME_DIR}/keychain"'
# Package Management
alias yarn='yarn --use-yarnrc "${XDG_CONFIG_HOME}/yarn/config"'
# Documentation Tools
alias info='info --init-file "${XDG_CONFIG_HOME}/infokey"'
alias vale='vale --config "${XDG_CONFIG_HOME}/vale/config.ini"'
# Remote Desktop
alias x2goclient='x2goclient --home="${XDG_CONFIG_HOME}"'
# Others
alias cssh='cssh --config-file "${XDG_CONFIG_HOME}/clusterssh/config"'
alias getmail='getmail --rcfile="${XDG_CONFIG_HOME}/getmail/getmailrc" --getmaildir="${XDG_DATA_HOME}/getmail"'
alias gliv='gliv --glivrc="${XDG_CONFIG_HOME}/gliv/glivrc"'
alias ledger='ledger --init-file "${XDG_CONFIG_HOME}/ledgerrc"'
alias mitmproxy='mitmproxy --set confdir="${XDG_CONFIG_HOME}/mitmproxy"'
alias mitmweb='mitmweb --set confdir="${XDG_CONFIG_HOME}/mitmproxy"'
alias mocp='mocp -M "${XDG_CONFIG_HOME}/moc" -O MOCDir="${XDG_CONFIG_HOME}/moc"'
alias monerod='monerod --data-dir "${XDG_DATA_HOME}/bitmonero"'
alias mysql-workbench='mysql-workbench --configdir="${XDG_DATA_HOME}/mysql/workbench"'
alias ncmpc='ncmpc -f "${XDG_CONFIG_HOME}/ncmpc/config"'
alias netbeans='netbeans --userdir "${XDG_CONFIG_HOME}/netbeans"'
alias pidgin='pidgin --config="${XDG_DATA_HOME}/purple"'
alias sbt='sbt -ivy "${XDG_DATA_HOME}/ivy2" -sbt-dir "${XDG_DATA_HOME}/sbt"'
alias svn='svn --config-dir "${XDG_CONFIG_HOME}/subversion"'
alias titop='tiptop -W "${XDG_CONFIG_HOME}/tiptop"'
alias units='units --history "${XDG_CACHE_HOME}/units_history"'
alias alpine='alpine -p "${XDG_CONFIG_HOME}/alpine/pinerc"'
alias arduino-cli='arduino-cli --config-file "${XDG_CONFIG_HOME}/arduino15/arduino-cli.yaml"'
#------------------------------------------------------------------------------
# Navigation Aliases
#------------------------------------------------------------------------------
# Quick directory traversal
# Go up one level
alias ..='cd ..'
# Go up two levels
alias ...='cd ../..'
# Go up three levels
alias ....='cd ../../..'
# Go up four levels
alias .....='cd ../../../..'
# Go up five levels
alias ......='cd ../../../../..'
# Go up six levels
alias .......='cd ../../../../../..'
#------------------------------------------------------------------------------
# Package Management Aliases
#------------------------------------------------------------------------------
# Pacman and system maintenance
# Remove unused packages
alias autoremove='sudo apt autoremove'
# Clean package cache
alias aptclean='sudo apt-get clean'
# List available updates
alias updates='sudo apt list --upgradable'
# Download and install updates
alias update='sudo apt update && \
              sudo apt upgrade && \
              sudo updatedb'
# Fetch new mirror list and update as above, clean the package cache and remove unused packages
alias upgrade='update && \
               aptclean && \
               autoremove'
#------------------------------------------------------------------------------
# System Maintenance Aliases
#------------------------------------------------------------------------------
# System cleanup and maintenance
alias cleanphp='sudo find /var/lib/php/ -type f -name "sess_*" -amin +4320 -exec rm {} +;'
alias clearlog='sudo journalctl --vacuum-size=1B'
alias trash-empty='trash-empty; sudo trash-empty'
alias whatprovides='pkgfile --search'
# System monitoring
alias connections='sudo netstat --tcp --udp -alnp'
alias running-services='systemctl list-units | grep -E "UNIT.*LOAD.*ACTIVE.*SUB.*DESCRIPTION|running"'
alias space='df -h --print-type --exclude-type=tmpfs --exclude-type=devtmpfs'
alias temperature='sensors | grep Package | sed -e '\''s/\+//g'\'' -e '\''s/\..*/\°C/g'\'' | awk '\''{print "CPU: " $4}'\''; echo "GPU: $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits || aticonfig --od-gettemperature)°C"'
#------------------------------------------------------------------------------
# Security and System Check Aliases
#------------------------------------------------------------------------------
# Security scans and system auditing
alias check-security='sudo rkhunter --update > /dev/null && \
                      sudo rkhunter --propupd > /dev/null && \
                      sudo rkhunter -c --rwo --sk; \
                      sudo lynis audit system --forensics --pentest; \
                      sudo clamdscan -mz /boot /etc /home /lost+found /mnt /opt /root /srv /tmp /usr /var'
alias scan='clamdscan --fdpass -m -i --quiet /'
alias full-scan='sudo nmap -p 1-65535 -sT -sU -A -sV'
# Scan all ports; TCP ports; UDP ports
alias quick-scan='sudo nmap -p 1-65535 -sT -sU'
alias vuln-scan='sudo nmap -p 1-65535 -sT -sU -Pn --script vuln -sV --script=http-malware-host --script http-google-malware'
#------------------------------------------------------------------------------
# File Operation Aliases
#------------------------------------------------------------------------------
# Enhanced file operations
# Safe deletion using trash-cli
alias rm='trash-put'
# Create parent directories as needed
alias mkdir='mkdir -vp'
# Colorized ls output
alias ls='ls --color=auto'
# List all files with human-readable sizes
alias lsa='ls -lah --color=auto'
# Sort by creation time
alias lsc='ls -lahtr --color=auto --time=birth'
# Group directories
alias lsh='ls -lah --color=auto --group-directories-first'
# Sort by modification time
alias lsm='ls -lahtr --color=auto --time=ctime'
# Create backup of files/folders with rync
alias backup='rsync -vcrlptgoDHEAXh --progress --stats'
alias backup-dry='rsync -vcrlptgoDHEAXh --progress --stats --dry-run'
# Copy using rsync
alias copy='rsync -vcrlptgoDHEAXh --progress --stats'
alias copy-dry='rsync -vcrlptgoDHEAXh --progress --stats --dry-run'
#------------------------------------------------------------------------------
# Development and Git Aliases
#------------------------------------------------------------------------------
# Git shortcuts
alias g='git'
alias gcheckout='git branch | fzf | xargs git checkout'
alias glog='git log --oneline | fzf --preview "git show {+1}"'
# Visualize repository activity
alias gource='gource -s 1 --key -a 1 --user-image-dir "$(git rev-parse --show-toplevel)/.git/avatar"'
#------------------------------------------------------------------------------
# File Search and Analysis Aliases
#------------------------------------------------------------------------------
# Search and analysis tools
alias todo='grep --recursive --line-number --extended-regexp "todo|\s+fix(me)\s+?"'
alias duplicates='rmlint -g'
# Add color for grep by default
alias grep='grep --color=auto'
# Colordiff with side by side view and tab/space ignoring
alias cdiff='colordiff -ry --suppress-common-lines'
# Add color for diff by default
alias diff='diff --color=auto --suppress-common-lines -y'
#------------------------------------------------------------------------------
# System Resource Management Aliases
#------------------------------------------------------------------------------
# Resource monitoring
# Display network usage
alias iftop="sudo iftop -m 1024K -i \$(route | grep 'default' | head -n 1 | awk '{print \$8}')"
# Display I/O usage
alias iotop='sudo iotop -oP'
alias whoisusingmyswap="smem --columns='pid user command swap' --sort=swap --reverse | awk '\$NF != \"0\" {print}'"
# Memory management
alias freemem='printf "Clearing PageCache, dentries and inodes:\n"; \
               sudo sync; \
               echo 3 | sudo tee -a /proc/sys/vm/drop_caches; \
               printf "Clearing swap\n"; \
               sudo swapoff -a && \
               sudo swapon -a'
#------------------------------------------------------------------------------
# Network and System Information Aliases
#------------------------------------------------------------------------------
# Network information
alias ip='ip -color=auto'
# Get current IP
alias myip='curl http://my.ip.fi/ || echo "Could not retrieve IP. Are you connected to the internet?"'
# System logs and information
alias error='journalctl --no-hostname -q -p 4'
alias error-today='journalctl --no-hostname -q -p 4 -b'
alias fail2ban-log='grep "Ban " /var/log/fail2ban.log | sort | logresolve | uniq -c | sort -n'
alias logins='(sudo find /var/log -type f -name "auth.log" -exec cat {} \+; \
               sudo find /var/log -type f -name "auth.log.1" -exec cat {} \+; \
               sudo find /var/log -type f -name "auth.log.*.gz" -exec zcat {} \+) | \
                grep -oE "opened for user .*" | \
                awk "{print $2}" | \
                sort | \
                uniq -c'
#------------------------------------------------------------------------------
# Multimedia Processing Aliases
#------------------------------------------------------------------------------
# Video compression
alias mov-compress='for mov in *.mp4; do ffmpeg -hide_banner -loglevel warning -i "${mov}" -preset slow -c:v h264_nvenc -b:v 2M -c:a aac -b:a 128k $(basename "${mov}" ".mp4")_compr.mp4; done'
# Media download
alias yt-dl='youtube-dl --quiet --no-call-home --geo-bypass --yes-playlist --hls-prefer-ffmpeg --no-overwrites --continue --audio-quality 0 --embed-thumbnail --add-metadata --prefer-ffmpeg'
#------------------------------------------------------------------------------
# Kubernetes Aliases
#------------------------------------------------------------------------------
alias k='kubectl'
alias kx='kubectx'
#------------------------------------------------------------------------------
# GPG Aliases
#------------------------------------------------------------------------------
# Generate new GPG key
alias gpg-create='gpg --full-gen-key --expert'
# Download GPG keys
alias gpg-download='gpg --keyserver https://keys.openpgp.org --receive-keys'
# Edit GPG keys
alias gpg-edit='gpg --edit-key'
# Export GPG keys
alias gpg-export='gpg --export -a'
alias gpg-export-revocation='gpg --gen-revoke -a'
alias gpg-export-secret='gpg --export-secret-keys -a'
# Import GPG keys
alias gpg-import='gpg --import'
# List GPG keys
alias gpg-list='gpg --list-keys'
alias gpg-list-secret='gpg --list-secret-keys'
# Publish GPG keys to multiple servers at once
alias gpg-publish='__gpg_upload'
# Refresh GPG keys
alias gpg-refresh='gpg --refresh-keys'
# Search GPG keys
alias gpg-search='gpg --search-keys'
# Upload GPG keys
alias gpg-upload='gpg --send-keys'
#------------------------------------------------------------------------------
# fzf Integrations
#------------------------------------------------------------------------------
## Package manager
alias fsearch='apt-cache search . | sort | fzf --multi --preview "apt-cache show {1}"'
alias finstall='apt-cache search . | sort | fzf --multi --preview "apt-cache show {1}" | cut -d " " -f1 | xargs -ro sudo apt install'
alias fremove='dpkg -l | sed 1,5d | awk "{print \$2}" | fzf --multi --preview "apt-cache show {1}" | xargs -ro sudo apt remove'
alias funinstall='dpkg -l | sed 1,5d | awk "{print \$2}" | fzf --multi --preview "apt-cache show {1}" | xargs -ro sudo apt purge'
# Bat/Cat integration
if command -v bat >/dev/null 2>&1; then
    # If bat is available, use it
    # Find and view with bat
    alias bf='bat $(fzf)'
    # Browse with bat preview
    alias baf='fzf --preview "bat --style=numbers --color=always {}"'
else
    # Fallback to cat
    # Find and view with cat
    alias bf='cat $(fzf)'
    # Browse with cat preview
    alias baf='fzf --preview "cat {}"'
fi
# Find and edit
alias fvi='vi $(fzf)'
alias fvim='vim $(fzf)'
alias fnano='nano $(fzf)'
alias fedit='${EDITOR:-vim} $(fzf)'
# Find and open with default app
alias fopen='xdg-open $(fzf)'
# History search
alias fhistory='history | fzf | cut -c8-'
#------------------------------------------------------------------------------
# Miscellaneous Aliases
#------------------------------------------------------------------------------
# Help command
alias help='run-help'
# Rerun last command with sudo
alias please="sudo !!"
# Retrieve random 64 character string via /dev/urandom
alias random='< /dev/urandom tr --delete --complement _A-Z-a-z-0-9 | head --bytes=${1:-64}; echo;'
alias size='du -sch 2> /dev/null'
# Allow alias expansion with watch command
alias watch='watch '
# LibreOffice Fix
alias libreoffice='LD_PRELOAD=/usr/lib/libfreetype.so libreoffice'


#------------------------------------------------------------------------------
# User Configuration
#------------------------------------------------------------------------------
[ -f ~/.profile.local ] && . ~/.profile.local
