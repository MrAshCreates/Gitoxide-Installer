# Gitoxide Installer Script

This script installs Rust and gitoxide, a fast, opinionated Git library for Rust, on your system. It supports macOS, Linux, and Windows (via WSL or other Unix-like environments).

## Prerequisites

Before running this script, ensure you have the following installed:

- **curl**: Used to download the Rust installer.
- **git**: Needed for installing gitoxide and managing git repositories.
- **cargo**: The Rust package manager, which is installed as part of the Rust installation process.

## Installation

1. Clone the repository or download the `install_gitoxide.sh` file:

   ```bash
   git clone https://github.com/your-username/your-repo.git
   cd your-repo
   ```

2. Make the script executable:

   ```bash
   chmod +x install_gitoxide.sh
   ```

3. Run the script:

   ```bash
   ./install_gitoxide.sh
   ```

## Usage

- When you run the script, it checks if Rust is installed. If not, it installs Rust via the Rustup installer.
- It then installs gitoxide using Cargo, the Rust package manager.
- If gitoxide is already installed, the script will prompt you to reinstall or uninstall it.
- If you're on macOS or Linux, the script gives you the option to install Rust and gitoxide via Homebrew.
- After installation, the Cargo bin directory (`$HOME/.cargo/bin`) is added to your PATH to make `gix` (gitoxide command-line tool) accessible.

## Usage Examples

### Installing Rust and gitoxide via Homebrew (macOS and Linux)

If you prefer to use Homebrew for installation, follow these steps:

1. Run the script:

   ```bash
   ./install_gitoxide.sh
   ```

2. When prompted, type `y` to install Rust and gitoxide via Homebrew.

### Reinstalling or Uninstalling gitoxide

If you already have gitoxide installed and want to reinstall or uninstall it, follow these steps:

1. Run the script:

   ```bash
   ./install_gitoxide.sh
   ```

2. When prompted, select `r` to reinstall or `u` to uninstall gitoxide.

## Notes

- This script assumes you have administrative privileges to install packages on your system.
- On Windows, ensure you are running the script within a Unix-like environment (e.g., WSL, Git Bash).
