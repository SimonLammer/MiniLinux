@echo off
:: Variables
:: Please set these to the correct values
set vmname=MiniLinux
set vmuser=user
set vmip=192.168.56.1
set vmsshport=4022
set vboxmanage="C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
set defaultmode=help
set waittime=3

:: Main Program
setlocal EnableDelayedExpansion
set "mode="
set "vmstate="
set verbose=false
set pause=false
set first=true
set programname=%0
for %%a in (%*) do (
	if "!first!" == "true" (
		set first=false
		set mode=%%a
	) else (
		set option=%%a
		call :handle_short_option_versions
		call :set_option
	)
)
if "%mode%" == "" (
	set mode=%defaultmode%
)
call :handle_short_mode_versions
call :run_mode
exit /b 0

:: Functions
:full
	call :set_vmstate
	if "%verbose%" == "true" (echo Current vm state: %vmstate%)
	if %vmstate% == "poweroff" (
		call :start
	) else if %vmstate% == "paused" (
		call :resume
	)
	ping -n %waittime% localhost >NUL
	call :connect
	if "%pause%" == "true" (
		ping -n %waittime% localhost >NUL
		call :set_vmstate
		if "%verbose%" == "true" (echo Current vm state: %vmstate%)
		if %vmstate% == "running" (
				call :pause
		)
	)
exit /b 0

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
	) else if "%mode%" == "st" (
		set mode=state
		if "%verbose%" == "true" (echo Mode st extended to state)
	) else if "%mode%" == "s" (
		set mode=start
		if "%verbose%" == "true" (echo Mode s extended to start)
	)
exit /b 0

:run_mode
	if "%mode%" == "connect" (
		call :connect
	) else if "%mode%" == "full" (
		call :full
	) else if "%mode%" == "help" (
		call :help
	) else if "%mode%" == "pause" (
		call :pause
	) else if "%mode%" == "poweroff" (
		call :poweroff
	) else if "%mode%" == "reset" (
		call :reset
	) else if "%mode%" == "resume" (
		call :resume
	) else if "%mode%" == "shutdown" (
		call :shutdown
	) else if "%mode%" == "state" (
		call :state
	) else if "%mode%" == "start" (
		call :start
	) else (
		echo Mode '%mode%' invalid!
		call :help
	)
exit /b 0

:handle_short_option_versions
	if "%option%" == "p" (
		set option=pause
		if "%verbose%" == "true" (echo Option p extended to pause)
	) else if "%option%" == "v" (
		set option=verbose
		echo Option v extended to verbose
	)
exit /b 0

:set_option
	if "%option%" == "pause" (
		set pause=true
		if "%verbose%" == "true" (echo Option %option% set)
	) else if "%option%" == "verbose" (
		set verbose=true
		echo Option %option% set
	) else (
		echo Option '%option%' invalid
	)
exit /b 0

:help
	echo Usage: %programname% ^<Mode^> [Options]
	echo   %programname% ^<- this will use the defaults
	echo   %programname% (connect^|help^|pause^|poweroff^|reset^|resume^|shutdown^|start) [verbose]
	echo   %programname% full [verbose] [pause]
	echo.
	echo Modes (short version, long version, description):
	echo   c  connect  - Connect to the vm via ssh.
	echo   f  full     - Start / resume the vm, connect and pause the vm when this script finishes.
	echo   h  help     - Print this help dialog.
	echo   p  pause    - Pause the vm.
	echo   po poweroff - Forces vm-shutdown (by virtually pulling the power cable).
	echo   re reset    - Reset the vm (force shutdown and start).
	echo   r  resume   - Resume the vm from paused state.
	echo   sh shutdown - Gracefully shutdown the vm.
	echo   st state    - Prints current vm state
	echo   s  start    - Start the vm.
	echo.
	echo Options:
	echo   p  pause    - Pause the vm when it is running as the script finishes.
	echo   v  verbose  - Print every action.
exit /b 0

:state
	call :set_vmstate
	echo Current vm state: %vmstate%
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
	echo Connecting to the vm via ssh
	@echo on
	ssh %vmuser%@%vmip% -p %vmsshport%
	@echo off
exit /b 0

:set_vmstate
	set cmd=%vboxmanage% showvminfo %vmname% --machinereadable
	for /f "tokens=1* delims==" %%a in ('"%cmd%"') do if "%%a" == "VMState" (set vmstate=%%b)
exit /b 0
:: Functions vm-related <--