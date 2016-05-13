# MiniLinux setup guide

## Install necessary programs
To make MiniLinux work, these programs are important:

### [VirtualBox](https://www.virtualbox.org/)
VirtualBox will emulate a computer (=virtual machine) running a linux operating system, that will run the beloved linux based console applications.

### [cmder](http://cmder.net/)
Cmder is a console emulator for windows.
It provides a neat looking console that is in many ways (shortcuts, ...) superior to the default windows command-line (cmd).
It comes in two flavours of which i preffer the full version that comes with built in tools like git, ssh and many more.

### ssh
The full version of cmder comes with ssh, therefore have not felt the need to install it seperately.

## Create the virtual machine
The VM is the core of MiniLinux as it is what really executes the linux command line applications.

### Install the operating system
To use as little system resources as possible, I chose to use the [minimal version of Ubuntu](https://help.ubuntu.com/community/Installation/MinimalCD) as operating system on the VM.

### Setup a ssh connection

### Install VirtualBox Guest Additions
1. Start VM
2. sudo apt-get install virtualbox-guest-utils

### Access hard drive from within the VM
1. Create Shared Folder
	1. Open VirtualBox Manager
	2. rightclick MiniLinux > Settings
	3. Shared Folders tab
	4. Add new shared folder
	5. Add share > Folder Path: "C:\"
	6. Add share > Folder Name: "C_Drive"
	7. Add share > Ok
	8. MiniLinux Settings > Ok
2. Start VM
3. Mount Shared Folder
	1. Create folder where the shared folder should be mounted
		```
		mkdir /c
		```
	2. Mount shared folder
	
		```
		sudo mount -t vboxsf -o rw,uid=1000,gid=1000 C_DRIVE /c
		```
	3. Check whether mount worked
		1. Enter the folder
		
			```
			cd /c
			```
		2. Create a folder
		
			```
			mkdir MiniLinuxTest
			```
		3. Check if the folder was created
		
			```
			ls -la
			```
		4. Remove the folder: 
		
			```
			rmdir MiniLinuxTest
			```
	4. Automatically mount the folder at startup
	
		add the following command to "/etc/rc.local"
		```
		sudo mount -t vboxsf -o rw,uid=1000,gid=1000 C_DRIVE /c
		```
	5. Restart the VM
	6. Repeat 3.3

## Use a [batch script](linux.bat) to control the VM easily
[Download the script](linux.bat) and add the folder it resides in to your windows PATH variable, in order to access it with "linux" anywhere.
Instead of only downloading the script itself, you could also clone the entire MiniLinux repository to get eventual updates.