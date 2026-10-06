-- prtab:// URL scheme handler. Compiled to ~/Applications/PRTab.app by
-- build-prtab-handler (run from install.sh); Alfred's generated "pr <number>"
-- entries point here so an already-open Chrome tab is focused instead of
-- opening a duplicate.
--
-- URL format: prtab://open/<url-without-https://>
-- The real target goes in the PATH, not the host, because URL hosts get
-- case-folded and repo names (Replit-PR-Bot) must keep their case to match
-- open tab URLs.
on open location theURL
	set thePrefix to "prtab://open/"
	if theURL starts with thePrefix then
		set target to "https://" & text ((length of thePrefix) + 1) thru -1 of theURL
		do shell script "$HOME/.local/bin/chrome-focus-tab " & quoted form of target & " || /usr/bin/open " & quoted form of target
	end if
end open location
