@echo off
title Install Windows without USB


echo Enter full path for iso.
set /p a=
	goto :extract
	
	
:extract
cls

echo %a%

PowerShell Mount-DiskImage -ImagePath "%a%"
echo New Drive appeared on your pc, which drive letter it have? (Drive named with your iso name. example - A).
set /p s=
	
	echo Type Drive Letter for Windows which you created before (You can't select your partition with already installed Windows).
	set /p d=
		IF EXIST "%s%:\sources\install.wim" DISM /Apply-Image /ImageFile:%s%:\sources\install.wim /Index:1 /ApplyDir:%d%:\
		IF EXIST "%s%:\sources\install.esd" DISM /Apply-Image /ImageFile:%s%:\sources\install.esd /Index:1 /ApplyDir:%d%:\
		bcdboot %d%:\Windows
	
		PowerShell Dismount-DiskImage -ImagePath "%a%"
		
	echo Done. Reboot your pc to access your new Windows.
pause
cls
