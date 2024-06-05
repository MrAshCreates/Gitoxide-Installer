#!/bin/bash

# Function to install curl on Linux
install_curl_linux() {
    echo "Installing curl..."
    sudo apt update
    sudo apt install -y curl
    echo "curl installed successfully."
}

# Function to install git on Linux
install_git_linux() {
    echo "Installing git..."
    sudo apt update
    sudo apt install -y git
    echo "git installed successfully."
}

# Function to install brew on macOS
install_brew_macos() {
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "Homebrew installed successfully."
}

# Function to install curl on macOS
install_curl_macos() {
    echo "Installing curl..."
    brew install curl
    echo "curl installed successfully."
}

# Function to install git on macOS
install_git_macos() {
    echo "Installing git..."
    brew install git
    echo "git installed successfully."
}

# Function to install Rust
install_rust() {
    echo "Rust not found. Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    echo "Rust installed successfully."
}

# Function to install gitoxide
install_gitoxide() {
    echo "Installing gitoxide..."
    cargo install gitoxide
    echo "gitoxide installed successfully."
}

# Function to uninstall gitoxide
uninstall_gitoxide() {
    echo "Uninstalling gitoxide..."
    cargo uninstall gitoxide
    echo "gitoxide uninstalled successfully."
}

# Function to add Cargo bin to PATH
add_cargo_to_path() {
    if [[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]]; then
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
        echo 'set -x PATH $HOME/.cargo/bin $PATH' >> ~/.config/fish/config.fish
        source "$HOME/.cargo/env"
        echo "Cargo bin directory added to PATH."
    fi
}

# Function to install tools on Windows
install_windows_tools() {
    echo "Installing tools on Windows..."
    choco install -y curl git
    echo "Tools installed successfully."
}

# Function to check if gitoxide is installed via Homebrew on macOS
gitoxide_installed_via_brew() {
    brew list gitoxide &>/dev/null
}

# Main script logic
echo "Starting installation process..."

# Check for operating system
OS=$(uname)
if [[ "$OS" == "Linux" ]]; then
    # Install curl and git if not present
    if ! command -v curl >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1; then
        install_curl_linux
        install_git_linux
    else
        echo "curl and git are already installed."
    fi

    # Install Rust if not present
    if ! command -v rustc >/dev/null 2>&1; then
        install_rust
    else
        echo "Rust is already installed."
    fi

    # Source Rust environment
    source "$HOME/.cargo/env"

    # Install gitoxide if not already installed
    if ! command -v gix >/dev/null 2>&1; then
        install_gitoxide
    else
        echo "gitoxide is already installed."
    fi

    # Add Cargo bin to PATH
    add_cargo_to_path

    echo "Installation process completed."
elif [[ "$OS" == "Darwin" ]]; then
    # Check if Homebrew is installed; if not, install it
    if ! command -v brew >/dev/null 2>&1; then
        install_brew_macos
    else
        echo "Homebrew is already installed."
    fi

    # Install curl and git if not present
    if ! command -v curl >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1; then
        install_curl_macos
        install_git_macos
    else
        echo "curl and git are already installed."
    fi

    # Install Rust if not present
    if ! command -v rustc >/dev/null 2>&1; then
        install_rust
    else
        echo "Rust is already installed."
    fi

    # Source Rust environment
    source "$HOME/.cargo/env"

    # Check if gitoxide is already installed via Homebrew
    if gitoxide_installed_via_brew; then
        read -p "gitoxide is already installed. Do you want to (r)einstall or (u)ninstall it? (r/u): " choice
        if [[ "$choice" == "r" ]]; then
            echo "Reinstalling gitoxide..."
            brew reinstall gitoxide
            echo "gitoxide reinstalled successfully."
        elif [[ "$choice" == "u" ]]; then
            uninstall_gitoxide
        else
            echo "Invalid option. Exiting."
            exit 1
        fi
    else
        install_gitoxide
    fi

    # Add Cargo bin to PATH
    add_cargo_to_path

    echo "Installation process completed."
elif [[ "$OS" == "MINGW64_NT" || "$OS" == "MSYS_NT" || "$OS" == "CYGWIN_NT" ]]; then
    echo "Detected Windows environment."
    
    # Check if Chocolatey is installed; if not, install it
    if ! command -v choco >/dev/null 2>&1; then
        install_choco
    else
        echo "Chocolatey (choco) is already installed."
    fi
    
    # Install curl and git if not present
    if ! command -v curl >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1; then
        install_windows_tools
    else
        echo "curl and git are already installed."
    fi

    # Install Rust if not present
    if ! command -v rustc >/dev/null 2>&1; then
        install_rust
    else
        echo "Rust is already installed."
    fi

    # Source Rust environment
    source "$HOME/.cargo/env"

    # Install gitoxide if not already installed
    if ! command -v gix >/dev/null 2>&1; then
        install_gitoxide
    else
        echo "gitoxide is already installed."
    fi

    # Add Cargo bin to PATH
    add_cargo_to_path

    echo "Installation process completed."
else
    echo "Unsupported operating system: $OS"
    exit 1
fi
