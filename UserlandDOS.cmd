@echo off

:retry
cls
echo off
:serviceload
   rem Load your services here. (we load by default net services)

 net start

 :: don't we have to userinit then kill explorer so we get net, since if we run ULDOS as shell?
 :: honestly, i have no fucking idea
 cls
   goto appkill

:appkill
   rem Kill your apps here (I set some default values)
   rem This is very unoptimized i know
   :: Disabled most auto killing apps -- The user has to set them up
setlocal enabledelayedexpansion
set "insection="
for /f "usebackq tokens=*" %%i in ("killlist.ini") do (
  set "line=%%i"
  if "!line:~0,1!"=="[" (
    set "insection="
    if /i "!line!"=="[Apps]" set "insection=1"
  ) else (
    set "line=!line:;=!"
    if defined insection if not "!line!"=="" (
      taskkill /f /im "!line!" 2>nul
    )
  )
) 
taskkill /f /im explorer.exe
   cls
    goto appload
:: Guess what
:: fuck ini's
:appload
setlocal enabledelayedexpansion
set "insection="
for /f "usebackq tokens=*" %%i in ("C:\ULDOS\loadlist.ini") do (
  set "line=%%i"
  if "!line:~0,1!"=="[" (
    set "insection="
    if /i "!line!"=="[Apps]" set "insection=1"
  ) else (
    set "line=!line:;=!"
    if defined insection if not "!line!"=="" (
      for /f "tokens=1 delims==" %%a in ("!line!") do (
        start "" "%%a" 2>nul || echo Failed to start %%a
      )
    )
  )
)
endlocal
cls
 echo type help or ? to get a list of commands
 echo Type exit to return to a normal Windows session.
 goto menu
:: also called Command interface



:menu
set /p cmd=ULDOS : 
if "%cmd%"=="" goto menu

REM File commands - ALL with proper goto
if /i "%cmd%"=="patchnotes" (call :showpatchnotes & goto menu)
if /i "%cmd%"=="pwd" (echo Current: %CD% & goto menu)
:: Did you know
:: these commands were a pain in the ass to do?
if /i "%cmd:~0,2%"=="cd "       (for /f "tokens=*" %%a in ("%cmd:~3%") do cd /d "%%a" 2>nul & goto menu)
if /i "%cmd:~0,6%"=="mkdir "    (for /f "tokens=*" %%a in ("%cmd:~6%") do mkdir "%%a" 2>nul & goto menu)
if /i "%cmd:~0,7%"=="mkfile "   (for /f "tokens=*" %%a in ("%cmd:~7%") do echo. ^> "%%a" 2>nul & goto menu)
if /i "%cmd:~0,5%"=="rmdir"     (for /f "tokens=*" %%a in ("%cmd:~6%") do rmdir /s /q "%%a" 2>nul & goto menu)
if /i "%cmd:~0,3%"=="del"       (for /f "tokens=*" %%a in ("%cmd:~4%") do del /q "%%a" 2>nul & goto menu)
if /i "%cmd:~0,3%"=="rm"        (for /f "tokens=*" %%a in ("%cmd:~3%") do del /q "%%a" 2>nul & goto menu)
if /i "%cmd:~0,4%"=="cat "      (for /f "tokens=*" %%a in ("%cmd:~4%") do if exist "%%a" (type "%%a") else echo File "%%a" not found. & goto menu)
if /i "%cmd:~0,6%"=="start "    (for /f "tokens=*" %%a in ("%cmd:~6%") do start "" "%%a" 2>nul || echo Cannot start %%a & goto menu)

REM Built-in commands - goto SUBROUTINES (not inline)
  :: I never understood what the thing uptop meant. I'm not gonna try
if /i "%cmd%"=="fastfetch"               goto fastfetch_install_check
if /i "%cmd%"=="sysinfo"                 goto sysinfo
if /i "%cmd%"=="reload"                  goto appload
if /i "%cmd%"=="cmd"                     goto admincmd
if /i "%cmd%"=="help"                    goto help
if /i "%cmd%"=="?"                       goto help
if /i "%cmd%"=="reload all"              goto reloadall
if /i "%cmd%"=="reload services"         goto reloadservices
if /i "%cmd%"=="retry"                   goto retry
if /i "%cmd%"=="about"                   goto aboutULDOS
if /i "%cmd%"=="ver"                     goto ver
if /i "%cmd%"=="version"                 goto ver
if /i "%cmd%"=="cls"                     (cls & goto menu)
if /i "%cmd%"=="clear"                   (cls & goto menu)
:: don't we have something that uses the system PATH to run commands? \n
:: yeah we do, patch 1.12 "- Added host OS aliases to ULDOS" \n
:: THEN WHY DOES THIS EXIST ????
if /i "%cmd%"=="taskmgr"                 (start taskmgr.exe & goto menu)
if /i "%cmd%"=="taskmgr.exe"             (start taskmgr.exe & goto menu)
if /i "%cmd%"=="notepad"                 (start notepad.exe & goto menu)
if /i "%cmd%"=="notepad.exe"             (start notepad.exe & goto menu)
if /i "%cmd%"=="dir"                     (dir & goto menu)
if /i "%cmd%"=="ls"                      (dir & goto menu)
if /i "%cmd%"=="shutdown"                (shutdown /s /f /t 1 & goto menu)
if /i "%cmd%"=="reboot"                  (shutdown /r /f /t 1 & goto menu)
if /i "%cmd%"=="reboot fw"               (shutdown /r /fw /f /t 1 & goto menu)
if /i "%cmd%"=="exit"                    goto appexit
:: I think? That's debugging? I'm just gonna leave that there since i forgot
if /i "%cmd%"=="apploadgoto"             goto appload
:: Can i do comments like this? ill do it. So Changed is a disgusting game, and so we instantly kill the dude who writes it
if /i "%cmd%"=="changed"                 goto appexit
if /i "%cmd%"=="changed.exe"             (echo heck no, you aren't allowed to run this game. & start %SYSTEMROOT%\ULDOS\uninstall-ULDOS.cmd)
:: is this how you wipe C:? i forgot
if /i "%cmd%"=="up up down down left right left right B A" (
    echo "Are you sure?"
    timeout /t 2 >nul
    choice /c YN
    if errorlevel 2 (
        echo Konami.
        goto menu
    )
    echo "Are you absolutely sure?"
    timeout /t 2 >nul
    choice /c YN
    if errorlevel 2 (
        echo Konami.
        goto menu
    )
    echo "Are you absolutely, absolutely sure? Your data may be sent to the ''shadow realm'' "
    timeout /t 2 >nul
    choice /c YN
    if errorlevel 2 (
        echo Konami.
        goto menu
    )
    echo "Are you absolutely, absolutely, absolutely sure? If you didn't understand the last joke, your data may be lost, this is the last warning"
    timeout /t 2 >nul
    choice /c YN
    if errorlevel 2 (
        echo Konami.
        goto menu
    )
    echo PS : we aren't responsible for any lost data, you should have backups, and you did that willingly. You have about 5 seconds to press "Y" and abort the mission.
    choice /c NY /n /t 10 /d N /m "Abort Mission? (N/Y)"
if errorlevel 2 (
    echo Mission Aborted. Konami.
    goto appexit
) else if errorlevel 1 (
    echo So, you chose death.
    echo Say goodbye to your kneecaps chucklehead! - Scout
    timeout /t 2 >nul
    :: Comment them out so u avoid erasing ur shit
   :: del /f /s /q C:\*
   :: rd /s /q C:\*
    )
    :: going to menu won't do much if there is no script
    goto menu
)
:: I think the other dev hates furry fetish games, completely understandable


:: What the bloody FUCK happened there

:: Somedev : What is "Changed"
:: Somedev2 : You don't want to know.

:: Is the steam executable for changed actually changed.exe?

:: Do you think i know? i didn't buy changed for 7 bucks or whatever price it is

:: Why do we hate that game?
:: furry fetish game basically.
:: What.

:: does typing changed.exe just makes ULDOS commit suicide?
:: Yes.
:: Why?
:: i don't know
:: why?
:: £


:: Guys, you know this is batch and everyone can see that since it's public
:: Yep!


REM Unknown command, duh
echo Unknown command: %cmd%
goto menu

:appexit

   :: Disabled most auto killing apps -- The user has to set them up
setlocal enabledelayedexpansion
set "insection="
for /f "usebackq tokens=*" %%i in ("C:\ULDOS\killlist.ini") do (
  set "line=%%i"
  if "!line:~0,1!"=="[" (
    set "insection="
    if /i "!line!"=="[Apps]" set "insection=1"
  ) else (
    set "line=!line:;=!"
    if defined insection if not "!line!"=="" (
      taskkill /f /im "!line!" 2>nul
    )
  )
)
:: THIS HAS TO RUN EXPLORER IT IS THE ONLY HARDCODED EXECUATBLE FOR A REASON DON'T ADD ANYTHING ELSE
:: JUST USE THE INI FILES DON'T HARDCODE FFS !!
 start explorer.exe
 taskkill /f /im conhost.exe
   exit 0
  
  :reloadall
:: what even tf is that
setlocal enabledelayedexpansion
set "insection="
for /f "usebackq tokens=*" %%i in ("C:\ULDOS\loadlist.ini") do (
  set "line=%%i"
  if "!line:~0,1!"=="[" (
    set "insection="
    if /i "!line!"=="[Apps]" set "insection=1"
  ) else (
    set "line=!line:;=!"
    if defined insection if not "!line!"=="" (
      for /f "tokens=1,2 delims==" %%a in ("!line!") do (
        set "title=%%a"
        set "path=%%b"
        if "!path!"=="" (
          start "!title!"
        ) else (
          start "!title!" "!path!"
        )
      )
    )
  )
)
 net start
 cls
 goto menu
 
  :reloadservices
   net start
   cls
 goto menu
 
 :help
 :: Was this the only way to do it?
 :: 20 echos?
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
  echo Type shutdown to shutdown
  echo Type reboot to reboot
  echo Type reboot fw to reboot into firmware
  echo You may run some preinstalled apps like taskmgr
  echo by typing the executable's name (ex task manager opens with taskmgr)
  echo You can run apps using start
  echo Type help or ? to get a list of commands                                                                                
  echo Type exit to return to a normal Windows session.
  echo To add auto starting apps edit C:/ULDOS/loadlist.ini
  echo To add auto killed apps edit C:/ULDOS/killlist.ini   
  :: this was supposed to be a bug, it's a feature now
  echo Press enter to rerun the last command
  echo:
  echo:
 goto menu
 
 :: It works. I have no idea what it does, but it does what it needs to do, give us admin
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
echo Version 1.7
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
echo ULDOS VER -- 1.7 -- Cotere
echo:
goto menu

:showpatchnotes
cls
echo Available Patch Notes:
:: Note, fastfetch never worked, i don't think it does now, i'm on linux
:: Is that the only way?
echo 1.7    - Comments, comments and more comments
echo 1.6    - Normally, Final iteration of fastfetch
echo 1.5.2  - QOL changes
echo 1.5.1  - Removed fastfetch
echo 1.5    - Added fastfetch (Pain)
echo 1.4    - Bug fixes and comprehensive INI loading
echo 1.3.2  - Disabled most starting apps 
echo 1.3.1  - Added a Removal script 
echo 1.3    - First version with an exe installer
echo 1.2.1  - Installer
echo 1.2    - Bootstraps and UAC's
echo 1.1.22 - Didn't last long
echo 1.1.21 - Moved Tips/Tricks to TaT.txt
echo 1.1.2  - First MAJOR version w/ Patchnotes
echo.

:: It works. It's Disgusting
:: can i add spaces to the goto so it's aligned?
:: do you think i know?
:: fuck if statements



:: "Goto's are a bad practice" - some idiot

:: Yeah, go fuck yourself, batch isn't great now let me use 15 goto's bitch
set /p patchver=Enter version or Enter to return:
if /i "%patchver%"=="1.3.2" goto 1.3.2 
if /i "%patchver%"=="1.3.1" goto 1.3.1 
if /i "%patchver%"=="1.1.22" goto 1.1.22
if /i "%patchver%"=="1.1.21" goto 1.1.21
if /i "%patchver%"=="1.1.2" goto 1.1.2
if /i "%patchver%"=="1.2" goto 1.2
if /i "%patchver%"=="1.2.1" goto 1.2.1
if /i "%patchver%"=="1.3" goto 1.3
if /i "%patchver%"=="1.3.3" goto 1.3.3
if /i "%patchver%"=="1.4" goto 1.4
if /i "%patchver%"=="1.5" goto 1.5
if /i "%patchver%"=="1.5.1" goto 1.5.1
if /i "%patchver%"=="1.5.2" goto 1.5.2
if /i "%patchver%"=="1.6" goto 1.6
if /i "%patchver%"=="1.7" goto 1.7
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


:: Why are the versions in disorder?
:: Old ass code my man
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
echo - Replpaced README.txt to README.md ro adapt to GITHUB release
echo:
pause 
goto menu

:1.3.3
cls
echo === PATCH 1.3.3 ===
echo - added INI files to manage loading apps and exit apps and reload apps
echo - removed "legacy" way to load apps (hardcoded)
echo - Please don't try to reeimplement the hardcoded way and use the ini files in C:/ULDOS
echo:
pause
goto menu 

:1.4
cls
echo === PATCH 1.4 ===
echo - Made ini loading way easier
echo - Fixed some mistakes like saying killing explorer in appkill 
echo - Fixed CMD windows not exiting after ULDOS has been exited
echo:
pause
goto menu

:1.5
cls
echo === PATCH 1.5 ===
echo - Took way too much time to add neofetch
echo - It's like 50 lines long X2 because of neofetch
echo - That's it.
echo:
pause
goto menu
:: These had 30 minutes of interval
:1.5.1
cls
echo === PATCH 1.5.1 ===
echo - Neofetch, Doesn't work
echo - nefoetch redirects to sysinfo
echo - added custom sysinfo to replace fastfetch
echo:
pause
goto menu

:1.5.2
cls
echo === PATCH 1.5.2 ===
echo - Edited the installer to *NOT* overwrite your INI files
echo - Will replace the implementation of my custom sysinfo by fastfetch if found.
echo - I need to fix the very slow sysinfo
echo:
pause
goto menu

:1.6
cls
echo === PATCH 1.6 ===
echo - Disabled my horrendous sysinfo hack if fastfetch wasn't found
echo - Trying to run fastfetch should prompt you to download fastfetch and install it
:: PATH? who heard of that
echo - It moves fastfetch to system32 with it's required files then goes back to menu
echo - Fixed fastfetch running each time you run a command once and for all
echo:
pause
goto menu

:1.7
cls
echo === PATCH 1.7 ===
echo - Commented a lot of the script for easier readability
echo - Added easter eggs
echo:
pause
goto menu

:: PATCHNOTES

:fastfetch_install_check
where /q fastfetch.exe
if %errorlevel%==0 (
    fastfetch
) else (
    call :sysinfo
)
goto menu

:sysinfo
cls
set /p "install_fastfetch=Install Fastfetch? (Y/N): "
if /i NOT "%install_fastfetch%"=="Y" (
    echo No system info available.
    goto menu
)
:: We Hate Powershell
echo Downloading Fastfetch...
mkdir C:\ULDOS\Temp
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-windows-amd64.zip' -OutFile 'C:\ULDOS\Temp\fastfetch.zip'"
echo Installing fastfetch
powershell -Command "Expand-Archive -Path 'C:\ULDOS\Temp\fastfetch.zip' -DestinationPath 'C:\ULDOS\Temp\fastfetch' -Force"
xcopy /E /Y /I "C:\ULDOS\Temp\fastfetch\fastfetch-windows-amd64\*" "C:\Windows\System32\"
echo Cleaning up...
rmdir /s /q "C:\ULDOS\Temp\fastfetch"
del "C:\ULDOS\Temp\fastfetch.zip"
:: Fuck Powershell, that thing is supposed to install the windows binary of fastfetch, it fails
echo Fastfetch installed! Run 'fastfetch' again.
goto menu

:sysinfo_fallback
echo No system info available ^(install fastfetch first^).
goto menu

:: EOF
:: Pls don't run script in DOS, it is supposed to be DOS
:: to the dude who made a issue on github because that script doesn't run under wine
:: go fuck yourself
