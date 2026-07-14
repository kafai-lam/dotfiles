# AGENTS.md

Personal macOS dotfiles managed with `chezmoi`.

## Source-first workflow

- Edit managed dotfiles in the chezmoi source state under `home/`, not directly in `$HOME`.
- Treat applying source changes as a separate step and tell the user when it remains necessary.
- Run mutating system or environment operations only on explicit request, including chezmoi application or updates, setup scripts, Homebrew, Docker, and mutating `mise` tasks.

## Public guidance

- Update `README.md` if public facing behavoiur changes
- Follow `docs/agents/git-commit-conventions.md` when creating a Git commit.
