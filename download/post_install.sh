#!/bin/bash
#                                                                             
# Script for Ubuntu                                                           
#                                                                             
                                                                            
V=`/usr/bin/lsb_release -rs`                                                  

if [ $V != 14.04 ]; then   
  exit 1                                                                    
fi

# Update
sudo apt-get update
	
# Set Default Editor
sudo update-alternatives --config editor

# SSH keys
mkdir ~/.ssh
chmod 700 ~/.ssh
cd .ssh
ssh-keygen -t rsa

# Install Useful Apps
sudo apt-get install vim git secure-delete
sudo apt-get install flashplugin-installer
sudo apt-get install p7zip-rar p7zip-full unace unrar zip unzip rar 

# Purge Unwanted Apps
sudo apt-get purge empathy-common empathy*
sudo apt-get purge transmission-* shotwell* totem*
sudo apt-get purge account-plugin-* friends*
sudo apt-get remove unity-webapps-common
sudo apt-get purge thunderbird*
sudo apt-get purge gnome-orca
sudo apt-get purge gnomine gnome-sudoku gnome-mahjongg

# Fix slow connection in ssh

sudo sed -i 's/GSSAPIAuthentication/#GSSAPIAuthentication/g' /etc/ssh/ssh_config
sudo sed -i 's/GSSAPIDelegateCredentials/#GSSAPIDelegateCredentials/g' /etc/ssh/ssh_config

# Always use the location (full URL) entry

gsettings set org.gnome.nautilus.preferences always-use-location-entry true

# Disable the HUD when pressing the ALT key

dconf write /org/compiz/profiles/unity/plugins/unityshell/show-launcher '""'
dconf write /org/compiz/integrated/show-hud "['disable']"

# Disable Features

gsettings set com.canonical.Unity.Lenses remote-content-search none
gsettings set com.canonical.Unity.Lenses disabled-scopes "[]"

# Gedit
gsettings set org.gnome.gedit.preferences.editor create-backup-copy false
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
gsettings set org.gnome.gedit.preferences.editor highlight-current-line true
gsettings set org.gnome.gedit.preferences.editor display-right-margin true
gsettings set org.gnome.gedit.preferences.editor scheme "'oblivion'"
gsettings set org.gnome.gedit.preferences.editor tabs-size 4

# Install tweak tools

sudo apt-get install unity-tweak-tool gnome-tweak-tool

# Install compiz manager
sudo apt-get -y install compizconfig-settings-manager

# Disable remote scopes
gsettings set com.canonical.Unity.Lenses disabled-scopes "[]"

# Clean

sudo apt-get autoremove
sudo apt-get autoclean

