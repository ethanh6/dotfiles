# Tmux + Neovim Integration Setup

This configuration uses `vim-tmux-navigator` for seamless navigation between tmux panes and Neovim windows.

## Tmux Configuration Required

Add the following to your `~/.tmux.conf` file:

```bash
# Smart pane switching with awareness of Vim splits.
# See: https://github.com/christoomey/vim-tmux-navigator
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R
bind-key -T copy-mode-vi 'C-\' select-pane -l
```

## Reload Tmux Configuration

After adding the configuration, reload tmux:

```bash
tmux source-file ~/.tmux.conf
```

Or press `prefix` + `r` if you have a reload binding.

## Usage

Once configured, you can navigate seamlessly between tmux panes and Neovim windows using:

- `Ctrl-h` - Move left
- `Ctrl-j` - Move down
- `Ctrl-k` - Move up
- `Ctrl-l` - Move right
- `Ctrl-\` - Move to previous pane/window

The plugin automatically detects whether you're at a Neovim window edge or a tmux pane edge and navigates accordingly.

## Troubleshooting

### Navigation not working in tmux

1. Verify tmux configuration is loaded: `tmux show-options -g | grep vim`
2. Check tmux version: `tmux -V` (should be >= 2.0)
3. Restart tmux session completely

### Ctrl-l clears screen instead of navigating

The `Ctrl-l` mapping overrides the default terminal clear screen command. If you need to clear the screen:
- Use `:!clear` in Neovim
- Use `prefix` + `l` in tmux (move to last window)
- Add a custom mapping like `<leader>cl` for clearing

## Alternative: Without Tmux

If you're not using tmux, the basic window navigation keymaps are commented out in `lua/config/keymaps.lua`. You can uncomment them to restore standard Neovim window navigation.
