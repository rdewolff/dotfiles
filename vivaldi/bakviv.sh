#!/bin/bash
findPath="`find /Applications/Vivaldi.app -name Vivaldi\ Framework.framework`"
cp "$findPath"/Resources/vivaldi/style/custom.css /Users/rdewolff/Projects/dotfiles/vivaldi/custom.css
cp "$findPath"/Resources/vivaldi/custom.js /Users/rdewolff/Projects/dotfiles/vivaldi/custom.js
echo Backup completed.
