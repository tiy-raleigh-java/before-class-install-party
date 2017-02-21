if ! xcode-select -p 2>&1 | grep CommandLineTools > /dev/null && ! xcode-select -p 2>&1 | grep Applications > /dev/null  ; then
	echo "nothing installed"
else
	echo "something installed"
fi