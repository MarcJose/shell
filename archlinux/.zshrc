#!/bin/zsh


#------------------------------------------------------------------------------
# Initial Setup and Error Handling
#------------------------------------------------------------------------------
# Set umask for better security (files: 644, dirs: 755)
umask 022


#------------------------------------------------------------------------------
# Basic Configuration
#------------------------------------------------------------------------------
# Source profile file for environment variables and basic setup
. ~/.profile


#------------------------------------------------------------------------------
# Plugin Configuration
#------------------------------------------------------------------------------
# Enable syntax highlighting for commands (must be sourced before other plugins)
. /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Enable command-not-found suggestion functionality
. /usr/share/doc/pkgfile/command-not-found.zsh
# Enable searching by substrings
. /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
# Configure fuzzy finder (fzf) for enhanced file/history search
. /usr/share/fzf/key-bindings.zsh
. /usr/share/fzf/completion.zsh
. <(fzf --zsh)
# Enable fish-like autosuggestions based on command history
. /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#skip_global_compinit=1
# Use both history and completion for suggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# Enable async mode for better performance
ZSH_AUTOSUGGEST_USE_ASYN=true
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
# Show suggestions as you type
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_HISTORY_IGNORE='cd *'


#------------------------------------------------------------------------------
# History Configuration
#------------------------------------------------------------------------------
# Record timestamp of command in HISTFILE
setopt EXTENDED_HISTORY
# Don't save duplicate commands in history
setopt HIST_IGNORE_DUPS
# Remove unnecessary whitespace from commands
setopt HIST_REDUCE_BLANKS
# Don't save commands starting with space
setopt HIST_IGNORE_SPACE
# Share history between all sessions
setopt SHARE_HISTORY
# Add commands to HISTFILE in order of execution
setopt INC_APPEND_HISTORY


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
# Allow comments in interactive shells
setopt INTERACTIVE_COMMENTS
# Hash entire command path first
setopt HASH_LIST_ALL
# Report status of background jobs immediately
setopt NOTIFY
# Disable flow control
setopt noflowcontrol


#------------------------------------------------------------------------------
# Completion System Configuration
#------------------------------------------------------------------------------
# Configure completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"
# Enable menu-driven completion
zstyle ':completion:*' menu select=2
# Allow completion of sudo commands
zstyle ':completion::complete:*' gain-privileges 1
# Automatically rehash PATH to find new executables
zstyle ':completion:*' rehash true
# Enable faster completion for exact matches
zstyle ':completion:*' accept-exact '*(N)'
# Styling
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:pacman:*' force-list always
zstyle ':completion:*:*:pacman:*' menu yes select
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'   force-list always
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
# Add autocomplete window
zstyle ':autocomplete:*' default-context history-incremental-search-backward
# Initialize completion system
COMPLETIONCACHE="${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"
if [ ! -d "${COMPLETIONCACHE}" ]; then
  mkdir -p "${COMPLETIONCACHE}"
fi
# Load bash compatibility layer
autoload -U +X bashcompinit && bashcompinit
# Initialize the completion system
zmodload zsh/complist
autoload -Uz compinit promptinit
compinit -d "${COMPLETIONCACHE}"
promptinit -d "${COMPLETIONCACHE}"
# Real-time command completion
zle -N fzf-completion
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(fzf-completion)


#------------------------------------------------------------------------------
# Command Line Navigation
#------------------------------------------------------------------------------
# Custom widget for real-time command suggestions
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 | perl -ne 'print if !$seen{($_ =~ s/^\s*[0-9]+\s+//r)}++' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}
# Enable history search functionality
autoload -Uz history-beginning-search-backward history-beginning-search-forward
zle     -N   fzf-history-widget


#------------------------------------------------------------------------------
# Help System
#------------------------------------------------------------------------------
# Load extended help system for various commands
autoload -Uz run-help
(( ${+aliases[run-help]} )) && unalias run-help
alias help=run-help
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
# FZF and completion key bindings
bindkey '^R'   fzf-history-widget               # Ctrl+R for history search
bindkey '^T'   fzf-file-widget                  # Ctrl+T for file search
bindkey '^[c'  fzf-cd-widget                    # Alt+C for directory search
bindkey '^I'   expand-or-complete               # Tab for completion menu
bindkey '^ '   autosuggest-accept               # Ctrl+Space to accept suggestion
bindkey '^[[A' history-substring-search-up      # Up arrow
bindkey '^[[B' history-substring-search-down    # Down arrow
#bindkey '^I'   fzf-completion                   # Real-time command completion
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
DIRSTACKFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dirs"
if [[ -f "${DIRSTACKFILE}" ]] && (( ${#dirstack} == 0 )); then
	dirstack=("${(@f)"$(< "${DIRSTACKFILE}")"}")
	[[ -d "${dirstack[1]}" ]] && cd -- "${dirstack[1]}"
fi
# Save directory stack on directory change
chpwd_dirstack() {
	print -l -- "$PWD" "${(u)dirstack[@]}" > "${DIRSTACKFILE}"
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
# Branch and action
zstyle ':vcs_info:*' actionformats '%b|%a'
# Branch only
zstyle ':vcs_info:*' formats '%b'
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b:%r'
zstyle ':vcs_info:*' enable git cvs svn


#------------------------------------------------------------------------------
# AWS Profile Information
#------------------------------------------------------------------------------
__aws_profile_wrapper() {
  if [ -n "$AWS_PROFILE" ]; then
    echo "(%F{yellow}${AWS_PROFILE}%f)"
  fi
}


#------------------------------------------------------------------------------
# Terraform Workspace Information
#------------------------------------------------------------------------------
__terraform_workspace_wrapper() {
  if [ -f ".terraform/environment" ]; then
    local workspace=$(cat .terraform/environment)
    echo "(%F{magenta}${workspace}%f)"
  fi
}


#------------------------------------------------------------------------------
# VCS Information Wrapper
#------------------------------------------------------------------------------
__vcs_info_wrapper() {
  vcs_info
  if [ -n "${vcs_info_msg_0_}" ]; then
    echo "(%F{cyan}${vcs_info_msg_0_}%f)$del"
  fi
}


#------------------------------------------------------------------------------
# Python Virtualenv Information
#------------------------------------------------------------------------------
__virtualenv_wrapper() {
  if [ -n "$VIRTUAL_ENV" ]; then
    # Extract just the environment name from the full path
    local env_name=$(basename "$VIRTUAL_ENV")
    echo "(%F{blue}${env_name}%f)"
  fi
}


#------------------------------------------------------------------------------
# Enhanced Prompt with Command Execution Time
#------------------------------------------------------------------------------
# Build prompt with status, date, username, VCS info, and execution time
__build_prompt() {
  PROMPT="[%(?.%F{green}✔.%F{red}✗)%f][%F{green}%D{%Y-%m-%d} %T%f][%F{green}%n%f]$(__virtualenv_wrapper)$(__aws_profile_wrapper)$(__terraform_workspace_wrapper)$(__vcs_info_wrapper)
%F{green}→%f "
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
autoload -U colors zsh/terminfo
colors


#------------------------------------------------------------------------------
# Zoxide Support
#------------------------------------------------------------------------------
eval "$(zoxide init zsh)"
alias cd='z'


#------------------------------------------------------------------------------
# Tool-specific Completion
#------------------------------------------------------------------------------
# Enable Terraform completion if installed
[ -f /usr/bin/terraform ] && complete -o nospace -C /usr/bin/terraform terraform
# Enable OpenTofu completion if installed
[ -f /usr/bin/tofu ] && complete -o nospace -C /usr/bin/tofu tofu
# Enable Bun completion if installed
[ -s "${BUN_INSTALL}/_bun" ] && . "${BUN_INSTALL}/_bun"
export PATH="${BUN_INSTALL}/bin:$PATH"
# Enable Deno completion if installed
export FPATH="${XDG_CONFIG_HOME}/zsh/completions:$FPATH"
# Enable kubectl completion if installed
[ -x "$(command -v kubectl)" ] && . <(kubectl completion zsh)



#------------------------------------------------------------------------------
# User Configuration
#------------------------------------------------------------------------------
[ -f ~/.zshrc.local ] && . ~/.zshrc.local


#------------------------------------------------------------------------------
# Welcome Message
#------------------------------------------------------------------------------
# Display system information on shell startup
__welcome() {
  MSG+="Systeminformation:\n"
  MSG+=" OS:           ${OS}\n"
  MSG+=" Kernel:       ${KERNEL}\n"
  MSG+=" CPU:          ${CPU}\n"
  MSG+=" GPU:          ${GPU}\n"
  MSG+=" RAM:          ${RAM} GB\n"
  MSG+=" IP:           ${IP}\n"
  MSG+=" MAC:          ${MAC}"

  print -P "${MSG}" | cowthink -f /usr/share/cowsay/cows/small.cow -W 500 -n
}

# Run updater once after boot
update_dotfiles

# Run welcome message on startup
__welcome
