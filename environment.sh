#!/bin/bash

mkdir -p ~/.local/bin

#######################
# Node
#######################
echo "Checking for Node..."
if ! node -v &> /dev/null; then
    echo "Node is not installed."
    echo "Installing Node..."
    curl -fsSL https://nodejs.org/dist/v20.11.1/node-v20.11.1-linux-x64.tar.xz | tar -xJ --strip-components=1 -C ~/.local
else
    echo "Node is installed with version: $(node -v)"
fi


#######################
# Rust
#######################
echo "Checking for Rust..."
if ! rustc -V &> /dev/null; then
    echo "Rust is not installed."
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
    echo "Rust is installed with version: $(rustc -V)"
fi


#######################
# Cargo Crates
#######################
CargoCrates=(eza stow-rs)

# Fetch the list of currently installed global crates once
installed_crates=$(cargo install --list | grep -E '^[a-zA-Z0-9_-]+ v[0-9]+' | awk '{print $1}')

for crate in "${CargoCrates[@]}"; do
    if echo "$installed_crates" | grep -qx "$crate"; then
        echo "✓ '$crate' is already installed."
    else
        echo "➜ '$crate' is not installed. Installing now..."
        cargo install "$crate"
    fi
done

#######################
# NEOVIM
#######################
if ! nvim -v &> /dev/null; then
    echo "NeoVim is not installed"
    echo "Installing NeoVim..."
  
    current_dir=$(pwd)
    NOW=$(date -u +"%Y%m%d%H%M%S")
    TEMP_DIR="/tmp/install_neovim_$NOW"
    mkdir -p "$TEMP_DIR"
    cd $TEMP_DIR
    mkdir to_copy_to_local
    git clone https://github.com/neovim/neovim
    cd neovim
    git checkout stable
    cmake --version &> /dev/null || {
        echo "CMake is not installed"
        echo "Getting CMake..."
        module load cmake || {
            echo "CMake is not available. Please install it manually."
            exit 1
        }
    }
    make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=${TEMP_DIR}/to_copy_to_local"
    make install
    cp -rv "${TEMP_DIR}/to_copy_to_local/"* "$HOME/.local/"
    
    cd $current_dir
    rm -rf $TEMP_DIR
else
    echo "NeoVim is installed with version: $(nvim -v)"
fi

