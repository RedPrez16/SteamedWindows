@echo off 
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
echo Installing drivers for the Steam Deck and putting the Steam Big Picture Mode script in place. 

curl https://redprez.com/Downloads/SteamDeck/SteamDeckDrivers.zip --output %USERPROFILE%\Desktop\SteamDeckDrivers.zip
::Download and place StartSteamBigPictureMode.bat to the startup folder. 
curl https://redprez.com/Downloads/SteamDeck/StartSteamBigPictureMode.bat --output %USERPROFILE%\Desktop\StartSteamPictureMode.bat
move %USERPROFILE%\Desktop\StartSteamPictureMode.bat "%AppData%\Microsoft\Windows\Start Menu\Programs\Startup"

::Curl the Steam installer and run it in a bit. 
curl https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe --output %USERPROFILE%\Desktop\SteamSetup.exe


mkdir %USERPROFILE%\Desktop\SteamDeckDrivers
tar -xvf %USERPROFILE%\Desktop\SteamDeckDrivers.zip -C %USERPROFILE%\Desktop\SteamDeckDrivers
cd %USERPROFILE%\Desktop\SteamDeckDrivers

pnputil /add-driver cs35l41.inf
pnputil /add-driver NAU88L21.inf

::Install the Steam Client and remove the installer. 

%USERPROFILE%\Desktop\SteamSetup.exe /S

del %USERPROFILE%\Desktop\SteamSetup.exe 

Setup.exe -install 
setupBayHub.exe /S/v/qn
setupWLAN.exe /S/v/qn
InstallDriver.cmd
pnputil /add-driver netrtwlane.inf



::Clean up all files and folders

rmdir /s /q SteamDeckDrivers
del SteamDeckDrivers.zip

shutdown -r 

pause