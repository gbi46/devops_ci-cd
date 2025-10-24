#!/bin/bash

# ===========================
# install_dev_tools.sh
# Automated installer for:
#   - Docker
#   - Docker Compose
#   - Python 3.9+
#   - Django (via pip)
# The script checks if each tool is already installed before installing.
# ===========================

set -e  # Exit immediately if any command fails

echo "Starting development environment setup..."

# ---------------------------
# Helper function to check if a command exists
# ---------------------------
check_command() {
    command -v "$1" >/dev/null 2>&1
}

# ---------------------------
# Install Docker
# ---------------------------
if check_command docker; then
    echo "Docker is already installed: $(docker --version)"
else
    echo "Installing Docker..."
    sudo apt update -y
    sudo apt install -y ca-certificates curl gnupg lsb-release

    # Add Docker’s official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Set up the Docker repository
    echo \
      "deb [arch=$(dpkg --print-architecture) \
      signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "Docker installed successfully!"
    sudo systemctl enable docker
    sudo systemctl start docker
fi

# ---------------------------
# Install Docker Compose
# ---------------------------
if check_command docker-compose; then
    echo "Docker Compose is already installed: $(docker-compose --version)"
else
    echo "Installing Docker Compose..."
    LATEST_COMPOSE=$(curl -s https://api.github.com/repos/docker/compose/releases/latest \
        | grep browser_download_url | grep docker-compose-$(uname -s)-$(uname -m) \
        | cut -d '"' -f 4)
    
    sudo curl -L "$LATEST_COMPOSE" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    
    echo "Docker Compose installed successfully!"
fi

# ---------------------------
# Install Python 3.9 or newer
# ---------------------------
if check_command python3; then
    PY_VERSION=$(python3 -V 2>&1 | awk '{print $2}')
    # Compare installed version with 3.9
    if [[ "$(printf '%s\n' "3.9" "$PY_VERSION" | sort -V | head -n1)" = "3.9" ]]; then
        echo "Python version $PY_VERSION is sufficient."
    else
        echo "Current Python version ($PY_VERSION) is too old. Installing a newer one..."
        sudo apt install -y python3 python3-pip
    fi
else
    echo "Installing Python..."
    sudo apt update -y
    sudo apt install -y python3 python3-pip python3-venv
    echo "Python installed successfully!"
fi

# ---------------------------
# Install Django using pip
# ---------------------------
if python3 -m pip show django >/dev/null 2>&1; then
    DJANGO_VER=$(python3 -m django --version)
    echo "Django is already installed (version $DJANGO_VER)"
else
    echo "Installing Django..."
    python3 -m venv .venv
    source .venv/bin/activate
    python3 -m pip install --upgrade pip
    python3 -m pip install django
    echo "Django installed successfully!"
fi

echo "All required development tools have been installed successfully!"
