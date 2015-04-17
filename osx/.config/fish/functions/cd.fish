function cd
	builtin cd $argv
	and ~/bin/dirs.pl -a (pwd)
end
