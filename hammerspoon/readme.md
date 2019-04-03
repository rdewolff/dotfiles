# Hammerspoon

Config by Romain de Wolff. 

Currently using Macbook Pro keyboard, Apple Magic Keyboard and Vortex Pok3r keyboard. But this can be customized to any macOS hardware!

The goal is to be able to manipulate your mac with a keyboard containing no functions keys (F1 to F12 or more) and no Apple 'fn' key either. 

## Requirements

The following main features are required by our Hammerspoon config.

We want to stay as close as possible to the native controls as possible. Enabling us to switch keyboard or environment often without struggling too much.

We want to have another key for escape, as the touchbar Esc key on Macbook Pro is really shitty to work with.

Futur : it would be a great addition to be able to customize key bindings for other (most used) applications. That would allow to bind vim-like in Chrome, or specific actions for each app we love!

## Software required

[Hammerspoon](https://www.hammerspoon.org/) is required to make this work.

Depending on the main key you want to use, you will require [Karabiner](https://pqrs.org/osx/karabiner/) to remap the key, as not all keys can be mapped in Hammerspoon.

## Keyboard actions

Here are the various categories of actions we want to be able to do with our keyboard.

### Windows manipulation

Ability to move around windows with custom keystroke to manage our workspace, applications, handle multiple screen, etc.

### Enhanced windows tab

cf plugin XYZ

### MacOS functions

We want to be able to use the various macOS functions, like multimedia controls (play/pause, previous, next, volume control), luminosity and display all windows.

### Application launch/focus

Have some keystroke to launch or focus our favorite applications.

The keys modifier we use to do this is `Cmd +[number]`

### Navigation mode (à la Vim mode)

Ability to use a minimal keyboard to switch to VIM mode.

## Implementation

The trick is to find an easy way to fast switch to various mode.

### Direct shortcuts

The following categories of actions are done via direct shortcuts, without using a specific "mode toggle", to enable quick access to usually just a few actions (like move window to next screen).

- Windows manipulation
- MacOS functions
- Application launch/focus

### Modes 

The idea is to use a single key and hit it multiple times to go switch to different keyboard input mode. Caps Lock is a very good candidate for such, as it's a very easy key to reach and not really usefull : you can always use shift key to use caps.

#### The different modes

So here are the modes we need :

- Input mode (default, keyboard behave normally)
- Navigation mode, à la vim

##### Input mode

Shortcuts



##### Navigation mode

The navigation mode should be 'clever'. By clever, I mean we want it to potentially act differently depending on the application we are using. For example, in our browser, we want the J and K to scroll, and in our editor, to move one line up or down (again, à la vim).


## Sources & references

[1] [http://stevelosh.com/blog/2012/10/a-modern-space-cadet/#pckeyboardhack](A Modern Space Cadet, by Steve Losh)
[2] 