function parse_git_branch
	set -l branch (git branch --color ^&- | awk '/\*/ {print $2}')
	echo $branch (parse_git_dirty)
end
