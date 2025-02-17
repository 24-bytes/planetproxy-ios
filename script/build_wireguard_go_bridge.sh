#!/bin/sh

# Ensure script fails on any error
set -e

# Get the build directory path
project_data_dir="$BUILD_DIR"

# Navigate up to the Build directory
while true; do
    parent_dir=$(dirname "$project_data_dir")
    basename=$(basename "$project_data_dir")
    project_data_dir="$parent_dir"
    if [ "$basename" = "Build" ]; then
        break
    fi
done

# Find WireGuard package directory
checkouts_dir="$project_data_dir"/SourcePackages/checkouts
if [ -e "$checkouts_dir"/wireguard-apple ]; then
    checkouts_dir="$checkouts_dir"/wireguard-apple
fi

wireguard_go_dir="$checkouts_dir"/Sources/WireGuardKitGo

# Ensure Go is in our path
export PATH="/opt/homebrew/bin:/usr/local/bin:${PATH}"

# Debug information
echo "Build directory: $BUILD_DIR"
echo "Checkouts directory: $checkouts_dir"
echo "WireGuard Go directory: $wireguard_go_dir"
echo "Go version: $(go version)"

# Build WireGuard Go implementation
if [ -d "$wireguard_go_dir" ]; then
    cd "$wireguard_go_dir" && make
else
    echo "Error: WireGuard Go directory not found at $wireguard_go_dir"
    exit 1
fi