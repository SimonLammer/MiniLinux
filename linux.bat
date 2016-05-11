@echo off
:: Variables
:: Please set these to the correct values
set vmname=MiniLinux
set vmuser=user
set vmip=192.168.56.1
set vmsshport=4022
set vboxmanage="C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
set defaultmode=help

:: Main Program
set verbose=false
set nopause=false
set first=true
for %%a in (%*) do (
	if "%first%" == "true" (
		echo DEBUG %%a
		set first=false
		echo DEBUG fa: %first%
		set mode=%%a
	) else (
		set option=%%a
		call :handle_short_option_versions
		call :set_option
	)
)
call :handle_short_mode_versions
echo Errorlvl: %ERRORLEVEL%
exit /b 0

:: Functions
:handle_short_mode_versions
	if "%mode%" == "c" (
		set mode=connect
		if "%verbose%" == "true" (echo Mode c extended to connect)
	) else if "%mode%" == "f" (
		set mode=full
		if "%verbose%" == "true" (echo Mode f extended to full)
	) else if "%mode%" == "h" (
		set mode=help
		if "%verbose%" == "true" (echo Mode h extended to help)
	) else if "%mode%" == "p" (
		set mode=pause
		if "%verbose%" == "true" (echo Mode p extended to pause)
	) else if "%mode%" == "po" (
		set mode=poweroff
		if "%verbose%" == "true" (echo Mode po extended to poweroff)
	) else if "%mode%" == "re" (
		set mode=reset
		if "%verbose%" == "true" (echo Mode re extended to reset)
	) else if "%mode%" == "r" (
		set mode=resume
		if "%verbose%" == "true" (echo Mode r extended to resume)
	) else if "%mode%" == "sh" (
		set mode=shutdown
		if "%verbose%" == "true" (echo Mode sh extended to shutdown)
	) else if "%mode%" == "s" (
		set mode=start
		if "%verbose%" == "true" (echo Mode s extended to start)
	)
exit /b 0

:handle_short_option_versions
	if "%option%" == "n" (
		set option=nopause
		if "%verbose%" == "true" (echo Option n extended to nopause)
	) else if "%option%" == "v" (
		set option=verbose
		if "%verbose%" == "true" (echo Option v extended to verbose)
	)
exit /b 0

:set_option
	if "%option%" == "nopause" (
		set nopause=true
		if "%verbose%" == "true" (echo Option %option% set)
	) else if "%option%" == "verbose" (
		set verbose=true
		if "%verbose%" == "true" (echo Option %option% set)
	) else (
		echo Option '%option%' invalid
	)
exit /b 0

:print_help
	echo Usage: %0 <Mode> [Options]
	echo   %0 <- this will use the defaults
	echo   %0 (connect|help|pause|poweroff|reset|resume|shutdown|start) [verbose]
	echo   %0 full [nopause]
	echo
	echo Modes (short version, long version, description):
	echo   c  connect  - Connect to the vm via ssh.
	echo   f  full     - Start / resume the vm, connect and pause the vm when this script finishes.
	echo   h  help     - Print this help dialog.
	echo   p  pause    - Pause the vm.
	echo   po poweroff - Forces vm-shutdown (by virtually pulling the power cable).
	echo   re reset    - Reset the vm (force shutdown and start).
	echo   r  resume   - Resume the vm from paused state.
	echo   sh shutdown - Gracefully shutdown the vm.
	::TODO status
	echo   s  start    - Start the vm.
	echo
	echo Options:
	echo   n  nopause  - Do not pause the vm when the script finishes.
	echo   v  verbose  - Print every action.
exit /b 0

:: Functions vm-related -->
:start
	echo Starting the vm
	@echo on
	%vboxmanage% startvm %vmname% --type headless
	@echo off
exit /b 0

:poweroff
	echo Powering off the vm
	@echo on
	%vboxmanage% controlvm %vmname% poweroff
	@echo off
exit /b 0

:shutdown
	echo Shutting down the vm
	@echo on
	%vboxmanage% controlvm %vmname% acpipowerbutton 
	@echo off
exit /b 0

:reset
	echo Resetting the vm
	@echo on
	%vboxmanage% controlvm %vmname% reset
	@echo off
exit /b 0

:pause
	echo Pausing the vm
	@echo on
	%vboxmanage% controlvm %vmname% pause
	@echo off
exit /b 0

:resume
	echo Resuming the vm
	@echo on
	%vboxmanage% controlvm %vmname% resume
	@echo off
exit /b 0

:connect
	ssh %vmuser%@%vmip% -p %vmsshport%
exit /b 0

:set_vmstate
	set cmd=%vboxmanage% showvminfo %vmname% --machinereadable
	for /f "tokens=1* delims==" %%a in ('"%cmd%"') do if "%%a" == "VMState" (set vmstate=%%b)
exit /b 0
:: Functions vm-related <--