#!/bin/bash

# Quit Vivaldi
osascript -e 'quit app "Vivaldi.app"'

# Find path to Framework folder of current version and save it as variable
findPath="`find /Applications/Vivaldi.app -name Vivaldi\ Framework.framework`"

# Copy custom files to Vivaldi.app
cp /Users/rdewolff/Projects/dotfiles/vivaldi/custom.css "$findPath"/Resources/vivaldi/style/
cp /Users/rdewolff/Projects/dotfiles/vivaldi/custom.js "$findPath"/Resources/vivaldi/

# Save path to browser.html as variable
browserHtml="$findPath"/Resources/vivaldi/browser.html

# Insert references, if not present, and save to temporary file
sed 's|  </head>|    <link rel="stylesheet" href="style/custom.css" /></head>|;s|  </body>|    <script src="custom.js"></script></body>|' "$browserHtml" > "$browserHtml".temp

# Backup original file
cp "$browserHtml" "$browserHtml".bak

# Overwrite
mv "$browserHtml".temp "$browserHtml"

# Pause script
read -rsp $'Press [Enter] to restart Vivaldi...\n'

# Open custom files in text editor
open "$findPath"/Resources/vivaldi/style/custom.css
open "$findPath"/Resources/vivaldi/custom.js

# Open Vivaldi
open /Applications/Vivaldi.app --args --debug-packed-apps --silent-debugger-extension-api