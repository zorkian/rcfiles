function gpf
	echo -n "http://qq.is:3466/"
    curl -d "@$argv" -X PUT http://qq.is:3466/up
end
