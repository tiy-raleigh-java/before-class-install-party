if ! xcode-select -p 2>&1 | grep Applications > /dev/null || ! xcode-select -p 2>&1 | grep CommandLineTools > /dev/null ; then
	echo "good"
else
	echo "bad"
fi