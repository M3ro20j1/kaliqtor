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
SCRIPT_NAME="kaliqtor.sh"
USER_DIR="$HOME/.local/bin"
SCRIPT_PATH="$USER_DIR/$SCRIPT_NAME"
ZPROFILE="$HOME/.zprofile"

# Check if the script exists and remove it
if [[ -f $SCRIPT_PATH ]]; then
  rm $SCRIPT_PATH
  echo "Removed $SCRIPT_PATH"
else
  echo "Script $SCRIPT_PATH does not exist."
fi

# Check if the directory is empty and remove it if so
if [[ -d $USER_DIR ]] && [[ -z $(ls -A $USER_DIR) ]]; then
  rmdir $USER_DIR
  echo "Removed empty directory $USER_DIR"
fi

# Remove the directory from PATH in .zprofile if present
if grep -q "$USER_DIR" $ZPROFILE; then
  sudo sed -i "/export PATH=\\\$PATH:$USER_DIR/d" $ZPROFILE
  echo "Removed $USER_DIR from PATH in $ZPROFILE"
  echo "Please restart your terminal or run 'source $ZPROFILE' to update your PATH."
else
  echo "$USER_DIR was not found in PATH."
fi

# Source the .zprofile to apply changes
source $ZPROFILE
echo "The PATH has been updated."
