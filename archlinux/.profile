#!/bin/sh

# Default Colors
HIDDEN="\e[8m"
INVERT="\e[7m"
UNDERLINED="\e[4m"
DIM="\e[2m"
BOLD="\e[1m"
FG_BLACK="\e[30m"
FG_RED="\e[31m"
FG_GREEN="\e[32m"
FG_YELLOW="\e[33m"
FG_BLUE="\e[34m"
FG_MAGENTA="\e[35m"
FG_CYAN="\e[36m"
FG_LIGHTGREY="\e[37m"
FG_GREY="\e[90m"
FG_LIGHTRED="\e[91m"
FG_LIGHTGREEN="\e[92m"
FG_LIGHTYELLOW="\e[93m"
FG_LIGHTBLUE="\e[94m"
FG_LIGHTMAGENTA="\e[95m"
FG_LIGHTCYAN="\e[96m"
FG_WHITE="\e[97m"
BG_BLACK="\e[40m"
BG_RED="\e[41m"
BG_GREEN="\e[42m"
BG_YELLOW="\e[43m"
BG_BLUE="\e[44m"
BG_MAGENTA="\e[45m"
BG_CYAN="\e[46m"
BG_LIGHTGREY="\e[47m"
BG_GREY="\e[100m"
BG_LIGHTRED="\e[101m"
BG_LIGHTGREEN="\e[102m"
BG_LIGHTYELLOW="\e[103m"
BG_LIGHTBLUE="\e[104m"
BG_LIGHTMAGENTA="\e[105m"
BG_LIGHTCYAN="\e[106m"
BG_WHITE="\e[107m"
ENDENC="\e[0m"

# Special application XDG paths
## Collected from https://wiki.archlinux.org/title/XDG_Base_Directory#Support
XDG_CONFIG_HOME="${HOME}/.config"
XDG_CACHE_HOME="${HOME}/.cache"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"
XDG_RUNTIME_DIR="/run/user/$(id -u)"
XDG_DATA_DIRS="/usr/local/share:/usr/share"
XDG_CONFIG_DIRS="/etc/xdg"
ACKRC="${XDG_CONFIG_HOME}/ack/ackrc"
ANSIBLE_CONFIG="${XDG_CONFIG_HOME}/ansible.cfg"
ANSIBLE_GALAXY_CACHE_DIR="${XDG_CACHE_HOME}/ansible/galaxy_cache"
ANSIBLE_HOME="${XDG_CONFIG_HOME}/ansible"
ASDF_CONFIG_FILE="${XDG_CONFIG_HOME}/asdf/asdfrc"
ASDF_DATA_DIR="${XDG_DATA_HOME}/asdf"
ASPELL_CONF="per-conf ${XDG_CONFIG_HOME}/aspell/aspell.conf; personal ${XDG_CONFIG_HOME}/aspell/en.pws; repl ${XDG_CONFIG_HOME}/aspell/en.prepl"
ATOM_HOME="${XDG_DATA_HOME}/atom"
AWS_CONFIG_FILE="${XDG_CONFIG_HOME}/aws/config"
AWS_SHARED_CREDENTIALS_FILE="${XDG_CONFIG_HOME}/aws/credentials"
AZURE_CONFIG_DIR="${XDG_DATA_HOME}/azure"
BASH_COMPLETION_USER_FILE="${XDG_CONFIG_HOME}/bash-completion/bash_completion"
BOGOFILTER_DIR="${XDG_DATA_HOME}/bogofilter"
BUN_INSTALL="${XDG_DATA_HOME}/bun"
C3270PRO="${XDG_CONFIG_HOME}/c3270/config"
CALCHISTFILE="${XDG_CACHE_HOME}/calc_history"
CARGO_HOME="${XDG_DATA_HOME}/cargo"
CD_BOOKMARK_FILE="${XDG_CONFIG_HOME}/cd-bookmark/bookmarks"
CGDB_DIR="${XDG_CONFIG_HOME}/cgdb"
CHKTEXRC="${XDG_CONFIG_HOME}/chktex"
CIN_CONFIG="${XDG_CONFIG_HOME}/bcast5"
CONAN_USER_HOME="${XDG_CONFIG_HOME}"
CONDARC="${XDG_CONFIG_HOME}/conda/condarc"
CRAWL_DIR="${XDG_DATA_HOME}/crawl/"
CUDA_CACHE_PATH="${XDG_CACHE_HOME}/nv"
DISCORD_USER_DATA_DIR="${XDG_DATA_HOME}"
DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
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
FFMPEG_DATADIR="${XDG_CONFIG_HOME}/ffmpeg"
GDBHISTFILE="${XDG_DATA_HOME}/gdb/history"
GEM_HOME="${XDG_DATA_HOME}/gem"
GEM_SPEC_CACHE="${XDG_CACHE_HOME}/gem"
GETIPLAYERUSERPREFS="${XDG_DATA_HOME}/get_iplayer"
GHCUP_USE_XDG_DIRS="true"
GHCUP_USE_XDG_DIRS=true
GNUPGHOME="${XDG_DATA_HOME}/gnupg"
GOMODCACHE="${XDG_CACHE_HOME}/go/mod"
GOPATH="${XDG_DATA_HOME}/go"
GQRC="${XDG_CONFIG_HOME}/gqrc"
GQSTATE="${XDG_DATA_HOME}/gq/gq-state"
GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle"
GRC_PREFS_PATH="${XDG_CONFIG_HOME}/gnuradio/grc.conf"
GRIPHOME="${XDG_CONFIG_HOME}/grip"
GR_PREFS_PATH="${XDG_CONFIG_HOME}/gnuradio"
GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"
GTK_RC_FILES="${XDG_CONFIG_HOME}/gtk-1.0/gtkrc"
GVIMINIT='let $MYGVIMRC="${XDG_CONFIG_HOME}/vim/gvimrc" | source ${MYGVIMRC}'
HISTFILE="${XDG_STATE_HOME}/bash/history"
HISTFILE="${XDG_STATE_HOME}/history/history"
HISTFILE="${XDG_STATE_HOME}/zsh/history"
HOUDINI_USER_PREF_DIR="${XDG_CACHE_HOME}/houdini__HVER__"
ICEAUTHORITY="${XDG_CACHE_HOME}/ICEauthority"
IMAPFILTER_HOME="${XDG_CONFIG_HOME}/imapfilter"
INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
IPFS_PATH="${XDG_DATA_HOME}/ipfs"
IRBRC="${XDG_CONFIG_HOME}/irb/irbrc"
JAVA_TOOL_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java -Djavafx.cachedir=${XDG_CACHE_HOME}/openjfx -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"
JDK_JAVA_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java -Djavafx.cachedir=${XDG_CACHE_HOME}/openjfx -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"
JULIAUP_DEPOT_PATH="${XDG_DATA_HOME}/julia"
JULIA_DEPOT_PATH="${XDG_DATA_HOME}/julia:${JULIA_DEPOT_PATH}"
JUPYTER_CONFIG_DIR="${XDG_CONFIG_HOME}/jupyter"
JUPYTER_PLATFORM_DIRS="1"
K9SCONFIG="${XDG_CONFIG_HOME}/k9s"
KDEHOME="${XDG_CONFIG_HOME}/kde"
KODI_DATA="${XDG_DATA_HOME}/kodi"
KSCRIPT_CACHE_DIR="${XDG_CACHE_HOME}/kscript"
KUBECACHEDIR="${XDG_CACHE_HOME}/kube"
KUBECONFIG="${XDG_CONFIG_HOME}/kube"
LEDGER_FILE="${XDG_DATA_HOME}/hledger.journal"
LEIN_HOME="${XDG_DATA_HOME}/lein"
LYNX_CFG_PATH="${XDG_CONFIG_HOME}/lynx.cfg"
MACHINE_STORAGE_PATH="${XDG_DATA_HOME}/docker-machine"
MATHEMATICA_USERBASE="${XDG_CONFIG_HOME}/mathematica"
MAXIMA_USERDIR="${XDG_CONFIG_HOME}/maxima"
MEDNAFEN_HOME="${XDG_CONFIG_HOME}/mednafen"
MINIKUBE_HOME="${XDG_DATA_HOME}/minikube"
MIX_XDG="true"
MOST_INITFILE="${XDG_CONFIG_HOME}/mostrc"
MPLAYER_HOME="${XDG_CONFIG_HOME}/mplayer"
MYPY_CACHE_DIR="${XDG_CACHE_HOME}/mypy"
MYSQL_HISTFILE="${XDG_DATA_HOME}/mysql_history"
NODENV_ROOT="${XDG_DATA_HOME}/nodenv"
NODE_REPL_HISTORY="${XDG_DATA_HOME}/node_repl_history"
NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
NUGET_PACKAGES="${XDG_CACHE_HOME}/NuGetPackages"
NVM_DIR="${XDG_DATA_HOME}/nvm"
N_PREFIX="${XDG_DATA_HOME}/n"
OCTAVE_HISTFILE="${XDG_CACHE_HOME}/octave-hsts"
OCTAVE_SITE_INITFILE="${XDG_CONFIG_HOME}/octave/octaverc"
OLLAMA_MODELS="${XDG_DATA_HOME}/ollama/models"
OMNISHARPHOME="${XDG_CONFIG_HOME}/omnisharp"
OPAMROOT="${XDG_DATA_HOME}/opam"
PARALLEL_HOME="${XDG_CONFIG_HOME}/parallel"
PASSWORD_STORE_DIR="${XDG_DATA_HOME}/pass"
PGPASSFILE="${XDG_CONFIG_HOME}/pg/pgpass"
PGSERVICEFILE="${XDG_CONFIG_HOME}/pg/pg_service.conf"
PLATFORMIO_CORE_DIR="${XDG_DATA_HOME}/platformio"
PLTUSERHOME="${XDG_DATA_HOME}/racket"
PSQLRC="${XDG_CONFIG_HOME}/pg/psqlrc"
PSQL_HISTORY="${XDG_STATE_HOME}/psql_history"
PYENV_ROOT="${XDG_DATA_HOME}/pyenv"
PYLINTHOME="${XDG_CACHE_HOME}/pylint"
PYLINTRC="${XDG_CONFIG_HOME}/pylint/pylintrc"
PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
PYTHONUSERBASE="${XDG_DATA_HOME}/python"
PYTHON_EGG_CACHE="${XDG_CACHE_HOME}/python-eggs"
PYTHON_HISTORY="${XDG_STATE_HOME}/python/history"
RBENV_ROOT="${XDG_DATA_HOME}/rbenv"
RECOLL_CONFDIR="${XDG_CONFIG_HOME}/recoll"
REDISCLI_HISTFILE="${XDG_DATA_HOME}/redis/rediscli_history"
REDISCLI_RCFILE="${XDG_CONFIG_HOME}/redis/redisclirc"
RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"
RLWRAP_HOME="${XDG_DATA_HOME}/rlwrap"
RUFF_CACHE_DIR="${XDG_CACHE_HOME}/ruff"
RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
RXVT_SOCKET="${XDG_RUNTIME_DIR}/urxvtd"
R_HISTFILE="${XDG_CONFIG_HOME}/R/history"
R_HOME_USER="${XDG_CONFIG_HOME}/R"
R_PROFILE_USER="${XDG_CONFIG_HOME}/R/profile"
SCREENRC="${XDG_CONFIG_HOME}/screen/screenrc"
SINGULARITY_CACHEDIR="${XDG_CACHE_HOME}/singularity"
SINGULARITY_CONFIGDIR="${XDG_CONFIG_HOME}/singularity"
SOLARGRAPH_CACHE="${XDG_CACHE_HOME}/solargraph"
SPACEMACSDIR="${XDG_CONFIG_HOME}/spacemacs"
SQLITE_HISTORY="${XDG_DATA_HOME}/sqlite_history"
SSB_HOME="${XDG_DATA_HOME}/zoom"
STACK_ROOT="${XDG_DATA_HOME}/stack"
STACK_XDG=1
STARSHIP_CACHE="${XDG_CACHE_HOME}/starship"
STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship.toml"
TERMINFO="${XDG_DATA_HOME}/terminfo"
TERMINFO_DIRS="${XDG_DATA_HOME}/terminfo:/usr/share/terminfo"
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
VIMINIT='let $MYVIMRC="${XDG_CONFIG_HOME}/vim/vimrc" | source ${MYVIMRC}'
VIMPERATOR_INIT=":source ${XDG_CONFIG_HOME}/vimperator/vimperatorrc"
VIMPERATOR_RUNTIME="${XDG_CONFIG_HOME}/vimperator"
VSCODE_PORTABLE="${XDG_DATA_HOME}/vscode"
W3M_DIR="${XDG_STATE_HOME}/w3m"
WAKATIME_HOME="${XDG_CONFIG_HOME}/wakatime"
WGETRC="${XDG_CONFIG_HOME}/wgetrc"
WINEPREFIX="${XDG_DATA_HOME}/wineprefixes/default"
WORKON_HOME="${XDG_DATA_HOME}/virtualenvs"
X3270PRO="${XDG_CONFIG_HOME}/x3270/config"
# Deactivated as it seems to break java/awt applications
#export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"
XCOMPOSECACHE="${XDG_CACHE_HOME}/X11/xcompose"
XCOMPOSEFILE="${XDG_CONFIG_HOME}/X11/xcompose"
XINITRC="${XDG_CONFIG_HOME}/X11/xinitrc"
XSERVERRC="${XDG_CONFIG_HOME}/X11/xserverrc"
ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
_JAVA_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java -Djavafx.cachedir=${XDG_CACHE_HOME}/openjfx -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"
_Z_DATA="${XDG_DATA_HOME}/z"

# Graphics driver
GPU_VENDOR=$(lspci -vnn | grep 'VGA compatible controller')
if echo "${GPU_VENDOR}" | grep -qi 'nvidia'; then
  export LIBVA_DRIVER_NAME='nvidia'
  export VDPAU_DRIVER='nvidia'
  export GBM_BACKEND='nvidia-drm'
  export __GLX_VENDOR_LIBRARY_NAME='nvidia'
elif echo "${GPU_VENDOR}" | grep -Eiq 'amd|radeon'; then
  export LIBVA_DRIVER_NAME='radeonsi'
  export VDPAU_DRIVER='va_gl'
elif echo "${GPU_VENDOR}" | grep -iq 'intel'; then
  export LIBVA_DRIVER_NAME='i965'
  export VDPAU_DRIVER='va_gl'
fi

# Wayland/X11
export ELECTRON_OZONE_PLATFORM_HINT="auto"
if [ "${XDG_SESSION_TYPE}" = "wayland" ]; then
  export MOZ_ENABLE_WAYLAND=1
  export QT_QPA_PLATFORM="wayland;xcb"
  export CLUTTER_BACKEND="wayland"
  export SDL_VIDEODRIVER="wayland,x11"
else
  export QT_QPA_PLATFORM="xcb"
  export CLUTTER_BACKEND="x11"
  export SDL_VIDEODRIVER="x11"
  export WINIT_UNIX_BACKEND="x11"
fi

# System informations
export KERNEL="$(uname --kernel-release)"
export CPU="$(grep -m 1 'model name' /proc/cpuinfo | awk '{print $4 " " $5 " " $6 " " $7 " " $9 " " $10}')"
export GPU="$(lspci | grep ' VGA ' | grep -E -o -m 1 '\[.*\]' | cut -c 2- | rev | cut -c 2- | rev)"
export RAM="$(expr "$(grep -m 1 'MemTotal' /proc/meminfo | awk '{print $2}')" / 1000 / 1000)"
export MAC="$(macchanger -s "$(ls /sys/class/net | awk '{print $1}' | head -n 1)" | head -n 1 | awk '{print $3}')"
export IP="$(curl -s -m 3  http://my.ip.fi/ || echo 'No connection')"

# Custom settings
export EDITOR='nano'
export GPG_TTY=$(tty)
export HISTSIZE=1000000
export LESS='-R --use-color -Dd+r$Du+b'
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT="-P -c"
export PYTHONIOENCODING='UTF-8'
export SAL_DISABLEGL=1
export SAL_DISABLE_OPENCL=1
export SAVEHIST=1000000
export SDL_VIDEO_X11_DGAMOUSE=0
export SSH_ASKPASS='ksshaskpass'
export SSH_ASKPASS_REQUIRE=prefer
export SUDO_EDITOR='nano'
export VISUAL='nano'
export DONT_PROMPT_WSL_INSTALL='yes'

# IBM DB2
export IBM_DB_HOME='${XDG_DATA_HOME}/python/lib/python3.12/site-packages/clidriver'
export LD_LIBRARY_PATH='${IBM_DB_HOME}/lib:${LD_LIBRARY_PATH}'

# Basic fzf settings
export FZF_DEFAULT_OPTS="--ansi"
export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*' -not -path '*/\.terraform/*'"
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_ALT_T_COMMAND="find . -type d -not -path '*/\.git/*' -not -path '*/\.terraform/*'"

# Set default umask
umask 027

# Add private bins to path
if [ -d "${HOME}/bin" ]; then
  PATH="${HOME}/bin:${PATH}"
fi
if [ -d "${HOME}/.local/bin" ]; then
  PATH="${HOME}/.local/bin:${PATH}"
fi

# Add bun to path
if [ -d "${XDG_DATA_HOME}/bun" ]; then
  PATH="${XDG_DATA_HOME}/bun:${PATH}"
fi

# Add IntelliJ Toolbox to path
if [ -d "${XDG_DATA_HOME}/JetBrains/Toolbox/scripts" ]; then
  PATH="${XDG_DATA_HOME}/JetBrains/Toolbox/scripts:${PATH}"
fi

# Evals
if [ -d "${XDG_CONFIG_HOME}/dircolors" ]; then
  eval "$(dircolors "${XDG_CONFIG_HOME}/dircolors")"
fi

# Setup anaconda
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

# Load nvm
if [ -f /usr/share/nvm/init-nvm.sh ]; then
  . /usr/share/nvm/init-nvm.sh > /dev/null
fi

# Colors
if [ -d "${XDG_CONFIG_HOME}/dircolors" ]; then
  eval "$(dircolors "${XDG_CONFIG_HOME}/dircolors")"
fi

# Redefine TheFuck alias
eval "$(thefuck --alias dammit)"

# Colored output functions
__error()   { printf "${FG_RED}[ERROR]: %b${ENDENC}\n" "$*" >&2; }
__warning() { printf "${FG_YELLOW}[WARN]: %b${ENDENC}\n" "$*" >&2; }
__info()    { printf "${FG_WHITE}[INFO]: %b${ENDENC}\n" "$*" >&1; }
__debug()   { printf "${FG_GREY}[DEBUG]: %b${ENDENC}\n" "$*" >&1; }

# FZF functions
_fzf_comprun() {
  local command=$1
  shift

  case "${command}" in 
    cd)           fzf --preview 'ls -lah {} | head 100' "$@";; 
    export|unset) fzf --preview "eval 'echo \$'{}" "$@";;
    ssh)          fzf --preview 'dig {}' "$@";;
    *)            fzf --preview 'bat -n -f -r :500 {} ' "$@";;
  esac
}

# Copy file(s) over SSH using rsync
ssh_copy() {
  HOST="${1}"
  PORT="${2}"
  USER="${3}"
  SOURCE="${4}"
  TARGET="${5}"

  # Check if source exist
  if [ -z "${HOST}" ] || [ -z "${PORT}" ] || [ -z "${USER}" ] || [ -z "${SOURCE}" ] || [ -z "${TARGET}" ];
  then
    __error "Please call as ssh-copy HOST PORT USER SOURCE TARGET"
    return 1
  fi

  # Check if host is reachable
  if ! ping -c 1 "${HOST}" > /dev/null 2>&1;
  then
    __error "Could not reach host: ${HOST}"
    return 1
  fi

  # Check if source exist
  if [ ! -f "${SOURCE}" ] && [ ! -d "${SOURCE}" ];
  then
    __error "Source file(s) not found at: ${SOURCE}"
    return 1
  fi

  rsync -vcrlptgoDHEAXh --delete --progress --stats \
        --rsh="ssh -p ${PORT}" "${SOURCE}" "${USER}"@"${HOST}":"${TARGET}"
}

# Create gitignore file using gitignore.io
gitignore() {
  if [ -z "$1" ] || [ "$1" = '-h' ] || [ "$1" = '--help' ];
  then
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
  if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ];
  then
    git branch -r | \
    grep -v '\->' | \
    sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | \
    while read -r remote;
    do
      git branch --track "${remote#origin/}" "$remote";
    done

    git fetch --all
    git pull --all
  fi
}

# Upload GPG key to multiple keyservers at once
__gpg_upload() {
  fingerprint="${1}"

  gpg --keyserver pgp.mit.edu --send-keys "${fingerprint}"
  gpg --keyserver keyring.debian.org --send-keys "${fingerprint}"
  gpg --keyserver keyserver.ubuntu.com --send-keys "${fingerprint}"
  gpg --keyserver pgp.surf.nl --send-keys "${fingerprint}"
  gpg --keyserver pgpkeys.eu --send-keys "${fingerprint}"
  gpg --export "${fingerprint}" | curl -T - https://keys.openpgp.org
}

# Helper functions for more complex operations
fcd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
      -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# Find in files using grep and edit file
fif() {
  if [ ! "$#" -gt 0 ]; then
    echo "Need a string to search for!"
    return 1
  fi
  
  local file
  file=$(find . -type f -not -path '*/\.git/*' -not -path '*/\.terraform/*' -exec grep -l "$1" {} \; | fzf --preview "grep -n -C 3 '$1' {}")
  
  if [ -n "$file" ]; then
    ${EDITOR:-vim} "$file"
  fi
}

# Environment variable viewer
fenv() {
    local out
    out=$(env | fzf)
    echo $(echo $out | cut -d= -f2)
}

# Find and kill process
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi
}

# SSH host selection
fssh() {
    local sshhost
    if [ -f ~/.ssh/config ]; then
        sshhost=$(grep "^Host " ~/.ssh/config | grep -v "[?*]" | cut -d ' ' -f 2- | fzf)
        if [ ! -z "$sshhost" ]; then
            ssh "$sshhost"
        fi
    else
        echo "No SSH config file found"
    fi
}

# Enhanced git add
gadd() {
    git ls-files -m -o --exclude-standard | fzf -m --preview 'git diff --color=always {} | head -500' | xargs -r git add
}

aws_profile() {
    if [ -f ~/.aws/credentials ]; then
        local profile
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

aws_region() {
    local regions="
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
    local region
    region=$(echo "$regions" | tr -d ' ' | fzf)
    if [ ! -z "$region" ]; then
        export AWS_DEFAULT_REGION="$region"
        echo "AWS Region set to: $region"
    fi
}

# Combined AWS profile and region selector
aws_setup() {
    aws_profile && aws_region
}

# Quick access to known AWS resource types
aws_resource_search() {
    local resource_type
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

# Terraform workspace select
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

# Terraform plan with preview and save
tf_plan() {
   if [ ! -d .terraform ]; then
       echo "Not a Terraform directory or not initialized"
       return 1
   fi

   # Check for workspace
   local workspace
   workspace=$(terraform workspace show)
   
   # Check for changes in files
   local changes
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

   echo "Creating plan for workspace: $workspace"
   
   # Create dated plan file
   local plan_file="tfplan_${workspace}_$(date +%Y%m%d_%H%M%S)"
   
   # Run plan and store output
   local plan_output
   plan_output=$(terraform plan -out="$plan_file" 2>&1)
   local plan_exit=$?

   if [ $plan_exit -eq 0 ]; then
       echo "$plan_output"
       echo "Plan saved to: $plan_file"
       
       # Show plan summary
       echo "Plan summary:"
       terraform show "$plan_file" | grep -E '^\s*[~+-]'
       
       # Optionally view full plan
       echo "View full plan? (y/N)"
       read -r response
       if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
           terraform show "$plan_file" | less
       fi
   else
       echo "Plan failed!"
       echo "$plan_output"
       return 1
   fi
}

# Terraform plan file viewer
tf_plan_view() {
    find . -name "*.tfplan" | fzf --preview "terraform show {}"
}

# Quick apply of latest plan
tf_apply() {
   local latest_plan
   latest_plan=$(find . -name "tfplan_*" -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" ")
   if [ ! -z "$latest_plan" ]; then
       echo "Found latest plan: $latest_plan"
       echo "Apply this plan? (y/N)"
       read -r response
       if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
           terraform apply "$latest_plan"
       fi
   else
       echo "No plan files found"
       return 1
   fi
}

# Terraform destroy with safety checks
tf_destroy() {
   if [ ! -d .terraform ]; then
       echo "Not a Terraform directory or not initialized"
       return 1
   fi

   # Check for workspace
   local workspace
   workspace=$(terraform workspace show)
   
   echo "WARNING: You are about to destroy infrastructure in workspace: $workspace"
   echo "Type the workspace name to confirm: "
   read -r confirmation
   
   if [ "$confirmation" != "$workspace" ]; then
       echo "Abort: Workspace name does not match"
       return 1
   fi

   # Additional safety check for production workspaces
   if echo "$workspace" | grep -iq "prod"; then
       echo "WARNING: This appears to be a production workspace!"
       echo "Type 'yes-destroy-production' to confirm: "
       read -r prod_confirmation
       if [ "$prod_confirmation" != "yes-destroy-production" ]; then
           echo "Abort: Production destroy not confirmed"
           return 1
       fi
   fi

   echo "Creating destroy plan..."
   
   # Create dated destroy plan file
   local destroy_plan="tfdestroy_${workspace}_$(date +%Y%m%d_%H%M%S)"
   
   # Create destroy plan first
   local plan_output
   plan_output=$(terraform plan -destroy -out="$destroy_plan" 2>&1)
   local plan_exit=$?

   if [ $plan_exit -eq 0 ]; then
       echo "$plan_output"
       echo "Destroy plan saved to: $destroy_plan"
       
       # Show resources to be destroyed
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
       echo "Destroy plan failed!"
       echo "$plan_output"
       return 1
   fi
}

# Aliases
## Default aliases adding XDG base directory support
alias abook='abook --config "${XDG_CONFIG_HOME}/abook/abookrc" --datafile "${XDG_DATA_HOME}/abook/addressbook"'
alias bashdb='bashdb -x ${XDG_CONFIG_HOME:-$HOME/.config}/bashdb/bashdbinit'
alias petite='petite --eehistory "${XDG_DATA_HOME}/chezscheme/history"'
alias conky='conky --config="${XDG_CONFIG_HOME}/conky/conkyrc"'
alias claws-mail='claws-mail --alternate-config-dir "${XDG_DATA_HOME}/claws-mail"'
alias cssh='cssh --config-file "${XDG_CONFIG_HOME}/clusterssh/config"'
alias dosbox='dosbox -conf "${XDG_CONFIG_HOME}/dosbox/dosbox.conf"'
alias emcc='emcc --em-config "${XDG_CONFIG_HOME}/emscripten/config" --em-cache "${XDG_CACHE_HOME}/emscripten/cache"'
alias getmail='getmail --rcfile="${XDG_CONFIG_HOME}/getmail/getmailrc" --getmaildir="${XDG_DATA_HOME}/getmail"'
alias gliv='gliv --glivrc="${XDG_CONFIG_HOME}/gliv/glivrc"'
alias gpg='gpg --homedir "${XDG_DATA_HOME}/gnupg"'
alias gpg2='gpg2 --homedir "${XDG_DATA_HOME}/gnupg"'
alias irssi='irssi --config="${XDG_CONFIG_HOME}/irssi/config" --home="${XDG_DATA_HOME}/irssi"'
alias mbsync='mbsync -c "${XDG_CONFIG_HOME}/isync/mbsyncrc"'
alias keychain='keychain --absolute --dir "${XDG_RUNTIME_DIR}/keychain"'
alias ledger='ledger --init-file "${XDG_CONFIG_HOME}/ledgerrc"'
alias ltrace='ltrace -F "${XDG_CONFIG_HOME}/ltrace/ltrace.conf"'
alias mvn='mvn -gs "${XDG_CONFIG_HOME}/maven/settings.xml"'
alias mitmproxy='mitmproxy --set confdir="${XDG_CONFIG_HOME}/mitmproxy"'
alias mitmweb='mitmweb --set confdir="${XDG_CONFIG_HOME}/mitmproxy"'
alias mocp='mocp -M "${XDG_CONFIG_HOME}/moc" -O MOCDir="${XDG_CONFIG_HOME}/moc"'
alias monerod='monerod --data-dir "${XDG_DATA_HOME}/bitmonero"'
alias mysql-workbench='mysql-workbench --configdir="${XDG_DATA_HOME}/mysql/workbench"'
alias ncmpc='ncmpc -f "${XDG_CONFIG_HOME}/ncmpc/config"'
alias netbeans='netbeans --userdir "${XDG_CONFIG_HOME}/netbeans"'
alias nvidia-settings='nvidia-settings --config="${XDG_CONFIG_HOME}/nvidia/settings"'
alias pidgin='pidgin --config="${XDG_DATA_HOME}/purple"'
alias sbt='sbt -ivy "${XDG_DATA_HOME}/ivy2" -sbt-dir "${XDG_DATA_HOME}/sbt"'
alias svn='svn --config-dir "${XDG_CONFIG_HOME}/subversion"'
alias titop='tiptop -W "${XDG_CONFIG_HOME}/tiptop"'
alias units='units --history "${XDG_CACHE_HOME}/units_history"'
alias code='code --extensions-dir "${XDG_DATA_HOME}/vscode"'
alias vscodium='vscodium --extensions-dir "${XDG_DATA_HOME}/vscode"'
alias wget='wget --quiet --hsts-file="${XDG_CACHE_HOME}/wget-hsts" --continue --show-progress'
alias xbindkeys='xbindkeys -f "${XDG_CONFIG_HOME}/xbindkeys/config"'
alias xrdb='xrdb -load "${XDG_CONFIG_HOME}/X11/xresources"'
alias yarn='yarn --use-yarnrc "${XDG_CONFIG_HOME}/yarn/config"'
alias alpine='alpine -p "${XDG_CONFIG_HOME}/alpine/pinerc"'
alias arduino-cli='arduino-cli --config-file "${XDG_CONFIG_HOME}/arduino15/arduino-cli.yaml"'
alias info='info --init-file "${XDG_CONFIG_HOME}/infokey"'
alias valie='vale --config "${XDG_CONFIG_HOME}/vale/config.ini"'
alias x2goclient='x2goclient --home="${XDG_CONFIG_HOME}"'
# Go X directory(ies) up
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
# Remove unused packages
alias autoremove='pacman -Qdtq | sudo pacman -Rs -'
# Create backup of files/folders with rync
alias backup='rsync -vcrlptgoDHEAXh --progress --stats'
alias backup-dry='rsync -vcrlptgoDHEAXh --progress --stats --dry-run'
# Check PKGBUILD and generate .SRCINFO before running makepkg to install it
alias build='namcap PKGBUILD && makepkg --printsrcinfo > .SRCINFO && makepkg -si'
# Get difference between files
alias cdiff='colordiff -ry --suppress-common-lines'
# Check for rootkits, viruses, etc and run system audit
alias check-security='sudo rkhunter --update > /dev/null && \
                      sudo rkhunter --propupd > /dev/null && \
                      sudo rkhunter -c --rwo --sk; \
                      sudo lynis audit system --forensics --pentest; \
                      sudo clamdscan -mz /boot /etc /home /lost+found /mnt /opt /root /srv /tmp /usr /var'
# Delete old php sessions
alias cleanphp='sudo find /var/lib/php/ -type f -name "sess_*" -amin +4320 -exec rm {} +;'
# Clear old logs
alias clearlog='sudo journalctl --vacuum-size=1B'
# Get active connections
alias connections='sudo netstat --tcp --udp -alnp'
# Copy using rsync
alias copy='rsync -vcrlptgoDHEAXh --progress --stats'
alias copy-dry='rsync -vcrlptgoDHEAXh --progress --stats --dry-run'
# Colordiff with side by side view and tab/space ignoring
alias cdiff='colordiff --suppress-common-lines -y'
# Add color for diff by default
alias diff='diff --color=auto --suppress-common-lines -y'
# Find file duplicates
alias duplicates='rmlint -g'
# Display error/warning messages (all or just from today)
alias error='journalctl --no-hostname -q -p 4'
alias error-today='journalctl --no-hostname -q -p 4 -b'
# Get fail2ban bans
alias fail2ban-log='grep "Ban " /var/log/fail2ban.log | sort | logresolve | uniq -c | sort -n'
# Free unused memory/cache
alias freemem='printf "Clearing PageCache, dentries and inodes:\n"; \
               sudo sync; \
               echo 3 | sudo tee -a /proc/sys/vm/drop_caches; \
               printf "Clearing swap\n"; \
               sudo swapoff -a && \
               sudo swapon -a'
# Scan all ports; TCP ports; UDP ports; OS/Service detection; Service/Daemon versions
alias full-scan='sudo nmap -p 1-65535 -sT -sU -A -sV'
# fzf integrations
## Bat/Cat integration
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
## Package manager integration
alias fsearch='sudo pacman -Fy; pacman -Slq | fzf --multi --preview "cat <(pacman -Si {1}) <(pacman -Fl {1} | awk "{print \$2}")"'
alias finstall='sudo pacman -Fy; pacman -Slq | fzf --multi --preview "cat <(pacman -Si {1}) <(pacman -Fl {1} | awk "{print \$2}")" | xargs -ro sudo pacman -S'
alias fremove='pacman -Qq | fzf --multi --preview "pacman -Qi {1}" | xargs -ro sudo pacman -Rns'
alias funinstall='pacman -Qq | fzf --multi --preview "pacman -Qi {1}" | xargs -ro sudo pacman -Rns'
## Find and edit
alias fvi='vi $(fzf)' 
alias fvim='vim $(fzf)'  
alias fnano='nano $(fzf)' 
alias fedit='${EDITOR:-vim} $(fzf)' 
## Find and open with default app
alias fopen='xdg-open $(fzf)'      
## Interactive cd
alias fcd='fcd'  
## History search
alias fhistory='history | fzf | cut -c8-'
## Find and kill process
alias fkill='ps aux | fzf | awk "{print \$2}" | xargs kill -9'  
## Git: Add
alias gadd='gadd'  
## Git: Checkout branch
alias gcheckout='git branch | fzf | xargs git checkout'  
## Git: Log
alias glog='git log --oneline | fzf --preview "git show {+1}"'  
## aws-cli integration
alias awsp='aws_profile'          # Select AWS profile
alias awsr='aws_region'           # Select AWS region
alias awss='aws_setup'            # Setup both AWS profile and region
alias awsrs='aws_resource_search' # Search AWS resources
# Terraform integration
alias tfw='tf_workspace'          # Select terraform workspace
alias tfs='tf_state_view'         # View terraform state
alias tfp='tf_plan'               # Create new plan
alias tfp='tf_plan_view'          # View terraform plan files
alias tfa='tf_apply'              # Apply latest plan
alias tfd='tf_destroy'            # Destroy with safety checks
# Git alias
alias g='git'
# Visualize repository activity
alias gource='gource -s 1 --key -a 1 --user-image-dir "$(git rev-parse --show-toplevel)/.git/avatar"'
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
# Add color for grep by default
alias grep='grep --color=auto'
# Help command
alias help='run-help'
# Display network usage
alias iftop="sudo iftop -m 1024K -i \$(route | grep 'default' | head -n 1 | awk '{print \$8}')"
# Display I/O usage
alias iotop='sudo iotop -oP'
# Add color for ip by default
alias ip='ip -color=auto'
# Kubectl alias
alias k='kubectl'
alias kx='kubectx'
# LibreOffice Fix
alias libreoffice='LD_PRELOAD=/usr/lib/libfreetype.so libreoffice'
# Get user log in attempts
alias logins='(sudo find /var/log -type f -name "auth.log" -exec cat {} \+; \
               sudo find /var/log -type f -name "auth.log.1" -exec cat {} \+; \
               sudo find /var/log -type f -name "auth.log.*.gz" -exec zcat {} \+) | \
                grep -oE "opened for user .*" | \
                awk "{print $2}" | \
                sort | \
                uniq -c'
# Add color for ls by default
alias ls='ls --color=auto'
# Display files/folders sorted by name
alias lsa='ls -lah --color=auto'
# Display files/folders sorted by creation date
alias lsc='ls -lahtr --color=auto --time=birth'
# Display files/folders
alias lsh='ls -lah --color=auto --group-directories-first'
# Display files/folders sorted by modification date
alias lsm='ls -lahtr --color=auto --time=ctime'
# Update package mirror list
alias mirror-update='sudo reflector --latest 5 --country $(curl --silent https://ipapi.co/country_code | echo "Germany") --age 12 --protocol https --sort rate --threads $(nproc) --save /etc/pacman.d/mirrorlist'
# Create subdirectories as well if needed
alias mkdir='mkdir -vp'
# Compress all video files in folder using nvidia encode and hevc
alias mov-compress='for mov in *.mp4; do ffmpeg -hide_banner -loglevel warning -i "${mov}" -preset slow -c:v h264_nvenc -b:v 2M -c:a aac -b:a 128k $(basename "${mov}" ".mp4")_compr.mp4; done'
# Get current IP
alias myip='curl http://my.ip.fi/ || echo "Could not retrieve IP. Are you connected to the internet?"'
# Get new configs (.pacnew)
alias newconf='sudo find /etc -type f -name "*.pacnew"'
# Clean package cache (keep only the latest versions)
alias pacclean='sudo paccache -rk 2'
# Run last command as root again
alias please="sudo !!"
# Scan all ports; TCP ports; UDP ports
alias quick-scan='sudo nmap -p 1-65535 -sT -sU'
# Retrieve random 64 character string via /dev/urandom
alias random='< /dev/urandom tr --delete --complement _A-Z-a-z-0-9 | head --bytes=${1:-64}; echo;'
# Instead of deleting everything right away use trash-cli ti move it to the trashcan
alias rm='trash-put'
# List running services
alias running-services='systemctl list-units | grep -E "UNIT.*LOAD.*ACTIVE.*SUB.*DESCRIPTION|running"'
# Scan system with ClamAV
alias scan='clamdscan --fdpass -m -i --quiet /'
# Get size of file or folder
alias size='du -sch 2> /dev/null'
# List disks with space usage
alias space='df -h --print-type --exclude-type=tmpfs --exclude-type=devtmpfs'
# Display temperature from CPU and Nvidia gpu
alias temperature='sensors | grep Package | sed -e '\''s/\+//g'\'' -e '\''s/\..*/\°C/g'\'' | awk '\''{print "CPU: " $4}'\''; echo "GPU: $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits || aticonfig --od-gettemperature)°C"'
# Get a list of all ToDo's and Fix(me)'s in a folder
alias todo='grep --recursive --line-number --extended-regexp "todo|\s+fix(me)\s+?"'
# Empty trashcan
alias trash-empty='trash-empty; \
                   sudo trash-empty'
# Download and install updates
alias update='sudo pacman -Syuq && \
              yay -Sua; \
              sudo updatedb; \
              sudo pkgfile --update'
# List available updates
alias updates='pacman -Qu'
# Fetch new mirror list and update as above, clean the package cache and remove unused packages
alias upgrade='mirror-update && \
               update && \
               pacclean && \
               autoremove'
# Scan all ports; TCP ports; UDP ports; CVE detection; Malware detection; Google malware detection
alias vuln-scan='sudo nmap -p 1-65535 -sT -sU -Pn --script vuln -sV --script=http-malware-host --script http-google-malware'
# Enable alias expansion for watch
alias watch='watch '
# Check which package provides a command
alias whatprovides='pkgfile --search'
# Check who is using up all that swap
alias whoisusingmyswap="smem --columns='pid user command swap' --sort=swap --reverse | awk '\$NF != \"0\" {print}'"
# Download youtube videos
alias yt-dl='youtube-dl --quiet --no-call-home --geo-bypass --yes-playlist --hls-prefer-ffmpeg --no-overwrites --continue --audio-quality 0 --embed-thumbnail --add-metadata --prefer-ffmpeg'
