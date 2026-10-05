#!/bin/bash
#
# alfred-sync.sh: two-way sync between Alfred's preferences and ~/AlfredSync,
# a normal folder that Claude can open. Works with free Alfred (no Powerpack).
#
#   ~/alfred-sync.sh install     first sync, then keep syncing every 30 s in the background
#   ~/alfred-sync.sh sync        sync once, now
#   ~/alfred-sync.sh status      paths, last sync, background job, conflicts, recent activity
#   ~/alfred-sync.sh uninstall   stop the background job (all files are left in place)
#
# How each file is resolved:
#   changed on one side only             -> copied to the other side (deletions too)
#   changed on both sides, same content  -> nothing to do
#   changed on both sides, different     -> Alfred's version wins; the ~/AlfredSync version
#                                           is kept in ~/AlfredSync/_conflicts/<time>/
#
# Safety nets:
#   - Full backup of Alfred's preferences on first sync:  ~/.alfred-sync/backups/
#   - Any file in Alfred's own folder that gets overwritten or deleted by a sync is
#     copied first to ~/.alfred-sync/trash/<time>/ (kept 14 days).
#
# Keep MIRROR_DIR outside Documents/Desktop/Downloads/iCloud Drive: macOS blocks
# background jobs from those folders unless you grant extra permissions.

MIRROR_DIR="$HOME/AlfredSync"
INTERVAL=30

# ------------------------------------------------------------------------- setup
PATH=/usr/bin:/bin:/usr/sbin:/sbin:$PATH
set -u

LABEL="local.alfred-sync"
SUPPORT_DIR="$HOME/Library/Application Support/Alfred"
BUNDLE="Alfred.alfredpreferences"
MIRROR="$MIRROR_DIR/$BUNDLE"
CONFLICT_DIR="$MIRROR_DIR/_conflicts"
STATE_DIR="$HOME/.alfred-sync"
STATE="$STATE_DIR/state.tsv"
LIVE_FILE="$STATE_DIR/live_path"
LAST_FILE="$STATE_DIR/last_sync"
LOG="$STATE_DIR/sync.log"
TRASH_DIR="$STATE_DIR/trash"
BACKUP_DIR="$STATE_DIR/backups"
LOCK="$STATE_DIR/lock"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
RUN_TS="$(date '+%Y%m%d-%H%M%S')"
TAB="$(printf '\t')"
NL='
'
VERBOSE=0; [ -t 1 ] && VERBOSE=1
SELF="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
LIVE=""
TOUCHED=""
CHANGES=0
CONFLICTS=0

usage() {
  cat <<EOF
Two-way sync between Alfred's preferences and $MIRROR_DIR

  $0 install     first sync, then keep syncing every ${INTERVAL}s in the background
  $0 sync        sync once, now
  $0 status      show paths, last sync, background job and recent activity
  $0 uninstall   stop the background job (files are left in place)
EOF
}

log() {
  printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "$LOG"
  [ "$VERBOSE" = 1 ] && printf '  %s\n' "$*"
  return 0
}

# Where Alfred keeps its preferences right now. Alfred 4+ records it in prefs.json
# ("current"); without prefs.json it's the default spot in Application Support.
live_bundle() {
  local p="" pj="$SUPPORT_DIR/prefs.json"
  if [ -f "$pj" ]; then
    p="$(/usr/bin/plutil -extract current raw -o - "$pj" 2>/dev/null)" || p=""
    if [ -z "$p" ]; then
      p="$(sed -n 's/.*"current"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$pj" 2>/dev/null \
            | head -n 1 | sed 's#\\/#/#g')"
    fi
  fi
  [ -z "$p" ] && p="$SUPPORT_DIR/$BUNDLE"
  case "$p" in "~"/*) p="$HOME/${p#\~/}" ;; esac
  printf '%s' "${p%/}"
}

# File signature = size:mtime:inode:permissions (changes whenever a file is rewritten).
if stat --version >/dev/null 2>&1; then          # GNU stat (Linux)
  stat_lines() { xargs -0 -r stat -c "%n${TAB}%s:%Y:%i:%a" 2>/dev/null; }
  stat_one()   { stat -c '%s:%Y:%i:%a' "$1" 2>/dev/null; }
else                                             # BSD stat (macOS); BSD xargs skips empty input
  stat_lines() { xargs -0 stat -f "%N${TAB}%z:%m:%i:%Lp" 2>/dev/null; }
  stat_one()   { stat -f '%z:%m:%i:%Lp' "$1" 2>/dev/null; }
fi

# scan ROOT OUT -> OUT gets "relative/path<TAB>signature" for every file and symlink.
scan() {
  ( cd "$1" 2>/dev/null && find . \( -type f -o -type l \) \
      ! -name '.DS_Store' ! -name '.alfred-sync-tmp.*' ! -name "*${TAB}*" ! -name "*${NL}*" \
      -print0 | stat_lines ) | sed 's#^\./##' | LC_ALL=C sort > "$2"
}

exists() { [ -e "$1" ] || [ -L "$1" ]; }

# plan STATE LIVE_SCAN MIRROR_SCAN -> one "ACTION<TAB>path" line per file that changed.
plan() {
  awk 'BEGIN { FS = OFS = "\t" }
    $1 == "" { next }
    FILENAME == ARGV[1] { ol[$1] = $2; om[$1] = $3; all[$1] = 1; next }
    FILENAME == ARGV[2] { nl[$1] = $2; all[$1] = 1; next }
    FILENAME == ARGV[3] { nm[$1] = $2; all[$1] = 1; next }
    END {
      for (k in all) {
        l  = (k in nl) ? nl[k] : "";  m  = (k in nm) ? nm[k] : ""
        lo = (k in ol) ? ol[k] : "";  mo = (k in om) ? om[k] : ""
        lc = (l != lo);  mc = (m != mo)
        if (!lc && !mc) continue
        if (lc && !mc)      act = (l == "") ? "DELM" : "L2M"
        else if (mc && !lc) act = (m == "") ? "DELL" : "M2L"
        else                act = "BOTH"
        print act, k
      }
    }' "$1" "$2" "$3"
}

# merge OLD_STATE LIVE_SCAN MIRROR_SCAN TOUCHED -> new state.
# Untouched files keep the signatures seen in this scan; copied files get the fresh
# signature of the side we wrote; failed operations keep their old state so they retry.
merge() {
  awk 'BEGIN { FS = OFS = "\t" }
    $1 == "" { next }
    FILENAME == ARGV[1] { ol[$1] = $2; om[$1] = $3; next }
    FILENAME == ARGV[2] { nl[$1] = $2; all[$1] = 1; next }
    FILENAME == ARGV[3] { nm[$1] = $2; all[$1] = 1; next }
    FILENAME == ARGV[4] { ts[$1] = $2; tv[$1] = $3; all[$1] = 1; next }
    END {
      for (k in all) {
        l = (k in nl) ? nl[k] : "";  m = (k in nm) ? nm[k] : ""
        if (k in ts) {
          if (ts[k] == "D") continue
          if (ts[k] == "X") { if (k in ol) print k, ol[k], om[k]; continue }
          if (ts[k] == "L") l = tv[k]; else m = tv[k]
        }
        if (l != "" && m != "") print k, l, m
      }
    }' "$1" "$2" "$3" "$4"
}

# Copy one file or symlink, atomically for files (temp file + rename).
copy_path() {
  local s="$1" d="$2" dir tmp
  dir="$(dirname "$d")"
  if [ -d "$d" ] && [ ! -L "$d" ]; then return 1; fi    # a folder is in the way
  mkdir -p "$dir" 2>/dev/null || return 1
  if [ -L "$s" ]; then
    rm -f "$d" && ln -s "$(readlink "$s")" "$d"
    return
  fi
  tmp="$dir/.alfred-sync-tmp.$$.$(basename "$d")"
  [ -L "$d" ] && rm -f "$d"
  if cp -p "$s" "$tmp" 2>/dev/null && mv -f "$tmp" "$d"; then return 0; fi
  rm -f "$tmp"
  return 1
}

touched() { printf '%s\t%s\t%s\n' "$1" "$2" "${3:-}" >> "$TOUCHED"; }

apply_copy() {   # SRC_ROOT DST_ROOT REL SIDE_WRITTEN(L|M) DESCRIPTION
  local sig=""
  if copy_path "$1/$3" "$2/$3"; then sig="$(stat_one "$2/$3")"; fi
  if [ -n "$sig" ]; then touched "$3" "$4" "$sig"; log "$5: $3"
  else touched "$3" X; log "FAILED ($5): $3"; fi
}

prune_dirs() {   # ROOT REL_DIR: remove now-empty parent folders
  local root="$1" d="$2"
  while [ "$d" != "." ] && [ "$d" != "/" ] && [ -n "$d" ]; do
    [ "$(ls -A "$root/$d" 2>/dev/null)" = ".DS_Store" ] && rm -f "$root/$d/.DS_Store"
    rmdir "$root/$d" 2>/dev/null || break
    d="$(dirname "$d")"
  done
}

apply_delete() { # ROOT REL DESCRIPTION
  rm -f "$1/$2" 2>/dev/null
  if exists "$1/$2"; then touched "$2" X; log "FAILED ($3): $2"; return; fi
  prune_dirs "$1" "$(dirname "$2")"
  touched "$2" D
  log "$3: $2"
}

save_copy() {    # SRC DEST: keep a copy of a file or symlink somewhere safe
  exists "$1" || return 0
  mkdir -p "$(dirname "$2")" || return 1
  if [ -L "$1" ]; then ln -s "$(readlink "$1")" "$2"; else cp -p "$1" "$2"; fi
}

trash_live() { save_copy "$LIVE/$1" "$TRASH_DIR/$RUN_TS/$1"; }

same_content() {
  if [ -L "$1" ] && [ -L "$2" ]; then [ "$(readlink "$1")" = "$(readlink "$2")" ]; return; fi
  if [ -L "$1" ] || [ -L "$2" ]; then return 1; fi
  cmp -s "$1" "$2"
}

resolve_both() { # file changed on both sides since the last sync
  local rel="$1" l="$LIVE/$1" m="$MIRROR/$1"
  if ! exists "$l" && ! exists "$m"; then return 0; fi           # deleted on both sides
  if exists "$l" && exists "$m" && same_content "$l" "$m"; then return 0; fi
  CONFLICTS=$((CONFLICTS + 1))
  if exists "$m"; then
    save_copy "$m" "$CONFLICT_DIR/$RUN_TS/$rel" && log "CONFLICT, AlfredSync version saved to _conflicts/$RUN_TS/$rel"
  fi
  if exists "$l"; then apply_copy "$LIVE" "$MIRROR" "$rel" M "conflict, kept Alfred's version"
  else apply_delete "$MIRROR" "$rel" "conflict, kept Alfred's deletion"; fi
}

acquire_lock() {
  local pid
  if ! mkdir "$LOCK" 2>/dev/null; then
    pid="$(cat "$LOCK/pid" 2>/dev/null)"
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then return 1; fi
    if [ -z "$pid" ] && [ -z "$(find "$LOCK" -maxdepth 0 -mmin +10 2>/dev/null)" ]; then return 1; fi
    rm -rf "$LOCK"
    mkdir "$LOCK" 2>/dev/null || return 1
  fi
  echo $$ > "$LOCK/pid"
  trap 'rm -rf "$LOCK"' EXIT
}

prune_old() {
  [ -d "$TRASH_DIR" ] && find "$TRASH_DIR" -mindepth 1 -maxdepth 1 -type d -mtime +14 -exec rm -rf {} + 2>/dev/null
  ls -1t "$BACKUP_DIR"/*.tar.gz 2>/dev/null | tail -n +6 | while IFS= read -r f; do rm -f "$f"; done
  if [ -f "$LOG" ] && [ "$(wc -c < "$LOG" | tr -d ' ')" -gt 1000000 ]; then mv -f "$LOG" "$LOG.1"; fi
  return 0
}

notify() {
  [ -x /usr/bin/osascript ] || return 0
  /usr/bin/osascript -e "display notification \"$1\" with title \"Alfred sync\"" >/dev/null 2>&1
  return 0
}

# ------------------------------------------------------------------------- first sync
seed() {
  local tmp="$1" bk keep
  log "First sync: copying Alfred's preferences to $MIRROR"
  mkdir -p "$BACKUP_DIR" "$MIRROR_DIR" || return 1
  bk="$BACKUP_DIR/$BUNDLE-$RUN_TS.tar.gz"
  if ! tar -czf "$bk" -C "$(dirname "$LIVE")" "$(basename "$LIVE")" 2>/dev/null; then
    log "ERROR: couldn't back up $LIVE, nothing was changed"; return 1
  fi
  log "Backup saved: $bk"
  if exists "$MIRROR"; then              # unknown earlier copy: keep it, don't merge blindly
    keep="$CONFLICT_DIR/$RUN_TS-previous-AlfredSync"
    mkdir -p "$CONFLICT_DIR" && mv "$MIRROR" "$keep" && log "Existing copy moved to $keep"
  fi
  scan "$LIVE" "$tmp/live"              # scan before copying so later edits are still noticed
  if [ -x /usr/bin/ditto ]; then /usr/bin/ditto "$LIVE" "$MIRROR"; else cp -pR "$LIVE" "$MIRROR"; fi \
    || { log "ERROR: copy to $MIRROR failed"; return 1; }
  scan "$MIRROR" "$tmp/mirror"
  : > "$tmp/none1"; : > "$tmp/none2"
  merge "$tmp/none1" "$tmp/live" "$tmp/mirror" "$tmp/none2" > "$STATE" || return 1
  printf '%s\n' "$LIVE" > "$LIVE_FILE"
  log "First sync done: $(wc -l < "$STATE" | tr -d ' ') files"
}

# ------------------------------------------------------------------------- commands
cmd_sync() {
  local tmp action rel rc=0
  mkdir -p "$STATE_DIR" || return 1
  if ! acquire_lock; then [ "$VERBOSE" = 1 ] && echo "Another sync is already running."; return 0; fi
  LIVE="$(live_bundle)"
  if [ ! -d "$LIVE" ]; then log "ERROR: Alfred preferences not found at $LIVE"; return 1; fi
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/alfred-sync.XXXXXX")" || return 1

  if [ ! -f "$STATE" ] || [ ! -d "$MIRROR" ] || [ "$(cat "$LIVE_FILE" 2>/dev/null)" != "$LIVE" ]; then
    seed "$tmp"; rc=$?
  else
    TOUCHED="$tmp/touched"; : > "$TOUCHED"
    scan "$LIVE" "$tmp/live"
    scan "$MIRROR" "$tmp/mirror"
    plan "$STATE" "$tmp/live" "$tmp/mirror" > "$tmp/actions"
    while IFS="$TAB" read -r action rel; do
      [ -n "$rel" ] || continue
      CHANGES=$((CHANGES + 1))
      case "$action" in
        L2M)  apply_copy "$LIVE" "$MIRROR" "$rel" M "Alfred -> AlfredSync" ;;
        M2L)  trash_live "$rel"; apply_copy "$MIRROR" "$LIVE" "$rel" L "AlfredSync -> Alfred" ;;
        DELM) apply_delete "$MIRROR" "$rel" "deleted in AlfredSync (was deleted in Alfred)" ;;
        DELL) trash_live "$rel"; apply_delete "$LIVE" "$rel" "deleted in Alfred (was deleted in AlfredSync)" ;;
        BOTH) resolve_both "$rel" ;;
      esac
    done < "$tmp/actions"
    if merge "$STATE" "$tmp/live" "$tmp/mirror" "$TOUCHED" > "$tmp/state"; then
      mv -f "$tmp/state" "$STATE"
    else
      log "ERROR: couldn't save sync state"; rc=1
    fi
    if [ "$CONFLICTS" -gt 0 ]; then
      notify "$CONFLICTS file(s) changed on both sides. Kept Alfred's version; the other is in AlfredSync/_conflicts."
    fi
    [ "$VERBOSE" = 1 ] && [ "$CHANGES" -eq 0 ] && echo "  Everything is in sync."
  fi

  rm -rf "$tmp"
  [ "$rc" -eq 0 ] && date '+%Y-%m-%d %H:%M:%S' > "$LAST_FILE"
  prune_old
  return "$rc"
}

xml_escape() { printf '%s' "$1" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'; }

cmd_install() {
  VERBOSE=1
  echo "==> Syncing Alfred's preferences with $MIRROR_DIR"
  cmd_sync || { echo "Sync failed, so the background job wasn't installed. Details: $LOG"; return 1; }

  echo "==> Installing background sync (every ${INTERVAL}s)"
  mkdir -p "$HOME/Library/LaunchAgents" || return 1
  cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>                <string>$LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>$(xml_escape "$SELF")</string>
    <string>sync</string>
  </array>
  <key>StartInterval</key>        <integer>$INTERVAL</integer>
  <key>RunAtLoad</key>            <true/>
  <key>ProcessType</key>          <string>Background</string>
  <key>LowPriorityIO</key>        <true/>
  <key>Nice</key>                 <integer>10</integer>
  <key>StandardOutPath</key>      <string>$(xml_escape "$STATE_DIR/launchd.log")</string>
  <key>StandardErrorPath</key>    <string>$(xml_escape "$STATE_DIR/launchd.log")</string>
</dict>
</plist>
EOF
  launchctl bootout "gui/$(id -u)/$LABEL" >/dev/null 2>&1
  if ! launchctl bootstrap "gui/$(id -u)" "$PLIST" >/dev/null 2>&1; then
    launchctl load -w "$PLIST" >/dev/null 2>&1 || { echo "Couldn't start the background job. Try: launchctl load -w \"$PLIST\""; return 1; }
  fi

  cat <<EOF

Done. Alfred's preferences now sync both ways with:
    $MIRROR

  - In Claude, connect the folder:  $MIRROR_DIR
  - macOS may show a "Background Items Added" notice for bash: that's this job.
  - Check on it any time:   $SELF status
  - Turn it off:            $SELF uninstall
EOF
}

cmd_uninstall() {
  launchctl bootout "gui/$(id -u)/$LABEL" >/dev/null 2>&1 || launchctl unload "$PLIST" >/dev/null 2>&1
  rm -f "$PLIST"
  echo "Background sync stopped. Your files are untouched:"
  echo "    synced copy:                    $MIRROR_DIR"
  echo "    state, backups, trash and log:  $STATE_DIR"
}

cmd_status() {
  local job="off  (start it with: $SELF install)" n=0 c=0
  if launchctl print "gui/$(id -u)/$LABEL" >/dev/null 2>&1 \
     || launchctl list 2>/dev/null | grep -q "$LABEL"; then
    job="on, every ${INTERVAL}s"
  fi
  [ -f "$STATE" ] && n="$(wc -l < "$STATE" | tr -d ' ')"
  [ -d "$CONFLICT_DIR" ] && c="$(ls -1 "$CONFLICT_DIR" 2>/dev/null | wc -l | tr -d ' ')"
  echo "Alfred's preferences:  $(live_bundle)"
  echo "Synced copy:           $MIRROR"
  echo "Background sync:       $job"
  echo "Last sync:             $(cat "$LAST_FILE" 2>/dev/null || echo never)"
  echo "Files tracked:         $n"
  echo "Conflict folders:      $c  ($CONFLICT_DIR)"
  if [ -f "$LOG" ]; then
    echo
    echo "Recent activity:"
    tail -n 12 "$LOG" | sed 's/^/  /'
  fi
}

case "${1:-sync}" in
  sync)           cmd_sync ;;
  install)        cmd_install ;;
  uninstall)      cmd_uninstall ;;
  status)         cmd_status ;;
  help|-h|--help) usage ;;
  *)              usage >&2; exit 2 ;;
esac
