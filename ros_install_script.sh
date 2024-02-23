#!/bin/bash
# shellcheck source=/dev/null

# General system update
sudo apt-get update || error "Failed to update."
sudo apt list --upgradable || error "Failed to update the list."
sudo apt-get -y upgrade || error "Failed to upgrade."

info "Installing ROS2 Humble..."
# ROS Env
ROS_KEYRING="/usr/share/keyrings/ros-archive-keyring.gpg"
ROS_SOURCES_LIST="/etc/apt/sources.list.d/ros2.list"
ROS_REPO_URL="http://packages.ros.org/ros2/ubuntu"
ROS_KEY="https://raw.githubusercontent.com/ros/rosdistro/master/ros.key"

# Add ROS 2 repository
sudo apt install -y software-properties-common || error "Failed to install software-properties-common."
sudo add-apt-repository -y universe || error "Failed to add universe repository."
sudo apt update || error "Failed to update."
sudo apt install -y curl || error "Failed to update and install curl."

# Download ROS GPG key
download_and_save_key "$ROS_KEY" "$ROS_KEYRING"

# add apt source entry     
info "Adding ROS apt source entry"
echo "deb [arch=$(dpkg --print-architecture) signed-by=${ROS_KEYRING}] ${ROS_REPO_URL} $(. /etc/os-release && echo "$UBUNTU_CODENAME") main" | sudo tee "${ROS_SOURCES_LIST}" > /dev/null || error "Failed to add ROS apt source entry."

#system update
sudo apt-get update || error "Failed to update."
sudo apt-get -y upgrade || error "Failed to upgrade."

# Install ROS 2
sudo apt-get install -y ros-humble-desktop || error "Failed to Install ROS2."

# Source the ROS 2 setup script
source /opt/ros/humble/setup.bash
echo 'source /opt/ros/humble/setup.bash' >> ~/.bashrc

# Print success message
info "ROS2 Humble installation completed successfully."