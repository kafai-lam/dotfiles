# Fai's Dotfiles

These are my personal dotfiles for macOS, managed by [chezmoi](https://chezmoi.io). They are highly opinionated and tailored to my workflow as a developer.

## 🚨 Caveat: macOS Only 🚨

These dotfiles are designed exclusively for **macOS**. They are not tested on Linux or Windows and will likely not work correctly on those platforms.

## Installation

To use these dotfiles, you'll need `git` and `curl` installed. Then, run the following command:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply kafai-lam -b $HOME/.local/bin
```

This command will:

1. Download and install `chezmoi` to `$HOME/.local/bin`.
2. Initialize `chezmoi` with this repository.
3. Apply the dotfiles to your home directory.

## Updating Dotfiles

To keep the dotfiles in this repository synchronized with the local machine's configuration, use the following commands:

- `chezmoi add <file>`: Add a new file to be managed by chezmoi.
- `chezmoi re-add`: Re-add files to capture their latest changes.
- `brew-dump`: Update the `Brewfile` with the latest installed packages.
- `chezmoi apply`: Apply the changes from the repository to the local machine.
- `chezmoi update`: Pull the latest changes from the remote repository and apply them.

## Automated Setup

After the initial setup, `chezmoi` will automatically run a series of scripts to configure the system. This includes:

- **Homebrew**: Installs a wide range of command-line tools and GUI applications listed in the `Brewfile`.
- **mise**: Installs and configures specific versions of programming languages and tools like Node.js, Python, and Rust.

## ✨ Highlights ✨

This setup is built around a few key tools that provide a modern and efficient command-line experience.

### [chezmoi](https://chezmoi.io)

`chezmoi` is the backbone of this setup, allowing for easy management and version control of dotfiles across different machines.

### [zsh4humans](https://github.com/romkatv/zsh4humans)

Provides a fast, sensible, and pre-configured Zsh environment. It offers a great out-of-the-box experience with smart defaults for completions, history, and more, while still being highly customizable.

### [Homebrew](https://brew.sh)

All essential command-line tools and desktop applications are managed via a `Brewfile`. This makes setting up a new machine a breeze. Simply run `brew bundle install --global` to install everything.

### [mise](https://mise.jdx.dev/)

Forget `nvm`, `pyenv`, or `asdf`. `mise` is a next-generation, polyglot version manager that can handle them all. It's used here to manage versions for Node.js, Python, Rust, and other development tools, configured via a single `.toml` file.

### [AstroNvim](https://docs.astronvim.com/)

The Neovim configuration is based on AstroNvim, a modern and elegant Neovim configuration featuring a beautiful UI and a set of carefully curated plugins. It provides a feature-rich, IDE-like experience that is both extensible and fast.
