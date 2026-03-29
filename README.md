# tkmux

Lua-powered tmux statusline + window status plugin with themes and tmux option overrides.

## Requirements

- tmux 3.x
- Lua (5.3+ recommended)
- Optional: `playerctl` for now-playing segment

## Install (TPM)

Add the plugin and options to `~/.tmux.conf`:

```tmux
set -g @plugin 'tknightz/tkmux'
set -g @tkmux_theme 'default'

run '~/.tmux/plugins/tpm/tpm'
```

Then reload tmux and install plugins:

```bash
# Press prefix + I (capital i) to install plugins via TPM
# Or reload config:
tmux source-file ~/.tmux.conf
```

The plugin automatically configures `status-left`, `status-right`, and window status formats.

## Install (local / dev)

Clone into your repo and point tmux to the scripts:

```tmux
set -g status-left "#(lua ~/Repos/tkmux/scripts/run.lua status-left)"
set -g status-right "#(lua ~/Repos/tkmux/scripts/run.lua status-right)"

# Optional: window status
set -g window-status-current-format "#(lua ~/Repos/tkmux/scripts/run.lua window-active)"
set -g window-status-format "#(lua ~/Repos/tkmux/scripts/run.lua window-common)"
```

## Themes

Available themes are in `lua/themes/`:

- `default`
- `tokyo_night`
- `minimal`

Select theme:

```tmux
set -g @tkmux_theme "default"
```

## Quick overrides (tmux options)

All options are read from tmux and override Lua defaults.

### Theme colors

```tmux
set -g @tkmux_color_bg "#000000"
set -g @tkmux_color_accent "#ff00ff"
```

### Separators

```tmux
set -g @tkmux_sep_left ""
set -g @tkmux_sep_right ""
set -g @tkmux_sep_right_in ""
```

### Segment styles

Each segment supports `@tkmux_<segment>_icon`, `_fg`, `_bg`, `_fg_high`, `_fg_medium`, `_fg_default` (where applicable).

Examples:

```tmux
set -g @tkmux_cpu_fg "accent"
set -g @tkmux_cpu_fg_high "red"
set -g @tkmux_cpu_fg_medium "orange"
set -g @tkmux_ram_fg "accent"
set -g @tkmux_user_bg "red"
```

### Behavior

```tmux
set -g @tkmux_right_skip_empty true
set -g @tkmux_playing_max_len 30
set -g @tkmux_cpu_high 80
set -g @tkmux_cpu_medium 40
set -g @tkmux_ram_high 16
set -g @tkmux_ram_medium 12
```

### Segment ordering

```tmux
set -g @tkmux_sections_left "session,uptime"
set -g @tkmux_sections_right "playing_info,cpu,ram,date,user"
```

### Per-segment enable

```tmux
set -g @tkmux_cpu_enabled true
set -g @tkmux_playing_info_enabled false
set -g @tkmux_window_enabled true
```

## Advanced config (optional)

Create a Lua file named `tkmux_user.lua` in your Lua `package.path`, for example:

```lua
-- ~/.config/tkmux_user.lua
return {
  options = { right_skip_empty = true },
  styles = {
    cpu = { fg = "accent", bg = "bg" },
  },
}
```

This is merged after defaults and before tmux `@tkmux_*` overrides.

## Segment list

Defaults:

- Left: `session`, `uptime`
- Right: `playing_info`, `cpu`, `ram`, `date`, `user`

Window formats:

- Active: `window_active`
- Common: `window`

## Troubleshooting

- If `playerctl` is missing, the now-playing segment renders empty and is skipped.
- Ensure `lua` is on PATH for tmux.
- Check `@tkmux_*` values via `tmux show-option -g`.
