#!/bin/bash

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

# Function to check if gitoxide is installed via Homebrew
gitoxide_installed_via_brew() {
    brew list gitoxide &>/dev/null
}

# Function to handle macOS and Linux installations with Homebrew
install_with_brew() {
    if command -v brew >/dev/null 2>&1; then
        read -p "Would you like to install Rust and gitoxide using Homebrew? (y/n): " install_brew
        if [[ "$install_brew" == "y" ]]; then
            echo "Installing Rust and gitoxide with Homebrew..."
            brew install rust gitoxide
            return 0
        fi
    fi
    return 1
}

# Main script logic
echo "Starting installation process..."

# Check for operating system
OS=$(uname)
if [[ "$OS" == "Linux" || "$OS" == "Darwin" ]]; then
    # Check if Homebrew installation is desired
    if install_with_brew; then
        echo "Installation completed using Homebrew."
    else
        # Install Rust if not present
        if ! command -v rustc >/dev/null 2>&1; then
            install_rust
        else
            echo "Rust is already installed."
        fi

        # Source Rust environment
        source "$HOME/.cargo/env"

        # Check if gitoxide is already installed
        if command -v gix >/dev/null 2>&1 || gitoxide_installed_via_brew; then
            read -p "gitoxide is already installed. Do you want to (r)einstall or (u)ninstall it? (r/u): " choice
            if [[ "$choice" == "r" ]]; then
                echo "Reinstalling gitoxide..."
                if gitoxide_installed_via_brew; then
                    brew reinstall gitoxide
                else
                    cargo install --force gitoxide
                fi
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
    fi
elif [[ "$OS" == "MINGW64_NT" || "$OS" == "MSYS_NT" || "$OS" == "CYGWIN_NT" ]]; then
    echo "Detected Windows environment."
    # Install Rust if not present
    if ! command -v rustc >/dev/null 2>&1; then
        install_rust
    else
        echo "Rust is already installed."
    fi

    # Source Rust environment
    source "$HOME/.cargo/env"

    # Check if gitoxide is already installed
    if command -v gix >/dev/null 2>&1; then
        read -p "gitoxide is already installed. Do you want to (r)einstall or (u)ninstall it? (r/u): " choice
        if [[ "$choice" == "r" ]]; then
            echo "Reinstalling gitoxide..."
            cargo install --force gitoxide
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

    echo "Installation process completed."
else
    echo "Unsupported operating system: $OS"
    exit 1
fi
