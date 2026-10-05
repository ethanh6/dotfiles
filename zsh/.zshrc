# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# ZSH_THEME="agnoster"
# p10k is sourced directly from Homebrew below, not via OMZ's theme loader
ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


# command line information on the left on the left side of the prompt
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user dir dir_writable vcs) 

# command line information on the right side of the prompt
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs ram)  

POWERLEVEL9K_MODE='nerdfont-complete'  




if [ -n "${HOMEBREW_PREFIX:-}" ] && [ -f "${HOMEBREW_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme" ]; then
  source "${HOMEBREW_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme"
elif [ -f /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ]; then
  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
elif [ -f /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme ]; then
  source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# append path to tlmgr
path+=('/Library/TeX/texbin')
path+=('/usr/texbin')
export path

# set -o vi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

worktree() {
  if [[ -z "$1" ]]; then
    echo "Usage: worktree <remote_branch_name>"
    return 1
  fi

  # Ensure we're in the main repo and on the main branch
  git rev-parse --is-inside-work-tree >/dev/null || { echo "Not inside a git repository"; return 1; }

  # Critical safety check: abort if there are uncommitted changes or staged files
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Error: Your current working tree or staging area has uncommitted changes."
    echo "Please commit, stash, or discard them before running this function."
    git status --short
    return 1
  fi

  # Find the main repository root (where .git is a directory, not a file)
  local main_worktree_path=$(dirname $(git rev-parse --path-format=absolute --git-common-dir) )
  local repo_name=$(basename "${main_worktree_path}")
  local main_branch="main"
  local worktrees_dir="${main_worktree_path}/../${repo_name}-worktrees"
  local branch_name="$1"
  local sanitized_branch_name=$(echo "${branch_name}" | sed 's/[\/:]/-/g' | cut -c1-50)
  local worktree_path="${worktrees_dir}/${sanitized_branch_name}"

  # Switch to the main worktree to update it
  echo "Switching to ${main_branch} and updating..."
  pushd "${main_worktree_path}" >/dev/null || { echo "Cannot access main repo directory"; return 1; }
  git checkout "${main_branch}" >/dev/null 2>&1 || { echo "Failed to checkout $main_branch"; popd; return 1; }
  git pull --rebase || { echo "Failed to update $main_branch"; popd; return 1; }

  echo "Fetching latest branches..."
  git fetch || { echo "git fetch failed"; popd; return 1; }

  # Checkout or create the local branch tracking the remote one
  if git show-ref --verify --quiet refs/heads/"$branch_name"; then
    echo "Switching to existing local branch $branch_name..."
    git switch "$branch_name" >/dev/null 2>&1
  else
    echo "Creating local branch $branch_name from origin/$branch_name..."
    git switch -c "$branch_name" "origin/$branch_name" || {
      echo "Remote branch origin/$branch_name not found."
      popd
      return 1
    }
  fi
  git switch "${main_branch}"

  # Create the worktree (from the main repo)
  echo "Creating worktree at ${worktree_path}..."
  git worktree add "${worktree_path}" "${branch_name}" # >/dev/null 2>&1 || echo "Something wrong in \"git worktree add\""

  # Return to original directory
  # popd >/dev/null

  # Prompt for tmux session name (suggest safe branch name)
  session_name=${session_name:-$sanitized_branch_name}

  if [[ -z "$session_name" ]]; then
    echo "Session name cannot be empty"
    return 1
  fi

  # Create and attach to new tmux session
  if tmux has-session -t "$session_name" 2>/dev/null; then
    echo "Tmux session '$session_name' already exists. Attaching..."
  else
    echo "Creating new tmux session '$session_name'..."
    tmux new-session -d -s "$session_name" -c "$worktree_path"
  fi

  echo "Worktree and tmux session created."
}

# `cd <repo>` always goes to the main clone ~/replit/<repo>, from anywhere —
# even when a relative dir of the same name exists. `cd <branch>` jumps to
# the matching PR worktree (created by sync-worktrees.sh) under
# ~/replit/worktrees/<repo>/<branch> when the normal cd fails. Slashes in
# branch names are also tried flattened to dashes, since that's how
# sync-worktrees.sh names worktree dirs. Ambiguous names (same branch in
# several repos) list the candidates; disambiguate with `cd <repo>/<branch>`.
cd() {
  # `cd replit` from anywhere goes to ~/replit itself, same as the repo
  # shortcuts below.
  if (( $# == 1 )) && [[ "$1" == replit ]]; then
    builtin cd "$HOME/replit" && echo "$HOME/replit"
    return
  fi

  # Exact repo name (a dir under ~/replit with .git) wins over everything,
  # so `cd repl-it-web` lands on the main clone regardless of cwd.
  if (( $# == 1 )) && [[ "$1" != */* && -e "$HOME/replit/$1/.git" ]]; then
    builtin cd "$HOME/replit/$1" && echo "$HOME/replit/$1"
    return
  fi

  builtin cd "$@" 2>/dev/null && return

  # Fall back only for a single non-option argument; anything else re-runs
  # the builtin to surface its original error.
  if (( $# != 1 )) || [[ "$1" == -* ]]; then
    builtin cd "$@"
    return
  fi

  local root="$HOME/replit/worktrees"
  local -aU matches
  matches=(
    "$root"/*/"$1"(N/)          # branch under any repo
    "$root"/*/"${1//\//-}"(N/)  # branch with slashes flattened to dashes
    "$root"/"$1"(N/)            # explicit repo/branch
    "$root"/"${1//\//-}"(N/)
  )

  if (( ${#matches} == 1 )); then
    builtin cd "${matches[1]}" && echo "${matches[1]}"
  elif (( ${#matches} > 1 )); then
    print -u2 "cd: '$1' matches multiple worktrees:"
    printf '  %s\n' "${matches[@]#$root/}" >&2
    print -u2 "disambiguate with: cd <repo>/<branch>"
    return 1
  else
    builtin cd "$@"
  fi
}

# opencode
export PATH=/Users/ethanhuang/.opencode/bin:$PATH

# local scripts stowed from dotfiles/scripts (e.g. sync-tmux-sessions)
export PATH="$HOME/.local/bin:$PATH"

# Aliases
# macawake/macsleep skip the sudo password prompt thanks to a sudoers drop-in.
# To set it up on a new machine, run (once):
#   echo 'ethanhuang ALL=(ALL) NOPASSWD: /usr/bin/pmset -a disablesleep 0, /usr/bin/pmset -a disablesleep 1' \
#     | sudo tee /etc/sudoers.d/pmset-disablesleep > /dev/null \
#     && sudo chmod 440 /etc/sudoers.d/pmset-disablesleep \
#     && sudo visudo -cf /etc/sudoers.d/pmset-disablesleep
# To undo: sudo rm /etc/sudoers.d/pmset-disablesleep
alias macawake="sudo pmset -a disablesleep 1 && echo 'Lid sleep disabled. Mac will stay awake.'"
alias macsleep="sudo pmset -a disablesleep 0 && echo 'Lid sleep enabled. Mac will sleep when closed.'"

# direnv (needed for Nix flake devshells, e.g. repl-it-web)
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi
