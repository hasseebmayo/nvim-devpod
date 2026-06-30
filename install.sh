#!/usr/bin/env bash
set -e

mkdir -p ~/.config
rm -f ~/.config/nvim
ln -s "$PWD" ~/.config/nvim

# Install clipboard utility (fallback for non-OSC52 cases)
sudo apt-get update -y
sudo apt-get install -y xclip wl-clipboard

# Add OSC52 clipboard config to options.lua if not already present
OPTIONS_FILE="lua/config/options.lua"
if [ -f "$OPTIONS_FILE" ] && ! grep -q "osc52" "$OPTIONS_FILE"; then
  cat >>"$OPTIONS_FILE" <<'EOF'

-- OSC 52 clipboard: yank inside container syncs to host clipboard via terminal escape codes
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}
EOF
  echo "Appended OSC52 clipboard config to $OPTIONS_FILE"
else
  echo "OSC52 config already present or $OPTIONS_FILE not found, skipping"
fi
