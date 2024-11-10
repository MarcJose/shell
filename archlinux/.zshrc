#!/bin/zsh


#------------------------------------------------------------------------------
# Initial Setup and Error Handling
#------------------------------------------------------------------------------
# Set umask for better security
# Files: 600 (rw-------)
# Directories: 700 (rwx------)
umask 077


#------------------------------------------------------------------------------
# Basic Configuration
#------------------------------------------------------------------------------
# Source profile file for environment variables and basic setup
. ~/.profile
# Enable command-not-found suggestion functionality
. /usr/share/doc/pkgfile/command-not-found.zsh


#------------------------------------------------------------------------------
# Plugin Configuration
#------------------------------------------------------------------------------
# Enable syntax highlighting for commands (must be sourced before other plugins)
. /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Configure fuzzy finder (fzf) for enhanced file/history search
. /usr/share/fzf/key-bindings.zsh
. /usr/share/fzf/completion.zsh
. <(fzf --zsh)
# Enable fish-like autosuggestions based on command history
. /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)  # Use both history and completion for suggestions
ZSH_AUTOSUGGEST_USE_ASYN=true                  # Enable async mode for better performance


#------------------------------------------------------------------------------
# History Configuration
#------------------------------------------------------------------------------
# Set history file location and size
HISTSIZE=10000                                    # Number of commands loaded into memory
SAVEHIST=10000                                    # Number of commands stored in the zsh history file
HISTFILE="${XDG_CACHE_HOME}/zsh/history"          # History file location
# Create history directory if it doesn't exist
[[ ! -d "${XDG_CACHE_HOME}/zsh" ]] && mkdir -p "${XDG_CACHE_HOME}/zsh"
# History options
setopt EXTENDED_HISTORY         # Record timestamp of command in HISTFILE
setopt HIST_IGNORE_DUPS         # Don't save duplicate commands in history
setopt HIST_REDUCE_BLANKS       # Remove unnecessary whitespace from commands
setopt HIST_IGNORE_SPACE        # Don't save commands starting with space
setopt SHARE_HISTORY            # Share history between all sessions
setopt INC_APPEND_HISTORY       # Add commands to HISTFILE in order of execution


#------------------------------------------------------------------------------
# Shell Behavior Options
#------------------------------------------------------------------------------
# Enable completion for aliases
setopt COMPLETE_ALIASES
# Disable terminal beep
setopt NO_BEEP
# Allow changing directory by just typing its name
setopt AUTO_CD
# Enable command correction suggestions
setopt CORRECT
# Enable advanced pattern matching
setopt EXTENDED_GLOB
# Additional behavior improvements
setopt INTERACTIVE_COMMENTS      # Allow comments in interactive shells
setopt HASH_LIST_ALL            # Hash entire command path first
setopt NOTIFY                   # Report status of background jobs immediately


#------------------------------------------------------------------------------
# Completion System Configuration
#------------------------------------------------------------------------------
# Configure completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"
# Enable menu-driven completion
zstyle ':completion:*' menu select
# Allow completion of sudo commands
zstyle ':completion::complete:*' gain-privileges 1
# Automatically rehash PATH to find new executables
zstyle ':completion:*' rehash true
# Enable faster completion for exact matches
zstyle ':completion:*' accept-exact '*(N)'
# Initialize completion system
COMPLETIONCACHE="${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"
if [ ! -d "${COMPLETIONCACHE}" ]; then
  mkdir -p "${COMPLETIONCACHE}"
fi
# Load bash compatibility layer
autoload -U +X bashcompinit && bashcompinit
# Initialize the completion system
autoload -Uz compinit
compinit -d "${COMPLETIONCACHE}"


#------------------------------------------------------------------------------
# Command Line Navigation
#------------------------------------------------------------------------------
# Enable history search functionality
autoload -Uz history-beginning-search-backward history-beginning-search-forward
zle -N history-beginning-search-backward
zle -N history-beginning-search-forward


#------------------------------------------------------------------------------
# Help System
#------------------------------------------------------------------------------
# Load extended help system for various commands
autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-openssl
autoload -Uz run-help-p4
autoload -Uz run-help-sudo
autoload -Uz run-help-svk
autoload -Uz run-help-svn


#------------------------------------------------------------------------------
# Terminal Control
#------------------------------------------------------------------------------
# Reset terminal state
ttyctl -f


#------------------------------------------------------------------------------
# Key Bindings
#------------------------------------------------------------------------------
# Initialize key array
typeset -g -A key
# Set up line navigation functions
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# Define special keys
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"
# Bind keys to their respective functions
[ -n "${key[Home]}"          ] && bindkey -- "${key[Home]}"          beginning-of-line
[ -n "${key[End]}"           ] && bindkey -- "${key[End]}"           end-of-line
[ -n "${key[Insert]}"        ] && bindkey -- "${key[Insert]}"        overwrite-mode
[ -n "${key[Backspace]}"     ] && bindkey -- "${key[Backspace]}"     backward-delete-char
[ -n "${key[Delete]}"        ] && bindkey -- "${key[Delete]}"        delete-char
[ -n "${key[Up]}"            ] && bindkey -- "${key[Up]}"            up-line-or-beginning-search
[ -n "${key[Down]}"          ] && bindkey -- "${key[Down]}"          down-line-or-beginning-search
[ -n "${key[Left]}"          ] && bindkey -- "${key[Left]}"          backward-char
[ -n "${key[Right]}"         ] && bindkey -- "${key[Right]}"         forward-char
[ -n "${key[PageUp]}"        ] && bindkey -- "${key[PageUp]}"        beginning-of-buffer-or-history
[ -n "${key[PageDown]}"      ] && bindkey -- "${key[PageDown]}"      end-of-buffer-or-history
[ -n "${key[Shift-Tab]}"     ] && bindkey -- "${key[Shift-Tab]}"     reverse-menu-complete
[ -n "${key[Control-Left]}"  ] && bindkey -- "${key[Control-Left]}"  backward-word
[ -n "${key[Control-Right]}" ] && bindkey -- "${key[Control-Right]}" forward-word
# Set up terminal application mode
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  autoload -Uz add-zle-hook-widget
  zle_application_mode_start() {
    echoti smkx
  }
  zle_application_mode_stop() {
    echoti rmkx
  }
  add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
  add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi


#------------------------------------------------------------------------------
# Directory Stack Configuration
#------------------------------------------------------------------------------
# Initialize directory stack
autoload -Uz add-zsh-hook
DIRSTACKFOLDER="${XDG_CACHE_HOME}/zsh"
[ ! -d "${DIRSTACKFOLDER}" ] && mkdir -p "${DIRSTACKFOLDER}"
DIRSTACKFILE="${DIRSTACKFOLDER}/dirs"
# Load previous directory stack if it exists
if [ -f "$DIRSTACKFILE" ] && (( ${#dirstack} == 0 )); then
  dirstack=("${(@f)"$(< "$DIRSTACKFILE")"}")
  [ -d "${dirstack[1]}" ] && cd -- "${dirstack[1]}"
fi
# Save directory stack on directory change
chpwd_dirstack() {
  print -l -- "$PWD" "${(u)dirstack[@]}" > "$DIRSTACKFILE"
}
add-zsh-hook -Uz chpwd chpwd_dirstack
# Configure directory stack behavior
DIRSTACKSIZE='100'
setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS


#------------------------------------------------------------------------------
# Version Control System Integration
#------------------------------------------------------------------------------
# Enable VCS information in prompt
setopt prompt_subst
autoload -Uz vcs_info
# Configure VCS information format
zstyle ':vcs_info:*' actionformats '%b|%a'  # Branch and action
zstyle ':vcs_info:*' formats '%b'           # Branch only
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b:%r'
zstyle ':vcs_info:*' enable git cvs svn
# VCS information wrapper function
__vcs_info_wrapper() {
  vcs_info
  if [ -n "${vcs_info_msg_0_}" ]; then
    echo "(%F{cyan}${vcs_info_msg_0_}%f)$del"
  fi
}


#------------------------------------------------------------------------------
# Enhanced Prompt with Command Execution Time
#------------------------------------------------------------------------------
# Function to format command execution time
__cmd_exec_time() {
  local stop=$(date +%s)
  local start=${cmd_timestamp:-$stop}
  integer elapsed=$stop-$start
  (($elapsed > 2)) && print -P "%F{yellow}${elapsed}s%f"
}
# Function to record command start time
__record_time_preexec() {
  cmd_timestamp=$(date +%s)
}
# Add hook for command execution time
add-zsh-hook preexec __record_time_preexec
# Build prompt with status, date, username, VCS info, and execution time
__build_prompt() {
  PROMPT="[%(?.%F{green}✔.%F{red}✗)%f][%F{green}%D{%Y-%m-%d} %T%f][%F{green}%n%f]$(__vcs_info_wrapper)$(__cmd_exec_time): "
  RPROMPT='%B%F{cyan}%2d%f%b'
}
# Update prompt before each command
precmd() {
  __build_prompt
}


#------------------------------------------------------------------------------
# Color Support
#------------------------------------------------------------------------------
# Enable 24-bit color support if available
[[ "${COLORTERM}" == (24bit|truecolor) || "${terminfo[colors]}" -eq '16777216' ]] || zmodload zsh/nearcolor


#------------------------------------------------------------------------------
# Tool-specific Completion
#------------------------------------------------------------------------------
# Enable Terraform completion if installed
[ -f /usr/bin/terraform ] && complete -o nospace -C /usr/bin/terraform terraform
# Enable OpenTofu completion if installed
[ -f /usr/bin/tofu ] && complete -o nospace -C /usr/bin/tofu tofu


#------------------------------------------------------------------------------
# Load local configurations
#------------------------------------------------------------------------------
[ -f ~/.zshrc.local ] && . ~/.zshrc.local


#------------------------------------------------------------------------------
# Welcome Message
#------------------------------------------------------------------------------
# Display system information on shell startup
__welcome() {
  MSG+="Systeminformation:\n"
  MSG+=" Kernel:       ${KERNEL}\n"
  MSG+=" CPU:          ${CPU}\n"
  MSG+=" GPU:          ${GPU}\n"
  MSG+=" RAM:          ${RAM} GB\n"
  MSG+=" IP:           ${IP}\n"
  MSG+=" MAC:          ${MAC}"

  print -P "${MSG}" | cowthink -f /usr/share/cowsay/cows/small.cow -W 500 -n
}

# Run welcome message on startup
__welcome
