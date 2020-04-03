# Update Vivaldi customer hack 

I wanted to share my current setup. Don't know how many Vivaldi modders are out there using macOS, but I hope it will help at least some of you automate the most repetitive tasks. Following a complete rundown of the steps required:

Get your files ready. Personally I'm using 3 individual ones.

- upviv.sh to patch the application whenever an update has finished installing.
- modviv.sh to startup Vivaldi when you want to inspect its UI.
- bakviv.sh to backup the files you are currently working on outside the browser

## Instructions

The files use the extension .sh so they get opened by your default text editor automatically. I keep them on Dropbox just like custom.css and custom.js for backup. To run these scripts we will have to make them executable and change the file extension.

In Terminal open the directory you have saved the bash scripts to and issue following commands:
- chmod +x upviv.sh
- chmod +x modviv.sh
- chmod +x bakviv.sh

Now copy them and change the extension to .command instead of .sh. By default this will run them in your Terminal.

We could leave it like that and just double click the files to execute, but a more elegant solution is to run them directly from the terminal as commands…

After making each file executable copy all of them to this directory /usr/local/bin/
Delete the filename extension .sh
Optionally tag each file so you can find it more easily.
Now each command can be run from terminal by just typing its name.

Below are the example files. Exchange PATH_TO_FILE for your own path. To get a full path you can drag and drop a file into terminal. Adapt these examples to your needs, make your own.