#!/bin/bash
osascript -e 'quit app "Vivaldi.app"'
read -rsp $'Press [Enter] to restart Vivaldi...\n'
open /Applications/Vivaldi.app --args --debug-packed-apps --silent-debugger-extension-api
