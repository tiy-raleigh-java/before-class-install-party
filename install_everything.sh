# mac setup script for Java class

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

# read the student id from the command line
STUDENT_ID=$1
INSTRUCTOR=$2

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
# Install JDK 8
##########################################
print PURPLE BOLD "Installing Java Development Kit 8..."
print "The Java Development Kit (JDK) is what turns the code you write into something the Java Runtime Environment (JRE) can actually execute on your computer. IE: It makes the magic work."

if ls /Library/Java/JavaVirtualMachines/ | grep jdk1.8.0_121 > /dev/null ; then
	print GREEN "Java 8 is already installed!"
else 
	# install jdk 8
	brew cask install java
	
	# confirm java 8 is now installed
	if ls /Library/Java/JavaVirtualMachines/ | grep jdk1.8.0_121 > /dev/null ; then
		print GREEN "Java Development Kit 8 was successfully installed!"
	else 
		print RED "Java Development Kit 8 was not successfully installed!"
		
		exit 1
	fi
fi

##########################################
# Install JDK 9
##########################################
print PURPLE BOLD "Installing Java Development Kit 9 (Early Access)..."
print "Java 9 is the upcoming version of Java. It is slated to be released in 2017. While Java 9 isn't covered in this class, it does come with a really useful tool called a REPL, which we'll learn about."

if ls /Library/Java/JavaVirtualMachines/ | grep jdk-9 > /dev/null ; then
	print GREEN "Java Development Kit 9 is already installed!"
else 
	# install jdk 9
	brew cask install java9-beta
	
	# confirm java 9 is now installed
	if ls /Library/Java/JavaVirtualMachines/ | grep jdk-9 > /dev/null ; then
		print GREEN "Java Development Kit 9 was successfully installed!"
	else 
		print RED "Java Development Kit 9 was not successfully installed!"
		
		exit 1
	fi
fi

##########################################
# Install jenv
##########################################
print PURPLE BOLD "Installing jenv..."
print "Java 9 will try to become the default Java on your computer. The jenv program will enable us to switch between Java versions, but use Java 8 as the default."

if which jenv > /dev/null ; then
	print GREEN "jenv is already installed!"
else 
	# install jenv
	brew install jenv
	
	# add jenv to the .bash_profile
	echo -e 'if which jenv > /dev/null; then eval "$(jenv init -)"; fi' >> ~/.bash_profile
	
	# source bash_profile to load jenv
	source ~/.bash_profile
	
	# confirm jenv is now installed
	if which jenv > /dev/null ; then
		print GREEN "jenv was successfully installed!"
	else 
		print RED "jenv was not successfully installed!"
		
		exit 1
	fi
fi

##########################################
# Add Java Installs to jenv
##########################################
print PURPLE BOLD "Add jenv Versions..."
print "Add installed versions of Java to jenv configuration."

for FILE in /Library/Java/JavaVirtualMachines/*
do
	if [ -e "$FILE/Contents/Home/bin/java" ] ; then
		# get the specific java version number
		JAVA_VERSION=`\$FILE/Contents/Home/bin/java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}'`
		JAVA_VERSION=${JAVA_VERSION//_/.}
		
		print "Checking to see if JDK $JAVA_VERSION is configured in jenv..."
		
		# is this version of java added to jenv?
		if jenv versions | grep $JAVA_VERSION > /dev/null ; then
			print GREEN "JDK $JAVA_VERSION is configured in jenv!"
			
		else
			print "Configuring JDK $JAVA_VERSION in jenv..."
			
			# add this java version (and say yes if needed)
			yes | jenv add "$FILE/Contents/Home"
			
			# make sure it installed correctly
			if jenv versions | grep $JAVA_VERSION > /dev/null ; then
				print GREEN "JDK $JAVA_VERSION is configured in jenv!"
			else
				print RED "JDK $JAVA_VERSION is not configured in jenv!"
			
				exit 1
			fi
		fi
	fi

done

##########################################
# Set global Java version
##########################################
print PURPLE BOLD "Set Java 8 as default version..."

if jenv global | grep 1.8 > /dev/null ; then
	print GREEN "Java 8 is already the default version!"
else
	# set the global version of java
	jenv global 1.8

	if jenv global | grep 1.8 > /dev/null ; then
		print GREEN "Java 8 is configured as the default!"
	else
		print RED "Java 8 is not configured as the default version!"
		
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
# Install IntelliJ IDEA Ultimate
##########################################
print PURPLE BOLD "Installing IntelliJ IDEA Ultimate..."
print "IntelliJ is an Integrated Development Environment (IDE). It provides a ton of powerful tools that make it easier to write and test Java code."
print "We will be using IntelliJ IDEA Ultimate in class. I will provide you with a student license you can use for the duration of this class. After this class, The Iron Yard can help you purchase your own license at a discount. If you do not yet have a license for IntelliJ, it can be run as a trial for up to 30 days."

# check if intellij is already installed
if [ -e "/Applications/IntelliJ IDEA.app" ]; then
	print GREEN "IntelliJ IDEA is already installed!"
else 
	# install intellij
	brew cask install intellij-idea
	
	# confirm intellij is now installed
	if [ -e "/Applications/IntelliJ IDEA.app" ]; then
		print GREEN "IntelliJ IDEA was successfully installed!"
	else 
		print RED "IntelliJ IDEA was not successfully installed!"
		
		exit 1
	fi
fi

##########################################
# Configure IntelliJ
##########################################
print PURPLE BOLD "Configuring IntelliJ IDEA Ultimate..."
print "To save time, we'll automatically configure some parts of IntelliJ. This script choses most of the default options, but installs a plugin for Node.js, turns on color blind features, sets up the default JDK, and more."

if [ -e ~/Library/Application\ Support/IntelliJIdea2016.3 ] ; then
	print GREEN "IntelliJ is already configured."
else 
	# download config settings
	print "Downloading configuration settings..."
	curl -s -o ~/IntelliJ_Config.zip https://raw.githubusercontent.com/tiy-raleigh-java/before-class-install-party/master/IntelliJ_Config.zip
	
	# unzip the config settings
	print "Extract configuration settings..."
	unzip -o ~/IntelliJ_Config.zip -d ~/Library
	
	if [ -e ~/Library/Application\ Support/IntelliJIdea2016.3 ] ; then
		print GREEN "IntelliJ was successfully configured!"
	else 
		print RED "IntelliJ was not successfully configured!"
		
		exit 1
	fi
fi

##########################################
# Install TextWrangler
##########################################
print PURPLE BOLD "Installing TextWrangler..."
print "It's often useful to have a powerful plain text editor. TextWrangler is easy to use, powerful, and free."

# check if TextWrangler is already installed
if [ -e "/Applications/TextWrangler.app" ]; then
	print GREEN "TextWrangler is already installed!"
else 
	# install textwranger
	brew cask install textwrangler
	
	# confirm TextWrangler is now installed
	if [ -e "/Applications/TextWrangler.app" ]; then
		print GREEN "TextWrangler was successfully installed!"
	else 
		print RED "TextWrangler was not successfully installed!"
		
		exit 1
	fi
fi

##########################################
# Add IntelliJ, Chrome, and TextWrangler to the dock
##########################################
print PURPLE BOLD "Creating application shortcuts in the Dock..."
print "For the sake of ease, this script will add IntelliJ, Chrome, and TextWrangler into the dock."

RESTART_DOCK=false

if defaults read com.apple.dock persistent-apps | grep IntelliJ > /dev/null ; then
	print GREEN "IntelliJ is already in the Dock."
else
	defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/IntelliJ IDEA.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
	RESTART_DOCK=true
	
	if defaults read com.apple.dock persistent-apps | grep IntelliJ > /dev/null ; then
		print GREEN "IntelliJ was successfully added to the Dock!"
	else 
		print RED "IntelliJ was successfully added to the Dock!"
		
		exit 1
	fi
fi

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

if defaults read com.apple.dock persistent-apps | grep TextWrangler > /dev/null ; then
	print GREEN "TextWrangler is already in the Dock."
else
	defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/TextWrangler.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
	RESTART_DOCK=true
	
	if defaults read com.apple.dock persistent-apps | grep TextWrangler > /dev/null ; then
		print GREEN "TextWrangler was successfully added to the Dock!"
	else 
		print RED "TextWrangler was successfully added to the Dock!"
		
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
print "This script will install some useful extensions into Chrome:"
print " - $($BLUE)$($BOLD)Newline Notifier$($RESET) - This is a tool that can be used to report to Doug exactly how you are feeling in class right now."
print " - $($BLUE)$($BOLD)JSON Formatter$($RESET) - JSON is a common data format. By default, it's not displayed nicely in Chrome. This extension improves how it's displayed."
#print " - $($BLUE)$($BOLD)W3School Hider$($RESET) - This plugin prevents the w3schools website from being displayed in Google search results. The reason this is being blocked is because there are much better and more useful resources available."

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

print "Install Newline Notifier..."
if [ -e ~/Library/Application\ Support/Google/Chrome/External\ Extensions/ccciedmfjgjhmnigjlhhebnlcbjfamgg.json ] ; then
	print GREEN "Newline Notifier is already installed!"
else
	echo '{"external_update_url": "https://clients2.google.com/service/update2/crx"}' > ~/Library/Application\ Support/Google/Chrome/External\ Extensions/ccciedmfjgjhmnigjlhhebnlcbjfamgg.json
	
	if [ -e ~/Library/Application\ Support/Google/Chrome/External\ Extensions/ccciedmfjgjhmnigjlhhebnlcbjfamgg.json ] ; then
		print GREEN "Newline Notifier was successfully installed!"
	else
		print RED "Newline Notifier was not successfully installed!"
		
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

#print "W3School Hider..."
#if [ -e ~/Library/Application\ Support/Google/Chrome/External\ Extensions/cbifdjebjnindebojlhccdccmgfgccdo.json ] ; then
#	print GREEN "W3School Hider is already installed!"
#else
#	echo '{"external_update_url": "https://clients2.google.com/service/update2/crx"}' > ~/Library/Application\ Support/Google/Chrome/External\ Extensions/cbifdjebjnindebojlhccdccmgfgccdo.json
#	
#	if [ -e ~/Library/Application\ Support/Google/Chrome/External\ Extensions/cbifdjebjnindebojlhccdccmgfgccdo.json ] ; then
#		print GREEN "W3School Hider was successfully installed!"
#	else
#		print RED "W3School Hider was not successfully installed!"
#		
#		exit 1
#	fi
#fi

##########################################
# Create Testifier Configuration
##########################################
print PURPLE BOLD "Create Testifier Configuration..."
print "Throughout this class we will be writing code and running associated tests. These tests use a custom tool called testifier that reports test results to Doug immediately."

if [ -e ~/.tiy-config ] ; then
	print GREEN "Testifier configuration was already created!"
else
	# output the .tiy-config for testifier's test runner
	echo "{ instructor: '$INSTRUCTOR', studentId: $STUDENT_ID }" > ~/.tiy-config

	if [ -e ~/.tiy-config ] ; then
		print GREEN "Testifier configuration was successfully created!"
	else
		print RED "Testifier configuration was not successfully created!"
		
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
