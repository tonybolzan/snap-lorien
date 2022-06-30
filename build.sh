#!/bin/bash
set -euo pipefail
# Simple script to rebuild and run

# sudo snap install snapcraft --classic --channel 6.x/stable
# sudo snap install multipass
# snapcraft login

# Get latest version
VERSION_ONLINE=$(curl -sS "https://api.github.com/repos/mbrlabs/Lorien/releases/latest" | jq -r ".name" | sed -E 's/[^0-9.]+//g')

VERSION_LOCAL=$(grep 'version' snapcraft.yaml |awk '{print $2}')

if [ "$VERSION_LOCAL" != "$VERSION_ONLINE" ]; then
    echo >&2 "Version to be installed and local version don't match"
    echo >&2 " - Online: $VERSION_ONLINE"
    echo >&2 " - Local:  $VERSION_LOCAL"
    exit 1
fi

echo "Building Version: $VERSION_LOCAL"

curl -sSL "https://raw.githubusercontent.com/mbrlabs/Lorien/main/images/lorien.svg" --output lorien.svg

# Unistall old snap
sudo snap remove lorien

# Clean up old builds
rm -f lorien*.snap

# clean all cache
snapcraft clean

# Build new image
snapcraft --debug

# Install new image
sudo snap install --dangerous lorien*.snap

# Run new snap
snap run lorien

# Deploy
# sudo snap remove lorien
# snapcraft upload --release=edge lorien*.snap
# sudo snap install lorien --edge
