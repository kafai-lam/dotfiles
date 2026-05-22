# Dotfiles

Personal macOS dotfiles managed by [chezmoi](https://chezmoi.io). This repo is
opinionated and tuned for my development workflow.

## 🚨 macOS Only

These dotfiles are designed for macOS. They are not tested on Linux or Windows.

## Installation

You need `git` and `curl`. On a new machine, run:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply kafai-lam -b $HOME/.local/bin
```

This installs `chezmoi` to `$HOME/.local/bin`, initializes this repository, and
applies the managed files into your home directory.

## Updating Dotfiles

For normal source-first changes:

1. Edit files under `home/`.
2. Preview what would change:

   ```sh
   chezmoi status
   chezmoi diff
   chezmoi apply --dry-run --verbose
   ```

3. Apply when you are ready:

   ```sh
   chezmoi apply
   ```

Important: editing a file under this repository changes the source state only.
The live file in `$HOME` does not change until `chezmoi apply` runs.

For target-first changes, edit files directly in `$HOME`, then capture them
back into the source state:

```sh
chezmoi add ~/.config/example/config.toml
chezmoi re-add
```

To pull the latest repo changes and apply them:

```sh
chezmoi update
```

## Local Helpers

These helpers are conveniences layered on top of the core chezmoi workflow:

- `brew-dump`: regenerates `$XDG_CONFIG_HOME/homebrew/Brewfile` from installed
  Homebrew packages, excluding entries listed in `Brewfile.local` when present.
- `chup`: shell alias for `chezmoi update`.
- Raycast `dotfiles_update`: runs the local update flow from Raycast.

## Automated Setup

Applying or updating these dotfiles can run scripts from `home/.chezmoiscripts/`.
At a high level, they configure:

- macOS architecture checks and defaults.
- Homebrew setup, package installation, and cask upgrades.
- `mise` tool installation and upgrades.
- shell completions.
- default app associations with `duti`.
- yazi plugins.

Review `home/.chezmoiscripts/` before running `chezmoi apply` on a new or
important machine.

## Maintenance Tasks

The root `mise.toml` pins `chezmoi` and defines maintenance tasks:

```sh
mise install
mise run bump
mise run bump:gh
mise run bump:docker
```

- `mise install` installs the tools declared in `mise.toml`.
- `mise run bump` runs all bump tasks.
- `mise run bump:gh` upgrades GitHub CLI extensions.
- `mise run bump:docker` starts OrbStack and rebuilds/recreates local Docker
  services from `~/.config/services/compose.yaml`.

These tasks mutate local tools or services. Review them before running.

## Highlights

- [chezmoi](https://chezmoi.io): dotfile source/target management.
- [Homebrew](https://brew.sh): command-line tools and desktop apps via a
  Brewfile.
- [mise](https://mise.jdx.dev/): language and developer-tool version management.
- [AstroNvim](https://docs.astronvim.com/): Neovim configuration base.
