# mac setup script for first four weeks of class

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

# Greetings!
print BOLD GREEN_BG "\nWelcome To The Iron Yard!"
print "This script will automate the install all of the software required for The Iron Yard's Java class. You may be prompted for your password. If so, please type it and press enter. Note that you will not see your password displayed as you type."

##########################################
# Install the xcode command line tools
##########################################
print PURPLE BOLD "Installing the Xcode Command Line Tools...\n"

print "The Xcode Command Line Tools allow programmers to do command line development. We will be using some of these tools in class."

if ! xcode-select -p 2>&1 | grep CommandLineTools > /dev/null && ! xcode-select -p 2>&1 | grep Applications > /dev/null  ; then
	# xcode cli tools are not installed
	print "Unfortunately, we can't automate the install of the Xcode Command Line Tools for you! This script will open a dialog that reads:"

	print "\t\"The 'xcode-select' command requires the command line developer tools. Would you like to install the tools now?\""

	# start the xcode cli tool installer
	xcode-select --install &> /dev/null

	# wait until the dialog is open
	echo -n "Launching..."
	until ps -ax | grep "[I]nstall Command Line Developer Tools.app" > /dev/null ; do
		echo -n "."
		sleep 1
	done
	echo
	echo

	# remind the user to click install
	print RED BOLD "You must click the blue $($BLUE)'Install'$($RED;$BOLD) button in the popup dialog and agree to the license to continue!"

	# wait while the dialog is still open
	while ps -ax | grep "[I]nstall Command Line Developer Tools.app" > /dev/null ; do
		sleep 1
	done

	# double check that the Xcode CLI tools were successfully installed
	if ! xcode-select -p 2>&1 | grep CommandLineTools > /dev/null && ! xcode-select -p 2>&1 | grep Applications > /dev/null  ; then
 		# the install failed
	 	print RED "Xcode Command Line Tools were not successfully installed!!"

 		exit 1
 	else
 		# the install was successful
		print GREEN "Xcode Command Line Tools were successfully installed!"
 	fi
else
	print GREEN "Xcode Command Line Tools are already installed!"
fi

##########################################
# Install Homebrew
##########################################
print PURPLE BOLD "Installing Homebrew..."
print "Homebrew is a package management tool for OS X that makes it easy to install a wide range of open source tools. We will use Homebrew to install software in class as needed."

if [ -e /usr/local/bin/brew ]; then
	print GREEN "Homebrew is already installed!"
else
	# install homebrew
	yes "\n" | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	# confirm homebrew is now installed
	if [ -e /usr/local/bin/brew ]; then
		print GREEN "Homebrew was successfully installed!"
	else
		print RED "Homebrew was not successfully installed!!"

 		exit 1
	fi
fi

##########################################
# Configure Homebrew Cask and Versions
##########################################
print PURPLE BOLD "Configuring Homebrew Cask and Versions"
print "Homebrew Cask and Versions extends Homebrew, enabling easy installation of macOS applications, large binaries, and specific versions of software."

if brew tap | grep cask > /dev/null ; then
	print GREEN "Homebrew Cask is already configured!"
else

	# tap the cask
	brew tap caskroom/cask

	if brew tap | grep cask > /dev/null ; then
		print GREEN "Homebrew Cask was successfully configured!"
	else
		print RED "Homebrew Cask was not successfully configured!"

 		exit 1
	fi
fi

if brew tap | grep versions > /dev/null ; then
	print GREEN "Homebrew Versions is already configured!"
else

	# tap the cask
	brew tap caskroom/versions

	if brew tap | grep versions > /dev/null ; then
		print GREEN "Homebrew Versions was successfully configured!"
	else
		print RED "Homebrew Versions was not successfully configured!"

 		exit 1
	fi
fi

##########################################
# Install Google Chrome
##########################################
print PURPLE BOLD "Installing Google Chrome..."
print "Chrome is a fantastic browser that provides a wealth of useful tools. It's the browser we will favor in class."

# check if chrome is already installed
if [ -e "/Applications/Google Chrome.app" ]; then
	print GREEN "Google Chrome is already installed!"
else
	brew cask install google-chrome

	# confirm chrome is now installed
	if [ -e "/Applications/Google Chrome.app" ]; then
		print GREEN "Google Chrome was successfully installed!"
	else
		print RED "Google Chrome was not successfully installed!"

		exit 1
	fi
fi

##########################################
# Install Atom
##########################################
print PURPLE BOLD "Installing Atom..."
print "Atom is a 'hackable' text editor. We will be using Atom to write code. This also configures the apm and atom command line programs."

# check if chrome is already installed
if [ -e "/Applications/Atom.app" ] && [ -e "/usr/local/bin/apm" ] && [ -e "/usr/local/bin/atom" ] ; then
	print GREEN "Atom is already installed!"
else
	if [ -e "/Applications/Atom.app" ] ; then
		print "Atom is already installed, but not its command line tools. Atom will be uninstalled and reinstalled to enable its command line tools. This will not delete or change any of your settings or installed packages."

		# delete atom
		rm -fr /Applications/Atom.app
	fi

	# install atom
	brew cask install atom

	# confirm atom is now installed
	if [ -e "/Applications/Atom.app" ]; then
		print GREEN "Atom was successfully installed!"
	else
		print RED "Atom was not successfully installed!"

		exit 1
	fi
fi

##########################################
# Install Slack
##########################################
print PURPLE BOLD "Installing Slack..."
print "Slack brings all your communication together in one place. It's real-time messaging, archiving and search for modern teams."

# check if chrome is already installed
if [ -e "/Applications/Slack.app" ]; then
	print GREEN "Slack is already installed!"
else
	brew cask install slack

	# confirm slack is now installed
	if [ -e "/Applications/Slack.app" ]; then
		print GREEN "Slack was successfully installed!"
	else
		print RED "Slack was not successfully installed!"

		exit 1
	fi
fi

##########################################
# Create an SSH key
##########################################
print PURPLE BOLD "Generating an SSH Key..."
print "SSH stands for Secure Shell and is used to communicate securely across the internet. It's similar in nature to how your browser talks to a secure website."
print "We will be using a tool called Git to track changes we make to our programs in this class. We will also be using an online service called Github. Behind the scenes, Git uses SSH to communicate over the internet with Github. For this to work, we need to create an SSH key. An SSH key is like an ID your computer can use to prove to other computers that you are who you say you are."

# check if we already have an SSH key
if [ -e ~/.ssh/id_rsa ]; then
	print GREEN "An SSH key already exists!"
else
	# generate the ssh key
	cat /dev/zero | ssh-keygen -q -N ""

	# confirm an SSH key was created
	if [ -e ~/.ssh/id_rsa ]; then
		print GREEN "An SSH key was successfully generated!"
	else
		print RED "An SSH key was not successfully generated!"

		exit 1
	fi
fi

##########################################
# Install Node.js
##########################################
print PURPLE BOLD "Installing Node.js..."
print "Node.js is a server-side implementation of JavaScript. We'll make use of it as we learn JavaScript. For the record, Java and JavaScript are two entirely different things with no relationship."

# check if node is already installed
if [ -e "/usr/local/bin/node" ]; then
	print GREEN "Node.js is already installed!"
else
	# install node
	brew install node

	# confirm node is now installed
	if [ -e "/usr/local/bin/node" ]; then
		print GREEN "Node.js was successfully installed!"
	else
		print RED "Node.js was not successfully installed!"

		exit 1
	fi
fi

##########################################
# Install Postgres.app
##########################################
print PURPLE BOLD "Installing Postgres.app..."
print "PostgreSQL is an open source relational database. It is used to store and retrieve structured data. Postgres.app is the simplest way to get started with Postgres."

# check if postgres.app is already installed
if [ -e "/Applications/Postgres.app" ]; then
	print GREEN "Postgres.app is already installed!"
else
	# install postgres.app
	brew install Caskroom/cask/postgres

	# confirm postgres.app is now installed
	if [ -e "/Applications/Postgres.app" ]; then
		print GREEN "Postgres.app was successfully installed!"
	else
		print RED "Postgres.app was not successfully installed!"

		exit 1
	fi
fi

##########################################
# Configure Postgres tools
##########################################
print PURPLE BOLD "Configuring Postgres tools..."
print "Postgres itself comes with a few useful tools that Postgres.app doesn't automatically make available to you. We'll configure those now."

# check if Postgres.app is found in the .bash_profile file (this tells us it's likely on the path)
if cat ~/.bash_profile | grep Postgres.app > /dev/null; then
	print GREEN "Postgress tools are already configured!"
else
	# add the postgres bin directory to the path
	echo -e 'export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin' >> ~/.bash_profile

	# confirm postgres tools rea now configured
	if cat ~/.bash_profile | grep Postgres.app > /dev/null; then
		print GREEN "Postgres tools were successfully configured!"
	else
		print RED "Postgres tools were NOT successfully configured!"

		exit 1
	fi
fi

##########################################
# Add Chrome, Atom, and Slack to the dock
##########################################
print PURPLE BOLD "Creating application shortcuts in the Dock..."
print "For the sake of ease, this script will add Chrome, Atom, and Slack into the dock."

RESTART_DOCK=false

if defaults read com.apple.dock persistent-apps | grep Chrome > /dev/null ; then
	print GREEN "Chrome is already in the Dock."
else
	defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
	RESTART_DOCK=true

	if defaults read com.apple.dock persistent-apps | grep Chrome > /dev/null ; then
		print GREEN "Chrome was successfully added to the Dock!"
	else
		print RED "Chrome was successfully added to the Dock!"

		exit 1
	fi
fi

if defaults read com.apple.dock persistent-apps | grep Atom > /dev/null ; then
	print GREEN "Atom is already in the Dock."
else
	defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Atom.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
	RESTART_DOCK=true

	if defaults read com.apple.dock persistent-apps | grep Atom > /dev/null ; then
		print GREEN "Atom was successfully added to the Dock!"
	else
		print RED "Atom was successfully added to the Dock!"

		exit 1
	fi
fi

if defaults read com.apple.dock persistent-apps | grep Slack > /dev/null ; then
	print GREEN "Slack is already in the Dock."
else
	defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Slack.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
	RESTART_DOCK=true

	if defaults read com.apple.dock persistent-apps | grep Slack > /dev/null ; then
		print GREEN "Slack was successfully added to the Dock!"
	else
		print RED "Slack was successfully added to the Dock!"

		exit 1
	fi
fi

if [ $RESTART_DOCK = true ] ; then
	print "Restarting the Dock. Your screen will flicker, so don't worry."
	killall Dock
fi

##########################################
# Configure Git
##########################################
print PURPLE BOLD "Configuring Git..."
print "We need to configure Git so it knows our email address and name."

if git config  -l | grep user.name= > /dev/null ; then
	print GREEN "Git user's name is already configured"
else
	# prompt for user's name
	print "Please enter your full name:"
	read USER_NAME

	# configure the user's name
	git config --global user.name "$USER_NAME"

	if git config  -l | grep user.name= > /dev/null ; then
		print GREEN "Git user's name was successfully configured!"
	else
		print RED "Git user's name was not successfully configured!"

		exit 1
	fi
fi

if git config  -l | grep user.email= > /dev/null ; then
	print GREEN "Git user's email is already configured"
else
	# prompt for user's email
	print "Please enter your email address:"
	read USER_EMAIL

	# configure the user's email
	git config --global user.email "$USER_EMAIL"

	if git config  -l | grep user.email= > /dev/null ; then
		print GREEN "Git user's email was successfully configured!"
	else
		print RED "Git user's email was not successfully configured!"

		exit 1
	fi
fi

##########################################
# Enable locate command
##########################################
print PURPLE BOLD "Configuring locate..."
print "Finding files and folders on the command line can be a pain. This configures 'locate', a tool to make basic searches easier."

if sudo launchctl list | grep com.apple.locate > /dev/null ; then
	print GREEN "Locate is already configured!"
else
	# enable locate
	sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

	if sudo launchctl list | grep com.apple.locate > /dev/null ; then
		print GREEN "Locate was successfully configured!"
	else
		print RED "Locate was not successfully configured!"

		exit 1
	fi
fi

##########################################
# Install Chrome extensions
##########################################
print PURPLE BOLD "Install Chrome extensions..."
print "This script will install a useful extension into Chrome:"
print " - $($BLUE)$($BOLD)JSON Formatter$($RESET) - JSON is a common data format. By default, it's not displayed nicely in Chrome. This extension improves how it's displayed."
print " - $($BLUE)$($BOLD)Newline Powertools$($RESET) - A plugin that provides useful 'powertools' for working with Newline. Currently this plugin does nothing, but we will add features to it that will enhance your experience on Newline."

print "Creating External Extensions directory..."
if [ -e ~/Library/Application\ Support/Google/Chrome/External\ Extensions ] ; then
	print GREEN "External Extensions directory already exists!"
else
	# make External Extensions directory
	mkdir -p ~/Library/Application\ Support/Google/Chrome/External\ Extensions

	if [ -e ~/Library/Application\ Support/Google/Chrome/External\ Extensions ] ; then
		print GREEN "External Extensions directory was successfully created!"
	else
		print RED "External Extensions directory was not successfully created!"

		exit 1
	fi
fi

print "JSON Formatter..."
if [ -e ~/Library/Application\ Support/Google/Chrome/External\ Extensions/bcjindcccaagfpapjjmafapmmgkkhgoa.json ] ; then
	print GREEN "JSON Formatter is already installed!"
else
	echo '{"external_update_url": "https://clients2.google.com/service/update2/crx"}' > ~/Library/Application\ Support/Google/Chrome/External\ Extensions/bcjindcccaagfpapjjmafapmmgkkhgoa.json

	if [ -e ~/Library/Application\ Support/Google/Chrome/External\ Extensions/bcjindcccaagfpapjjmafapmmgkkhgoa.json ] ; then
		print GREEN "JSON Formatter was successfully installed!"
	else
		print RED "JSON Formatter was not successfully installed!"

		exit 1
	fi
fi

print "Newline Powertools..."
if [ -e ~/Library/Application\ Support/Google/Chrome/External\ Extensions/jkofmljfahlllnhdikffdoignjodkplo.json ] ; then
	print GREEN "Newline Powertools is already installed!"
else
	echo '{"external_update_url": "https://clients2.google.com/service/update2/crx"}' > ~/Library/Application\ Support/Google/Chrome/External\ Extensions/jkofmljfahlllnhdikffdoignjodkplo.json

	if [ -e ~/Library/Application\ Support/Google/Chrome/External\ Extensions/jkofmljfahlllnhdikffdoignjodkplo.json ] ; then
		print GREEN "Newline Powertools was successfully installed!"
	else
		print RED "Newline Powertools was not successfully installed!"

		exit 1
	fi
fi

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

##########################################
# Configure Github SSH key
##########################################
print PURPLE BOLD "Configure Github SSH Key..."
print "We need to configure Github to recognize the SSH key we generated. Using SSH will keep you from having to enter your Github password repeatedly."

# this will indicate whether or not we've collected the students's github info successfully
GITHUB_VALIDATED=-1

# loop until we collect the student's github username and password successfully
while [ "$GITHUB_VALIDATED" -ne "0" ] ; do
	# prompt for user's github username
	print "Please enter your github username:"
	read GITHUB_USERNAME

	# prompt for user's github password
	print "Please enter your github password:"
	read -s GITHUB_PASSWORD

	# test the username and password
	curl -s -f -u "$GITHUB_USERNAME:$GITHUB_PASSWORD" https://api.github.com/user/keys > /dev/null

	# indicate whether or not github is validated
	GITHUB_VALIDATED=$?

	if [ "$GITHUB_VALIDATED" -ne "0" ] ; then
		print RED "Your Github username and password could not be validated. Please try again. If you haven't already opened a Github account you can pause here and create an account before continuing."
	fi
done

# read the user's public key
USER_KEY=`cat ~/.ssh/id_rsa.pub`
USER_KEY=${USER_KEY% *}

# list the user's ssh keys
GITHUB_KEYS=`curl -s -f -u "$GITHUB_USERNAME:$GITHUB_PASSWORD" https://api.github.com/user/keys`

# is this key represented in the github keys
if [[ "$GITHUB_KEYS" == *"$USER_KEY"* ]] ; then
	print GREEN "Github is already configured with your SSH key!"
else
	print "Adding SSH key to Github..."

	# add the user's SSH key to github
	curl -s -f -u "$GITHUB_USERNAME:$GITHUB_PASSWORD" -H "Content-Type: application/json" -d "{\"title\": \"TIY-Configured SSH Key\", \"key\": \"$USER_KEY\"}" -X POST https://api.github.com/user/keys > /dev/null

	# get the user's ssh keys to github to make sure it was setup correctly
	GITHUB_KEYS=`curl -s -f -u "$GITHUB_USERNAME:$GITHUB_PASSWORD" https://api.github.com/user/keys`

	# double check that everything was setup correctly
	if [[ "$GITHUB_KEYS" == *"$USER_KEY"* ]] ; then
		print GREEN "Github was successfully configured with your SSH key!"
	else
		print RED "Github was not successfully configured with your SSH key!"

		exit 1
	fi

fi

##########################################
# Create Projects directory
##########################################
print PURPLE BOLD "Create Projects directory..."
print "We need a place to keep the files we'll create for projects in this class. This will be the Projects directory that will be created in our home directory."

if [ -e ~/Projects ] ; then
	print GREEN "Projects directory already exists!"
else
	# make the directory
	mkdir ~/Projects

	if [ -e ~/Projects ] ; then
		print GREEN "Projects directory was successfully created!"
	else
		print RED "Projects directory was not successfully created!"

		exit 1
	fi
fi

##########################################
# Done!
##########################################
print BOLD GREEN "\nSoftware installation and configuration was successfully completed!"

print "Welcome to The Iron Yard!"
