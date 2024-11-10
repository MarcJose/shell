#!/bin/sh

# Require root permissions
if [ "$(id -u)" -ne 0 ]; then
    echo "This script requires root permissions"
    echo "Please run with: sudo $0"
    exit 1
fi

# Constants
REPO_OWNER="user"
REPO_NAME="repo"
REPO_BRANCH="main"
REPO_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}"
API_URL="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}"

# Directory permissions
DIR_PERM_SYSTEM="755"  # rwxr-xr-x
DIR_PERM_USER="700"    # rwx------

# File permissions
FILE_PERM_SYSTEM="644" # rw-r--r--
FILE_PERM_USER="600"   # rw-------

# System directories to create
SYSTEM_DIRS="
"

# System files to update
SYSTEM_FILES="
"

# User files to update
USER_FILES="
.profile
.zshrc
"

create_directories() {
    # Create system directories with secure permissions
    echo "${SYSTEM_DIRS}" | while IFS= read -r dir; do
        [ -z "${dir}" ] && continue
        if [ ! -d "${dir}" ]; then
            echo "Creating directory ${dir}"
            mkdir -p "${dir}"
            chmod "${DIR_PERM_SYSTEM}" "${dir}"
            chown root:root "${dir}"
        fi
    done

    # Create user directories if needed
    user="${SUDO_USER:-${USER}}"
    home=$(getent passwd "${user}" | cut -d: -f6)
    
    # Example: create .config directory if needed
    user_dirs=".config"
    echo "${user_dirs}" | while IFS= read -r dir; do
        [ -z "${dir}" ] && continue
        if [ ! -d "${home}/${dir}" ]; then
            echo "Creating user directory ${dir}"
            mkdir -p "${home}/${dir}"
            chmod "${DIR_PERM_USER}" "${home}/${dir}"
            chown "${user}:$(id -gn "${user}")" "${home}/${dir}"
        fi
    done
}

update_system_config() {
    # Detect OS and set directory
    OS_DIR=""
    if [ -f "/etc/arch-release" ]; then
        OS_DIR="archlinux"
    elif [ -f "/etc/lsb-release" ] && grep -q "Ubuntu 24.04" "/etc/lsb-release"; then
        OS_DIR="ubuntu_24_04"
    else
        echo "Unsupported OS"
        return 1
    fi

    echo "Detected OS directory: ${OS_DIR}"

    # Get latest commit hash
    REMOTE_VERSION=$(curl -s "${API_URL}/commits?sha=${REPO_BRANCH}" \
        | grep -m 1 '"sha":' | cut -d'"' -f4)
    
    # Get current version from shell.conf if it exists
    CURRENT_VERSION=""
    if [ -f "/etc/environment.d/90-shell.conf" ]; then
        CURRENT_VERSION=$(grep "^SYSTEM_CONFIG_VERSION=" "/etc/environment.d/90-shell.conf" | cut -d'=' -f2)
    fi

    if [ "${CURRENT_VERSION}" != "${REMOTE_VERSION}" ]; then
        echo "Update available!"
        
        # Create temporary directory with secure permissions
        TEMP_DIR=$(mktemp -d)
        chmod 700 "${TEMP_DIR}"
        
        # Update system file
        update_file() {
            file="$1"
            echo "Updating ${file}"
            remote_path="${REPO_URL}/raw/${REPO_BRANCH}/${OS_DIR}${file}"
            
            # Download to temp location first
            if curl -s "${remote_path}" -o "${TEMP_DIR}/$(basename "${file}")"; then
                # If it's shell.conf, update the version
                if [ "${file}" = "/etc/environment.d/90-shell.conf" ]; then
                    echo "SYSTEM_CONFIG_VERSION=${REMOTE_VERSION}" >> "${TEMP_DIR}/$(basename "${file}")"
                fi
                
                # Create directory if it doesn't exist
                dir=$(dirname "${file}")
                if [ ! -d "${dir}" ]; then
                    mkdir -p "${dir}"
                    chmod "${DIR_PERM_SYSTEM}" "${dir}"
                    chown root:root "${dir}"
                fi
                
                # Move file to system location (we're already root)
                mv "${TEMP_DIR}/$(basename "${file}")" "${file}"
                chmod "${FILE_PERM_SYSTEM}" "${file}"
                chown root:root "${file}"
            else
                echo "Failed to download ${file}"
                rm -rf "${TEMP_DIR}"
                return 1
            fi
        }

        # Update user file
        update_user_file() {
            file="$1"
            user="${SUDO_USER:-${USER}}"
            home=$(getent passwd "${user}" | cut -d: -f6)
            
            echo "Updating ${file} for user ${user}"
            remote_path="${REPO_URL}/raw/${REPO_BRANCH}/${OS_DIR}/${file}"
            
            if curl -s "${remote_path}" -o "${home}/${file}"; then
                chown "${user}:$(id -gn "${user}")" "${home}/${file}"
                chmod "${FILE_PERM_USER}" "${home}/${file}"
            else
                echo "Failed to download ${file}"
                rm -rf "${TEMP_DIR}"
                return 1
            fi
        }

        # Create necessary directories first
        create_directories
        
        # Update all system files
        echo "${SYSTEM_FILES}" | while IFS= read -r file; do
            [ -z "${file}" ] && continue
            update_file "${file}" || exit 1
        done
        
        # Update all user files
        echo "${USER_FILES}" | while IFS= read -r file; do
            [ -z "${file}" ] && continue
            update_user_file "${file}" || exit 1
        done
        
        # Cleanup
        rm -rf "${TEMP_DIR}"
        
        echo "Update successful!"
        echo "Please restart your shell or source the updated files for changes to take effect."
    else
        echo "Already up to date."
    fi
}

# Function to source updated files
source_updates() {
    # Source system files if they exist
    echo "${SYSTEM_FILES}" | while IFS= read -r file; do
        [ -z "${file}" ] && continue
        if [ -f "${file}" ]; then
            . "${file}"
        fi
    done
    
    # Source user files if they exist
    user="${SUDO_USER:-${USER}}"
    home=$(getent passwd "${user}" | cut -d: -f6)
    
    echo "${USER_FILES}" | while IFS= read -r file; do
        [ -z "${file}" ] && continue
        if [ -f "${home}/${file}" ]; then
            . "${home}/${file}"
        fi
    done
}

# Main execution
update_system_config && source_updates