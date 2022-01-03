<# : Installation.bat
@echo off
pushd %~dp0
setlocal
title Install Windows without USB

:: CHECK FOR ADMIN PRIVILEGES
dism >nul 2>&1 || (echo This script must be Run as Administrator. && pause && exit /b 1)

if not exist 7z.exe echo 7Zip not found! Please download this repo as a .zip and try again. & pause & exit

echo Choose ISO to install:

for /f "delims=" %%I in ('powershell -noprofile "iex (${%~f0} | out-string)"') do (
	echo %%~I
    7z.exe x -y -oC:\WindowsInstallation "%%~I"
)
	cls
	echo Type Drive Letter for Windows which you created before (You can't select your partition with already installed Windows).
	set /p d=
	
		IF EXIST "C:\WindowsInstallation\autounattend.xml" (
			IF EXIST "C:\WindowsInstallation\sources\install.wim" DISM /Apply-Image /ImageFile:C:\WindowsInstallation\sources\install.wim /Apply-Unattend:C:\WindowsInstallation\autounattend.xml /Index:1 /ApplyDir:%d%:\
			IF EXIST "C:\WindowsInstallation\sources\install.esd" DISM /Apply-Image /ImageFile:C:\WindowsInstallation\sources\install.esd /Apply-Unattend:C:\WindowsInstallation\autounattend.xml /Index:1 /ApplyDir:%d%:\

		) ELSE (
			IF EXIST "C:\WindowsInstallation\sources\install.wim" DISM /Apply-Image /ImageFile:C:\WindowsInstallation\sources\install.wim /Index:1 /ApplyDir:%d%:\
			IF EXIST "C:\WindowsInstallation\sources\install.esd" DISM /Apply-Image /ImageFile:C:\WindowsInstallation\sources\install.esd /Index:1 /ApplyDir:%d%:\
		)
		if %ERRORLEVEL% neq 0 (
		echo "Error."
		timeout 2
		exit /b 1
		)
		
		move C:\WindowsInstallation\sources\$OEM$\$$\Setup\Scripts\*.* %d%:\Windows\Setup\Scripts >nul 2>&1
		move C:\WindowsInstallation\autounattend.xml %d%:\Windows\System32\Sysprep\unattend.xml >nul 2>&1
		bcdboot %d%:\Windows
	cls
	echo Done. Reboot your pc to access your new Windows.
	pause
	
goto :EOF
: end Batch portion / begin PowerShell hybrid chimera #>

Add-Type -AssemblyName System.Windows.Forms
$f = new-object Windows.Forms.OpenFileDialog
$f.InitialDirectory = pwd
$f.Filter = "Image Files (*.iso)|*.iso|All Files (*.*)|*.*"
$f.Multiselect = $false
[void]$f.ShowDialog()
$f.FileName
