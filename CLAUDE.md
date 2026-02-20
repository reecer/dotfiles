# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal dotfiles for a NixOS system ("nixpad"), managed with GNU Stow. Configs are symlinked from this repo into `$HOME`.

## Deployment

```bash
# Symlink dotfiles into home directory (from repo root)
stow .

# Apply NixOS system configuration changes
sudo nixos-rebuild switch

# configuration.nix is a symlink to /etc/nixos/configuration.nix
```

The `wallpapers/` directory is excluded from stow via `.stow-local-ignore`.

## Architecture

- **Window Manager:** Niri (Wayland compositor) — `.config/niri/config.kdl`
- **Terminal:** Alacritty — `.config/alacritty/alacritty.toml`
- **Multiplexer:** Zellij (default mode: locked, `Ctrl+Space` to unlock) — `.config/zellij/config.kdl`
- **Editor:** Neovim with AstroNvim v4 framework — `.config/nvim/`
- **Status Bar:** Waybar — `.config/waybar/`
- **App Launcher:** Fuzzel — `.config/fuzzel/`
- **Shell:** Zsh with pure prompt, atuin history, vi mode — `.zshrc`
- **System:** NixOS config — `configuration.nix` (symlink to `/etc/nixos/configuration.nix`)

## Conventions

- **Theme:** Catppuccin colorscheme throughout (fuzzel, neovim, waybar)
- **Keybindings:** Vim-style (hjkl) navigation everywhere — niri, zellij, zsh vi mode
- **Config format:** KDL for niri and zellij, TOML for alacritty, Lua for neovim
- **Neovim plugins:** Managed via lazy.nvim; add new plugins as files in `.config/nvim/lua/plugins/`
