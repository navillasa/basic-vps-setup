#!/bin/bash

# Update system
sudo apt update && sudo apt upgrade -y

# Create a new user - replace 'yourusername' with your preferred username
read -p "Enter new username: " USERNAME
adduser $USERNAME
usermod -aG sudo $USERNAME

# Setup SSH directory for new user
mkdir -p /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh

# Copy your public SSH key to the new user
read -p "Paste your public SSH key: " PUBKEY
echo $PUBKEY > /home/$USERNAME/.ssh/authorized_keys
chmod 600 /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

# Disable root SSH login and password authentication
sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Restart SSH to apply changes
sudo systemctl restart ssh

# Setup UFW firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
read -p "Enter app port to allow through firewall (e.g., 8080): " APPPORT
sudo ufw allow $APPPORT/tcp

# Enable UFW firewall
sudo ufw --force enable

# Install fail2ban
sudo apt install -y fail2ban

# Create basic fail2ban jail.local config for SSH
sudo tee /etc/fail2ban/jail.local > /dev/null <<EOF
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5
backend = systemd

[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
EOF

# Restart fail2ban to apply config
sudo systemctl restart fail2ban

echo "Setup complete. You can now SSH into the server using the new user: $USERNAME"

