# Dotfiles

Personal configuration files managed with Nix, NixOS, and Home Manager. Supports both Linux (NixOS with Niri compositor) and macOS environments.

## Features

- **Declarative configuration** using Nix flakes
- **Cross-platform support** for Linux (NixOS) and macOS
- **Niri compositor** - A scrollable tiling Wayland compositor
- **Home Manager** for user-level package and dotfile management
- **AstroNvim** configuration with custom plugins

## Quick Start

### Prerequisites

- Nix with flakes enabled
- Home Manager (for user configurations)
- NixOS (for system configurations on Linux)

### Installation

#### Home Manager Configuration

```bash
cd home-manager
home-manager switch --flake .#reece
```

#### NixOS System Configuration (Linux only)

```bash
cd nixos
sudo nixos-rebuild switch --flake .#nixos
```

## Repository Structure

```
.
├── home-manager/       # User-level configuration
│   ├── flake.nix      # Home Manager flake entry point
│   └── home.nix       # Main user configuration
├── nixos/             # System-level NixOS configuration
│   ├── flake.nix      # NixOS flake with niri integration
│   └── configuration.nix
├── niri/              # Niri compositor configuration
│   └── config.kdl     # Keybindings and window management
├── nvim/              # Neovim configuration (AstroNvim v4+)
├── alacritty/         # Terminal emulator configuration
├── waybar/            # Status bar configuration
└── zsh/               # Shell configuration
```

## Key Features by Platform

### Linux (NixOS)

- **Window Manager**: Niri (Wayland compositor)
- **Terminal**: Alacritty
- **App Launcher**: Fuzzel
- **Status Bar**: Waybar
- **Container Runtime**: Podman (Docker-compatible)
- **Clipboard Manager**: Cliphist

### macOS

- Home Manager runs standalone
- Platform-specific packages automatically configured
- Native macOS integration where applicable

## Keyboard Shortcuts

### Niri Window Management

Using vim-inspired navigation (adapted for Colemak layout):

| Action | Keybinding |
|--------|------------|
| **Window Focus** | |
| Focus left | `Ctrl+Alt+H` |
| Focus down | `Ctrl+Alt+N` |
| Focus up | `Ctrl+Alt+I` |
| Focus right | `Ctrl+Alt+L` |
| **Window Movement** | |
| Move left | `Ctrl+Shift+Alt+H` |
| Move down | `Ctrl+Shift+Alt+N` |
| Move up | `Ctrl+Shift+Alt+I` |
| Move right | `Ctrl+Shift+Alt+L` |
| **Workspaces** | |
| Previous workspace | `Ctrl+Alt+J` |
| Next workspace | `Ctrl+Alt+K` |
| **Applications** | |
| Terminal | `Mod+T` or `Ctrl+Alt+T` |
| Launcher | `Mod+D` or `Ctrl+Alt+Space` |
| Clipboard history | `Alt+Shift+C` |
| Close window | `Mod+Q` |

## Shell Configuration

ZSH with:
- Vi mode for command line editing
- Syntax highlighting and autosuggestions
- Pure prompt theme
- Custom aliases:
  - `doy` - Display day of year
  - `gpsweek` - Display GPS week number
  - `d` - Devbox alias
  - `ds` - Devbox shell alias

## Updating

Update all flake inputs:

```bash
nix flake update
```

Check flake configuration:

```bash
nix flake check
```


## Acknowledgments

Built with:
- [Nix](https://nixos.org/)
- [Home Manager](https://github.com/nix-community/home-manager)
- [Niri](https://github.com/YaLTeR/niri)
- [AstroNvim](https://astronvim.com/)
