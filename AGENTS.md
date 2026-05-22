# Agent Instructions

This is a personal macOS dotfiles repository managed by `chezmoi`.

## Repository Model

- `.chezmoiroot` contains `home`, so `home/` is the chezmoi source state.
- Files under `home/` map into `$HOME` through chezmoi naming rules.
- Root-level files such as `README.md`, `AGENTS.md`, and `mise.toml` are repo
  documentation/tooling and are not applied into `$HOME`.
- Editing this repository does not update live files in `$HOME` until
  `chezmoi apply` runs.

Common mappings examples:

| Source path | Applied target |
| --- | --- |
| `home/dot_zshenv` | `~/.zshenv` |
| `home/dot_config/zsh/dot_zshrc` | `~/.config/zsh/.zshrc` |
| `home/private_Library/...` | `~/Library/...` with private permissions |
| `home/dot_local/bin/executable_imgcat` | `~/.local/bin/imgcat` with executable permissions |
| `home/.chezmoiscripts/run_after_*.sh` | scripts run by chezmoi during apply/update |
| `home/.chezmoiexternal.toml` | external resources managed by chezmoi |

## Working Rules

- Start by checking `git status --short`; preserve unrelated user changes.
- Prefer source-first edits under `home/` when changing managed dotfiles.
- Use `chezmoi status`, `chezmoi diff`, and
  `chezmoi apply --dry-run --verbose` to inspect effects.
- Do not run `chezmoi apply`, `chezmoi update`, setup scripts, Homebrew, Docker,
  or mutating `mise` tasks unless the user explicitly asks for that action.
- Do not add plaintext tokens, passwords, private keys, API keys, or
  machine-specific secrets unless explicitly instructed.

## Development Notes

- Keep docs public-safe: explain workflows and categories without exposing
  sensitive local values.
- Use concise Markdown and prefer commands that work from the repository root.
- For README changes, keep human setup and maintenance guidance there.
- For agent-specific behavior and safety rules, keep guidance in this file.
- If a change should affect the live home directory, say clearly that applying
  with chezmoi is a separate step.

## Validation

For managed dotfile changes under `home/`, inspect:

```sh
chezmoi status
chezmoi diff
chezmoi apply --dry-run --verbose
```

Only run real apply/update/package-manager commands after explicit user intent.
