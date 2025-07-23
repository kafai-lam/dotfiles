if (( ! $+commands[orbctl] )); then
  return
fi

# OrbStack provides completions for commands: docker, _kubectl, _orb, _orbctl
fpath+=(
  /Applications/OrbStack.app/Contents/MacOS/../Resources/completions/zsh
)
