

ln -s /Users/rdewolff/Projects/dotfiles/hammerspoon /Users/rdewolff/.hammerspoon

ln -s ~/Projects/dotfiles/karabiner ~/.config

ln -s ~/Projects/dotfiles/vim/.vimrc ~/.vimrc

ln -s ~/Projects/dotfiles/zsh/.zshrc ~/.zshrc

ln -s ~/Projects/dotfiles/franz/recipes/dev ~/Library/Application\ Support/Franz/recipes

# iterm2
# cf : http://stratus3d.com/blog/2015/02/28/sync-iterm2-profile-with-dotfiles-repository/

defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/Projects/dotfiles/iterm2"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

