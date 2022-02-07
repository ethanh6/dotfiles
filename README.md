# dotfiles

## Configs
1. neovim (nvim) -> extensible vim alternative
2. vim
3. git
4. bash

## symlink structure
- `~/.bashrc -> ~/dotfiles/bash/.bashrc`
- `~/.gitconfig -> ~/dotfiles/git/.gitconfig`
- `~/.config/nvim -> ~/dotfiles/.config/nvim` (symlink to directory)
- `~/.vim -> ~/dotfiles/vim/.vim` (symlink to directory)
- `~/.vimrc -> ~/dotfiles/vim/.vimrc`

## To create symlink
`ln` command with `-s` (symbolic)

```
    $ ln -s <path to file/folder> <path to link>
```


or use `stow` (gnu dotfile manager)

```
    $ git clone https://github.com/ethanh6/dotfiles.git
    $ cd ~/dotfiles
    $ stow --dir=~/dotfiles --target=~/
```

## To remove symlink

```
    $ unlink <path to link> 
```
note: do not include `/` at the end even if it's a dir since linux will assume it's a dir and `unlink` can't delete a dir.

## Todo
[ ] Create installation script
[ ] Migrate to zsh / oh-my-zsh (?)
[ ] Configure Tmux
