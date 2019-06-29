# Configuration of various app

# Firefox
# userChrome.css

# Link to hammerspoon
ln -s /Users/rdewolff/Projects/dotfiles/hammerspoon /Users/rdewolff/.hammerspoon

# Link to Karabiner
# ln -s ~/Projects/dotfiles/karabiner ~/.config

# Link Vimrc
ln -s ~/Projects/dotfiles/vim/.vimrc ~/.vimrc

# Link zshrc
ln -s ~/Projects/dotfiles/zsh/.zshrc ~/.zshrc

# Link Franz
# ln -s ~/Projects/dotfiles/franz/recipes/dev ~/Library/Application\ Support/Franz/recipes

# Config iterm2
# cf : http://stratus3d.com/blog/2015/02/28/sync-iterm2-profile-with-dotfiles-repository/
# can this work without launching iterm2 first?
open -a /Applications/iTerm.app
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/Projects/dotfiles/iterm2"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

# Add iOS & Watch Simulator to Launchpad
#sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"

# VSCode sync extension
code --install-extension Shan.code-settings-sync
# gist ID : 47bf5bc2351398a462c107ceee1aeaa4
# token in password manager


# Open the folder of Firefox
# laucnh Firefox first to ensure the `Profiles` folder does exist
open -a /Applications/Firefox.app
# open the cofnig folder
open ~/Library/Application\ Support/Firefox/Profiles
open ~/Projects/dotfiles/firefox/
echo "You need to manually copy the folder 'chrome' with userChrome.css in your firefox profile"

# Config git
git config --global user.email "rdewolff@gmail.com"
git config --global user.name "Romain de Wolff"