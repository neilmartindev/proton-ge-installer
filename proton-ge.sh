#!/bin/bash

# Define the URL for the latest Proton-GE release.
PROTON_GE_URL="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest"

# Define the directory where Proton-GE should be installed.
STEAM_DIR="$HOME/.steam/root/compatibilitytools.d/"

# Fetch the latest Proton-GE release download URL (only .tar.gz files).
DOWNLOAD_URL=$(curl -s "$PROTON_GE_URL" | grep "browser_download_url" | grep "tar.gz" | cut -d '"' -f 4)

# Fetch the latest Proton-GE release version.
LATEST_VERSION=$(curl -s "$PROTON_GE_URL" | grep "tag_name" | cut -d '"' -f 4)

# Check if the latest version is already installed.
if [ -d "$STEAM_DIR/$LATEST_VERSION" ]; then
    echo "The latest version of Proton-GE ($LATEST_VERSION) is already installed."
    exit 0
else
    # Downloading message
    echo "Downloading Proton-GE $LATEST_VERSION..."
    
    # Download the latest Proton-GE release.
    wget -q --show-progress -O "/tmp/Proton-$LATEST_VERSION.tar.gz" "$DOWNLOAD_URL"

    # Extracting message
    echo -n "Extracting Proton-GE $LATEST_VERSION..."
    
    # Extract the downloaded release to the Steam compatibility tools directory and suppress output
    tar -xf "/tmp/Proton-$LATEST_VERSION.tar.gz" -C "$STEAM_DIR" &> /dev/null
    
    # Completion message
    echo "Done."
    echo "Proton-GE $LATEST_VERSION has been installed."

    # Fetch and format the changelog text for the latest version.
    CHANGELOG=$(curl -s "$PROTON_GE_URL" | grep '"body":' | cut -d '"' -f 4 | fold -w 80 -s)
    echo -e "\nChangelog for $LATEST_VERSION:\n----------------------------\n$CHANGELOG\n"

    # Clean up the downloaded file.
    rm "/tmp/Proton-$LATEST_VERSION.tar.gz"
fi
