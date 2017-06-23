
BOLD="tput bold"
RED="tput setaf 1"
GREEN="tput setaf 2"
BLUE="tput setaf 4"
PURPLE="tput setaf 5"
WHITE="tput setaf 1"
GREEN_BG="tput setab 2"
RESET="tput sgr0"
STANDOUT="tput smso"

print () {
	ARGS=("$@")
	TEXT=${ARGS[*]: -1}

	unset 'ARGS[${#ARGS[@]}-1]'

	for STYLE in "${ARGS[@]}"; do
		STYLE=\$$STYLE
		eval $STYLE
	done

	echo -e $TEXT | fold -s
	echo

	$RESET
}

##########################################
# Install Atom Packages
##########################################
print PURPLE BOLD "Install Atom packages..."
print "This script will install a set of useful packages into Atom:"
print " - $($BLUE)$($BOLD)Sublime-Style-Column-Selection$($RESET) - Enable Sublime style 'Column Selection', allowing you to drag across lines to select a block of text with carets on each line."
print " - $($BLUE)$($BOLD)atom-beautify$($RESET) - Beautify HTML, CSS, JavaScript, PHP, Python, Ruby, Java, C, C++, C#, Objective-C, CoffeeScript, TypeScript, Coldfusion, SQL, and more in Atom"
print " - $($BLUE)$($BOLD)atom-wrap-in-tag$($RESET) - Simplest package for Atom that wraps tag around selection - similar functionality found on other editors like PhpStorm, SublimeText, TextMate etc."
print " - $($BLUE)$($BOLD)file-icons$($RESET) - File-specific icons in Atom for improved visual grepping."

print "Sublime-Style-Column-Selection..."
if apm list --installed --bare | Grep Sublime-Style-Column-Selection > /dev/null; then
	print GREEN "Sublime-Style-Column-Selection is already installed!"
else
	apm install Sublime-Style-Column-Selection

	if apm list --installed --bare | Grep Sublime-Style-Column-Selection > /dev/null; then
		print GREEN "Sublime-Style-Column-Selection was successfully installed!"
	else
		print RED "Sublime-Style-Column-Selection was not successfully installed!"

		exit 1
	fi
fi

print "atom-beautify..."
if apm list --installed --bare | Grep atom-beautify > /dev/null; then
	print GREEN "atom-beautify is already installed!"
else
	apm install atom-beautify

	if apm list --installed --bare | Grep atom-beautify > /dev/null; then
		print GREEN "atom-beautify was successfully installed!"
	else
		print RED "atom-beautify was not successfully installed!"

		exit 1
	fi
fi

print "atom-wrap-in-tag..."
if apm list --installed --bare | Grep atom-wrap-in-tag > /dev/null; then
	print GREEN "atom-wrap-in-tag is already installed!"
else
	apm install atom-wrap-in-tag

	if apm list --installed --bare | Grep atom-wrap-in-tag > /dev/null; then
		print GREEN "atom-wrap-in-tag was successfully installed!"
	else
		print RED "atom-wrap-in-tag was not successfully installed!"

		exit 1
	fi
fi

print "file-icons..."
if apm list --installed --bare | Grep file-icons > /dev/null; then
	print GREEN "file-icons is already installed!"
else
	apm install file-icons

	if apm list --installed --bare | Grep file-icons > /dev/null; then
		print GREEN "file-icons was successfully installed!"
	else
		print RED "file-icons was not successfully installed!"

		exit 1
	fi
fi
