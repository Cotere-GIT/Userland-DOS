:: UnInstall for ULDOS
:: Start of our UAC elevation script
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:: end of our UAC elevation script
cls
@echo off
echo After pressing enter, ULDOS will be fully removed from your system.
echo To cancel uninstallation, close this window or do CTRL+C
echo If you have set your shell to ULDOS; restore it to explorer.exe before removing it,
echo or you WILL have issues.
echo:
echo If your system gets damaged from the removal of ULDOS; i do not take responsibility,
echo You chose to install ULDOS, you chose to remove it, You chose to use it.
echo ULDOS - By Cotere
echo:
echo PS : Please do not run the uninstall script inside ULDOS, or you'll need to log out and back in.
echo Or find a way to reload explorer.
pause
rmdir /Q /S C:\ULDOS
del /F /Q C:\Windows\System32\dos.cmd
echo ULDOS has been successfully removed. The dos alias has been removed too.
echo Thank you for using ULDOS.
echo Press enter to quit.

setlocal

set /A "count=0"
set /p "count=" < C:/Windows/System32/ULDOSInstalls.count 2>nul

set /A "count+=1"
echo %count% > C:/Windows/System32/ULDOSInstalls.count

pause
exit 0
