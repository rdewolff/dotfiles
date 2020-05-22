# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Upgrade brew
brew upgrade

# add some casks
brew tap homebrew/cask-versions
brew tap homebrew/cask-drivers
brew tap homebrew/cask-fonts

# Install dev tools
brew install git
brew install nvm
brew install tree
brew install yarn
brew install tig
brew install zsh

# Install CLI tools
brew cask install hammerspoon
brew cask install lastpass
brew cask install google-chrome
brew cask install firefox
brew cask install iterm2
brew cask install insomnia # rest client
brew cask install sketch
brew cask install skitch
brew cask install slack
brew cask install choosy
# brew cask install visual-studio-code
brew cask install vscodium # no analytics tracker for god's sake
brew cask install whatsapp
brew cask install spotify
brew cask install sonos
brew cask install reactotron
brew cask install font-fira-code
brew tap homebrew/cask-drivers
brew cask install itsycal # small calendar in the menu bar
brew cask install barrier
brew cask install notion
brew cask install discord
brew cask install signal
brew cask install telegram
brew cask install amethyst
brew cask install postman
brew cask install mpv
brew cask install istat-menus


# Dev
# The Command Line Tools Package
xcode-select --install
# this might be already installed as we use `git` to clone this repo

# React Native
brew install watchman
brew tap AdoptOpenJDK/openjdk
# brew cask install adoptopenjdk8 # this has an issue, we use the following instead :
brew cask install adoptopenjdk/openjdk/adoptopenjdk8

# Docker
brew cask install docker

# React Native
npm install -g react-native-cli

# Ignite CLI
yarn global add ignite-cli

# Feather JS
yarn global add @feathersjs/cli

# Install Cocoa Pods
sudo gem install cocoapods

# regular tools
brew install nmap wget httpie
# Remove outdated versions from the cellar.
brew cleanup

# Oh my ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Yabai tile window manager, move windows with key+mouse 🎉
brew install koekeishiya/formulae/yabai


# Folder
mkdir -p ~/Projects/
mkdir -p ~/Playgrounds/

# Add the private key to the ssh-agent
ssh-add -K ~/.ssh/rdewolff




# Mac App Store command line interface
brew install mas # this took ages to install on 22.05.2020... only 11MB but their network seems really slow.

# Signin to Apple Store
# seems not working with Mojave, needs to do this manually
mas signin rdewolff@gmail.com

# Xcode install
mas install 497799835 # Xcode
mas install 425955336 # Skitch
mas install 918858936 # Airmail 3
