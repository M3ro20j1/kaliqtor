#!/bin/zsh

###############################################
#                                             #
#                 M3ro20j1                    #
#                                             #
#      GitHub: https://github.com/M3ro20j1    #
#                                             #
#             (C) 2024 M3ro20j1               #
#     Licensed under GNU General Public       #
#            License v3.0 or later            #
#                                             #
###############################################

# Variables
SCRIPT_URL="https://raw.githubusercontent.com/M3ro20j1/kaliqtor/main/kaliqtor.sh"
SCRIPT_NAME="kaliqtor.sh"
USER_DIR="$HOME/.local/bin"
ZPROFILE="$HOME/.zprofile"

# Create the directory if it doesn't exist
mkdir -p $USER_DIR

# Download the script
curl -o $USER_DIR/$SCRIPT_NAME $SCRIPT_URL

# Make the script executable
chmod +x $USER_DIR/$SCRIPT_NAME

# Add the directory to PATH if not already present
if [[ ":$PATH:" != *":$USER_DIR:"* ]]; then
  sudo sh -c "echo 'export PATH=\$PATH:$USER_DIR' >> $ZPROFILE"
  export PATH=$PATH:$USER_DIR
  echo "Added $USER_DIR to PATH. Please restart your terminal or run 'source $ZPROFILE' to update your PATH."
else
  echo "$USER_DIR is already in PATH."
fi

# Source the .zprofile to apply changes
source $ZPROFILE
echo "Script downloaded and made executable at $USER_DIR/$SCRIPT_NAME. The PATH has been updated."
