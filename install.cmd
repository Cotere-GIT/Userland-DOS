:: Install for ULDOS
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
:: Clear everything before working

copy /Y UserlandDOS.cmd C:\ULDOS
copy /Y TaT.txt C:\ULDOS 
copy /Y DOS.cmd C:\Windows\System32
copy /Y README.txt C:\ULDOS
copy /Y uninstall-ULDOS.cmd C:\ULDOS
start notepad C:\ULDOS\TaT.txt
echo !! PLEASE READ TAT.TXT CAREFULLY !!
echo Installed ULDOS, use dos in CMD to run