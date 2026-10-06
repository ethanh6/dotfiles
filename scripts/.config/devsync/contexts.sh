# devsync contexts — the (root|org|author) triples that synx, sync-tmux-sessions
# and the zsh cd() shortcuts iterate over. Sourced (not executed) by those
# tools; plain array syntax works in both bash and zsh.
#
#   root   — directory holding the repo clones (worktrees live in <root>/worktrees)
#   org    — GitHub owner/org for `gh pr list --repo <org>/<repo>`
#   author — GitHub username for `gh pr list --author`
#
# Personal/extra contexts go in an untracked ~/.config/devsync/contexts.local.sh
# (gitignored, not stowed) that APPENDS to the array, e.g.:
#   DEVSYNC_CONTEXTS+=( "$HOME/src|ethanh6|ethanh6" )

DEVSYNC_CONTEXTS=(
	"$HOME/replit|replit|ethanhyi"
)
