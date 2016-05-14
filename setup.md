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
The setup of the ssh connection can be broken down to two parts:

1. Install openssh

	```
	sudo apt-get install openssh-server openssh-client
	```
2.  Establish a virtual connection between the windows host and the linux guest
	
	(screenshots)

3. Connect via ssh
	
	Use the following command (in windows & cmder) to connect:
	```
	ssh user@192.168.56.1 -p 4022
	```
	
	> The authenticity of host '[192.168.56.1]:4022 ([192.168.56.1]:4022)' can't be established.
		
	> ECDSA key fingerprint is SHA256:VdtF0c7Ptik3rGZMXAqjH+OFocq9Kj2NIdYXh7QEYvE.
	
	> Are you sure you want to continue connecting (yes/no)? yes
	
	> Warning: Permanently added '[192.168.56.1]:4022' (ECDSA) to the list of known hosts. user@192.168.56.1's password:
		
	> Welcome to Ubuntu 14.04.4 LTS (GNU/Linux 3.13.0-86-generic x86_64)
	
	> * Documentation:  https://help.ubuntu.com/
	
	> Last login: Sat May 14 14:31:09 2016
	
	> user@minilinux:~$

### Install VirtualBox Guest Additions
1. Start VM
2. Install Guest Additions
	
	```
	sudo apt-get install virtualbox-guest-utils
	```

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

### Connect to the VM without password
1. Create a ssh-key

	I do not want to use my main ssh-key for this purpose, as it is password-protected (which you should do too).
	Therefore I will create a second ssh-key without password protection that will only be used to connect to the VM.
	Remember to specify a location to save the key.
	Otherwise it will overwrite your existing one!
	Then leave the passphrase empty.
	
	```
	ssh-keygen
	```
	> Enter file in which to save the key (/c/Users/MyUser/.ssh/id_rsa): C:\Users\MyUser\.ssh\id_rsa_minilinux
	
	> Enter passphrase (empty for no passphrase):
	
	
1. Enter the ".ssh" directory of your windows machine

	```
	cd /c/Users/MyUser/.ssh
	```
2. Copy the public key to the VM

	```
	ssh-copy-id -i id_rsa_minilinux.pub localhost
	```
	
3.  Disable GSSAPIAuthentication

	Authenticating with the public key took up to 15 seconds for me. After I disabled GSSAPIAuthentication with the following command, connecting worked in under a second!

	```
	echo "GSSAPIAuthentication no" > config
	```

4. Try connecting via ssh

	On Windows:
	
	```
	ssh user@192.168.56.1 -p 4022 -i C:\Users\MyUser\.ssh\id_rsa_minilinux
	```

## Use a batch script to control the VM easily
[Download the script](linux.bat) and [the config file](config.bat) and add the folder they reside in to your windows PATH variable, in order to access it with "linux" anywhere.
Instead of only downloading the scripts seperately, you can also clone the entire MiniLinux repository to get eventual updates.
