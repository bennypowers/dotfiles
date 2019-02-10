for f in $argv 
	mv -v -- $f (string replace -r '\session_$' '' $f)
	mv -v -- $f (string replace -r '\_CD (Red Book)$' '' $f)
	lame $f
end

