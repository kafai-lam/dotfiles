# Paneru to Aerospace Key Binding Mapping

This document shows how the paneru configuration has been updated to follow similar key binding patterns as aerospace.

## Core Navigation

| Function | Aerospace | Paneru |
|----------|-----------|--------|
| Focus left | `alt-h` | `alt - h` |
| Focus right | `alt-l` | `alt - l` |
| Focus down | `alt-j` | `alt - j` |
| Focus up | `alt-k` | `alt - k` |

## Window Movement

| Function | Aerospace | Paneru |
|----------|-----------|--------|
| Move left | `alt-shift-h` | `alt + shift - h` |
| Move right | `alt-shift-l` | `alt + shift - l` |
| Move down | `alt-shift-j` | `alt + shift - j` |
| Move up | `alt-shift-k` | `alt + shift - k` |

## Window Resizing

| Function | Aerospace | Paneru |
|----------|-----------|--------|
| Resize smaller | `alt-shift-minus` | `alt + shift - minus` |
| Resize larger | `alt-shift-equal` | `alt + shift - equal` |

## Workspace Management

| Function | Aerospace | Paneru |
|----------|-----------|--------|
| Workspace 1-9 | `alt-1` to `alt-9` | `window_virtualnum_1` to `window_virtualnum_9` |
| Move to workspace 1-9 | `alt-shift-1` to `alt-shift-9` | `window_virtualmovenum_1` to `window_virtualmovenum_9` |
| Toggle workspace | `alt-tab` | `window_virtual_north` |
| Move workspace | `alt-shift-tab` | `window_virtualmove_north` |

## Additional Paneru Features

| Function | Paneru Binding |
|----------|----------------|
| Window center | `alt - c` |
| Window manage (toggle float) | `alt - f` |
| Window fullwidth | `alt - w` |
| Window stack | `alt - s` |
| Window unstack | `alt + shift - s` |
| Window equalize | `alt - e` |
| Next display | `alt - n` |
| Mouse to next display | `alt + shift - n` |
| Quit | `ctrl + alt - q` |

## Key Differences

1. **Terminology**: Paneru uses "virtual workspaces" instead of "workspaces"
2. **Window swapping**: Paneru uses `window_swap_*` instead of `move *`
3. **Virtual workspace navigation**: Paneru uses north/south terminology for virtual workspace switching
4. **Additional features**: Paneru has window stacking/unstacking and equalization features

The configuration maintains the same modifier key patterns (alt for navigation, alt+shift for movement) to provide a consistent muscle memory experience between the two window managers.