function omgdiff
	git checkout -b omgdiff-(date | shasum | cut -d ' ' -f 1)
    git commit -a -m "temporary changelog message"
    arc diff --nolint --excuse 'linted in Sublime Text 3'
end
