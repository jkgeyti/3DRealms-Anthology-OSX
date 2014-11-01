3DRealms Anthology for OSX
==========================

Convert 3DRealm's Anthology launcher scripts to something that runs on Dosbox for Mac.

Usage
-----

1. Install Dosbox for OSX  in your Applications folder
2. Download this project (download button in sidebar) and unzip it
3. Place `3DR_Anthology-1.0.exe` in the same, unzipped, folder
4. Double-click `install.command` to execute it
5. *If the script is complaining about Dosbox not being found, modify the path in config.sh. Be careful about using `textEdit`, as it'll screw up the quotes.*
6. Open the new `3DRealms Anthology OSX` folder, and double-click any .command file to start a game

Issues
-----

This script will convert all Dosbox-based games in the Anthology package. However, *Duke Nukem 3D Manhattan Project* is not Dosbox-based, and will not run on OSX. The script removes this game. Additionally, only the lower-resolution Dos launcher for Duke Nukem 3D is available on OSX.

Manuals
-------

While there's no pretty launcher like on Windows, you can still find the manuals in the game subfolders. It's usually called `manual.pdf`.

Linux support
-------------

I made this script because I wanted to play the games on my mac. While Linux isn't supported out of the box, the script relies on `bash`, `sed`, `dirname`, and `tr`, so it should be a matter of removing a line or two to make it run on Linux. I simply don't have a linux box right here, so I haven't done it myself. Pull requests are more than welcome!