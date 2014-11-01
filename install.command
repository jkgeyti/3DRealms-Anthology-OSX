#!/usr/bin/env bash
clear

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
source config.sh

# check if the 3DR_Anthology.exe file exists
[ ! -f 3DR_Anthology-1.0.exe ] && echo "3DR_Anthology-1.0.exe not found. Place in the same folder as this script and rerun." && sleep 2 && exit 100

# check if dosbox exists (just check if there's a file)
[ ! -f "$dosbox" ] && echo "Dosbox not found. Please install Dosbox, and update config.txt" && sleep 2 && exit

# extract exe
$p7z x 3DR_Anthology-1.0.exe || exit 200

# stuff is placed in weird ass no-character/unicode named folder, so start
# by moving everything into the same root folder
mkdir 3DR_Anthology-1.0
for d in $(find . ! -path . ! -path tmp ! -path ./3DR_Anthology-1.0 ! -path ./p7zip -type d -maxdepth 1); do		
	# wildcards are acting up with these unicode folders, so rename the folder before moving files
	mv "$d" tmp	
	mv tmp/* 3DR_Anthology-1.0/
	rmdir tmp
done

# clean up files we don't need
echo "Removing un-needed windows files"
rm -rf 3DR_Anthology-1.0/*/dosbox/*
rm 3DR_Anthology-1.0/leftimg.bmp
rm 3DR_Anthology-1.0/isWelcome.ini
rm 3DR_Anthology-1.0/InstallOptions.dll
rm 3DR_Anthology-1.0/header.bmp
rm 3DR_Anthology-1.0/Finish.ini
rm 3DR_Anthology-1.0/btmimg.bmp
rm 3DR_Anthology-1.0/AnthologyLauncher.exe
rm 3DR_Anthology-1.0/3dr.ico
rm "3DR_Anthology-1.0/Duke Nukem 3D - EDuke32.bat"

echo "Removing unsupported game 'Duke Nukem - Manhattan Project'"
rm "3DR_Anthology-1.0/Duke Nukem Manhattan Project.bat"
rm -rf "3DR_Anthology-1.0/Duke Nukem - Manhattan Project"

echo "Generating OSX launchers:"

for d in 3DR_Anthology-1.0/*.bat; do
	# extract the name and directory from the bat file
	prettyname=$(echo $d | sed -e 's/\.bat//g' | sed -e 's/3DR_Anthology-1.0\///g')
	winconf=$(cat "$d" | grep "conf" | sed 's/.*\.\.\\//' | sed 's/\".*//' )
	windir=$(cat "$d" | grep "cd" | sed -e 's/cd //g' | sed -e 's/\\dosbox//g' | sed -e 's/\\Dosbox//g' | sed -e 's/\"//g' | tr -d '\r')
	# the windows dir is case insensitive, and someone at 3drealms didn't care to check the dir names
	# find the case sensitive folder name	
	dir=$(find 3DR_Anthology-1.0 -type d -maxdepth 1 | grep -i "$windir" | sed -e 's/3DR_Anthology-1.0\///g' )	
	conf=$(find 3DR_Anthology-1.0 -type f -maxdepth 2 | grep -i "$reldir/$winconf" | sed -e 's/3DR_Anthology-1.0\/'"$dir"'\///g' )

	# Create launchers
	launcher="3DR_Anthology-1.0/$prettyname.command"	
	echo "#!/usr/bin/env bash" > "$launcher"
	echo "# cd to script folder" >> "$launcher"
	echo "cd \"\$( dirname \"\${BASH_SOURCE[0]}\" )\" && pwd" >> "$launcher"
	echo "# Generate tmp subdir to support dosbox relative config file locaiton loading" >> "$launcher"
	echo "mkdir \"$dir/tmp\"" >> "$launcher"
	echo "cd \"$dir/tmp\"" >> "$launcher"
	echo "\"$dosbox\" -conf \"../$conf\" -noconsole -c &" >> "$launcher"
	echo "cd .." >> "$launcher"
	echo "rmdir tmp" >> "$launcher"
	echo "osascript -e 'tell application \"Terminal\" to close (every window whose name contains \"$prettyname.command\")' &" >> "$launcher"
	echo "exit" >> "$launcher"
	
	chmod +x "$launcher"

	echo "  $prettyname"	
done

echo "Removing Windows launchers"
rm 3DR_Anthology-1.0/*.bat

echo "Moving final folder"
mv 3DR_Anthology-1.0 "3D Realms Anthology OSX"

echo "All done. Double click a .command file to start game!"