@echo off


:retry
cls
echo off
:serviceload
   rem Load your services here. (we load by default net services)
   rem also don,'t forget to add them to reloadservices
 net start
 cls
   goto appkill

:appkill
   rem Kill your apps here (I set some default values)
   rem This is very unoptimized i know
   :: Disabled most auto killing apps -- The user has to set them up
 taskkill -f -im explorer.exe
:: taskkill -f -im firefox.exe
:: taskkill -f -im discord.exe
:: taskkill -f -im foobar2000.exe
:: taskkill -f -im vlc.exe
:: taskkill -f -im 7zFM.exe
:: taskkill -f -im taskmgr.exe
:: taskkill -f -im regedit.exe
:: taskkill -f -im notepad.exe
:: taskkill -f -im notepad++.exe
:: taskkill -f -im steam.exe
   cls
    goto appload

:appload
   rem Load apps here.
   rem also don,'t forget to add them to reloadall
 start conhost.exe
 start taskmgr.exe
 start notepad.exe
   rem This is just where i store my apps A: HD ; for you it's probably in C:/
   :: The user has to set them up.
 :: start "Foobar2000 -- UserlandDOS" "A:/Program Files/foobar2000/foobar2000.exe"
 :: start "Notepad++ -- UserlandDOS" "A:/Program Files/Notepad++/notepad++.exe"
 :: start "Mozilla Firefox -- UserlandDOS" "C:\Program Files\Mozilla Firefox\firefox.exe"
 taskkill cmd.exe
 cls
 echo type help or ? to get a list of commands
 echo Type exit to return to a normal Windows session.
 goto menu
:: also called Command interface
:menu
set /p cmd=ULDOS : 
if /i "%cmd%"=="patchnotes" call :showpatchnotes
if "%cmd%"=="" goto menu

if /i "%cmd%"=="pwd" (
    echo Current: %CD%
    goto menu
)
:: WTF have i done here???
if /i "%cmd:~0,2%"=="cd" (
    for /f "tokens=*" %%a in ("%cmd:~2%") do cd /d "%%a" 2>nul
)
if /i "%cmd:~0,6%"=="mkdir " (
    for /f "tokens=*" %%a in ("%cmd:~6%") do mkdir "%%a" 2>nul
)
if /i "%cmd:~0,7%"=="mkfile " (
    for /f "tokens=*" %%a in ("%cmd:~7%") do echo. > "%%a" 2>nul
)
if /i "%cmd:~0,5%"=="rmdir" (
    for /f "tokens=*" %%a in ("%cmd:~5%") do rmdir /s /q "%%a" 2>nul
)
if /i "%cmd:~0,3%"=="del" (
    for /f "tokens=*" %%a in ("%cmd:~3%") do del /q "%%a" 2>nul
)
if /i "%cmd:~0,3%"=="rm" (
    for /f "tokens=*" %%a in ("%cmd:~3%") do del /q "%%a" 2>nul
)
:: The worse is that it works

if /i "%cmd:~0,4%"=="cat " (
    for /f "tokens=*" %%a in ("%cmd:~4%") do (
        if exist "%%a" (
            type "%%a"
        ) else (
            echo File "%%a" not found.
        )
    )
    goto menu
)
if /i "%cmd:~0,6%"=="start " (
    for /f "tokens=*" %%a in ("%cmd:~6%") do start "" "%%a" 2>nul || echo Cannot start %%a
    goto menu
)
if /i "%cmd%"=="patchnotes" call :showpatchnotes & goto menu
 if /i "%cmd%"=="exit" goto appexit
 if /i "%cmd%"=="reload" goto appload
 if /i "%cmd%"=="cmd" goto admincmd
 if /i "%cmd%"=="help" goto help
 if /i "%cmd%"=="?" goto help
 if /i "%cmd%"=="reload all" goto reloadall
 if /i "%cmd%"=="reload services" goto reloadservices
 if /i "%cmd%"=="retry" goto retry
 if /i "%cmd%"=="about" goto aboutULDOS
 if /i "%cmd%"=="ver" goto ver 
 if /i "%cmd%"=="version" goto ver  
 if /i "%cmd%"=="cls" cls
 if /i "%cmd%"=="clear" cls
 if /i "%cmd%"=="taskmgr" start taskmgr
 if /i "%cmd%"=="taskmgr.exe" start taskmgr 
 if /i "%cmd%"=="notepad" start notepad
 if /i "%cmd%"=="notepad.exe" start notepad
 if /i "%cmd%"=="iexplore" start iexplore
 if /i "%cmd%"=="iexplore.exe" start iexplore
 if /i "%cmd%"=="dir" dir
 if /i "%cmd%"=="ls" dir
 :: They don't work, and i have no idea on how to fix that 
if /i "%cmd%"=="shutdown" shutdown /s /f /t 1
if /i "%cmd%"=="reboot" shutdown /r /f /t 1
if /i "%cmd%"=="reboot fw" shutdown /r /fw /f /t 1

goto menu

:appexit

 taskkill -f -im taskmgr.exe
 taskkill -f -im notepad.exe
 taskkill -f -im firefox.exe
 taskkill -f -im notepad++.exe
 taskkill -f -im foobar2000.exe
 taskkill -f -im taskmgr.exe
   rem This is the last thing that we kill !!
 start explorer.exe
  taskkill -f -im conhost.exe
   exit 0
  
  :reloadall
   start conhost.exe
 start taskmgr.exe
 start notepad.exe
 :: The user has to set them up.
 :: Most application will not be on A:/ | I have a custom letter and my apps are installed on A:/
 :: start "Foobar2000 -- UserlandDOS" "A:/Program Files/foobar2000/foobar2000.exe"
 :: start "Notepad++ -- UserlandDOS" "A:/Program Files/Notepad++/notepad++.exe"
 :: start "Mozilla Firefox -- UserlandDOS" "C:\Program Files\Mozilla Firefox\firefox.exe"
 net start
 cls
 goto menu
 
  :reloadservices
   net start
   cls
 goto menu
 
 :help
  echo:
  echo Patch Notes are available by typing patchnotes
  echo Type cmd to open a new cmd prompt.
  echo Type reload to reload all apps.
  echo Type reload all to reload apps and services
  echo Type reload services to reload services
  echo Type about to get information about the build
  echo Type version to get Version information
  echo Type retry to rerun the script
  echo Type cls to clear screen
  echo Type shutdown to shutdown reboot to reboot and reboot fw to reboot into firmware
  echo You may run some preinstalled apps like taskmgr
  echo by typing the executable's name (ex task manager opens with taskmgr)
  echo You can run apps using start
  echo Type help or ? to get a list of commands                                                                                
  echo Type exit to return to a normal Windows session.
  :: this was supposed to be a bug, it's a feature now
  echo Press enter to rerun the last command
  echo:
  echo:
 goto menu
 
:admincmd
 REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt2
) else ( goto gotAdmin2 )

	:UACPrompt2
		echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
		set params = %*:"="
		echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

		"%temp%\getadmin.vbs"
		del "%temp%\getadmin.vbs"
		exit /B
	:gotAdmin2
		pushd "%CD%"
		CD /D "%~dp0"
cls
start cmd.exe
goto menu

:aboutULDOS
cls
echo ULDOS -- Made by Cotere
echo Version 1.3.1
echo:
echo:
echo ULDOS is a utility to run Windows without an explorer (Like going back to older days)
echo ULDOS needs admin priviliege to run some of it's apps; but ULDOS is free sofware
echo ...Aslong as you credit me.
echo:
echo:
echo Build created on Windows 10 == No UWP apps installed
echo Are you using a Entrprise build?
echo Version Built on : Windows 10 LTSC Enterprise S 
echo:
echo:

goto menu

:ver
echo ULDOS VER -- 1.3.1 -- Cotere
echo:
goto menu

:showpatchnotes
cls
echo Available Patch Notes:
echo 1.3.2  - Disabled most starting apps 
echo 1.3.1  - Added a Removal script 
echo 1.3    - First version with an exe installer
echo 1.2.1  - Installer
echo 1.2    - Bootstraps and UAC's
echo 1.1.22 - Didn't last long
echo 1.1.21 - Moved Tips/Tricks to TaT.txt
echo 1.1.2  - First MAJOR version w/ Patchnotes
echo.
set /p patchver=Enter version or Enter to return:
if /i "%patchver%"=="1.3.2" goto 1.3.2 
if /i "%patchver%"=="1.3.1" goto 1.3.1 
if /i "%patchver%"=="1.1.22" goto 1.1.22
if /i "%patchver%"=="1.1.21" goto 1.1.21
if /i "%patchver%"=="1.1.2" goto 1.1.2
if /i "%patchver%"=="1.2" goto 1.2
if /i "%patchver%"=="1.2.1" goto 1.2.1
if /i "%patchver%"=="1.3" goto 1.3
goto menu

:: PatchNotes
:1.2
cls
echo === PATCH 1.2 ===
echo - Added BootStrap script (Needs to be in a PATH Folder or in C:/Windows/System32)
echo - Removed AutoUAC in The main CMD file; it is now handled by DOS.CMD
echo - Information AutoUAC for CMD still exists
echo:
pause
goto menu
:1.1.22
cls
echo === PATCH 1.122 ===
echo - Addon to 1.121 - Main batch file is longer already
echo.
pause
goto menu

:1.1.21
cls
echo === PATCH 1.121 ===
echo - Moved Tips and Tricks to TaT.txt
echo - Reduced Filesize of main batch file
echo.
pause
goto menu

:1.1.2
cls
echo === PATCH 1.12 ===
echo - First MAJOR version to have Patchnotes
echo - Added commands: del rmdir mkdir mkfile cd
echo - Moved Tips and Tricks to Bottom of file
echo - Planned move to separate file
echo - Fixed some bugs
echo - Added ver, About, AutoUAC request
echo - Added host OS aliases to ULDOS
echo - Defined ULDOS: Userland DOS
echo.
pause
goto menu

:1.2.1
cls
echo === PATCH 1.2.1 ===
echo - Added a installer to deploy ULDOS with ease
echo - The installer moves DOS.cmd to C:/Windows/System32
echo - The installer moves UserlandDOS.cmd to C:/ULDOS/
echo:
pause
goto menu

:1.3
cls
echo === PATCH 1.3 ===
echo - Made the installer into a exe app
echo - Added a Readme
echo - TaT.txt is now copied to ULDOS install directory (C:/ULDOS)
echo:
pause
goto menu

:1.3.1
cls
echo === PATCH 1.3.1 ===
echo - Added a removal script in C:/ULDOS
echo - Added Warnings to README
echo - Added Warnings to uninstall-ULDOS.cmd
echo - Please do not run uninstall-ULDOS.cmd from ULDOS
echo - It WILL Break.
echo:
pause
goto menu

:1.3.2
cls
echo === PATCH 1.3.2 ===
echo - Disabled most starting apps (Were for debugging)
echo - First Release on Github
echo - First official Public release.
echo:
pause 
goto menu
:: PATCHNOTES