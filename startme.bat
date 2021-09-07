@echo off
title Helper Script.
:check 7zip
if exist "%ProgramFiles%\7-Zip" (
echo 7zip Found At Your Syatem.
echo Now Process Begin.
goto checkadb
) else (
@echo [91m7zip not Found At Your Syatem.
@echo If You Are on 64-bit Windows Please Install 64-Bit 7zip Package.
@echo Try Again Later.
@echo Process Aborted.[0m  
timeout /t 5 > nul
exit
)
:checkadb
cls
tool\adb devices -l | findstr "product:RMX2020 product:RMX2027 product:rmx2020 product:rmx2027 product:RMX3171 product:RMX3191" > nul
 if errorlevel 1 (
    echo ADB:
    echo Device Not Connected In Adb Mode.
	echo Finding Into Fatboot Mode.
	echo.
	goto checkfastboot
 ) else (
    echo ADB:
    echo Device Found In System ADB Mode!
	tool\adb reboot recovery
	tool\adb wait-for-usb-recovery > nul 
	echo Wait For Reboot Into Recovery.
	goto checkrcvry
	)
	
:checkfastboot 
tool\fastboot devices -l | findstr "fastboot" > nul
 if errorlevel 1 (
	echo Fastboot:
    echo Devices Not Connected In Fastboot Mode.
	echo Check Again In 2 Second.
	timeout /t 2 > nul			   
    goto checkrcvry
 ) else (
	echo Fastboot:
    echo Device Found In Fastboot Mode!
	echo Your Device Must Be In Adb Mode Of Recovery To Operate Fastboot Maker.
	echo.
	echo Script Booting Into Operational Mode.
	echo.
	echo Don`t Touch your Device It will Boot Automattically Into Recovery Mode.
	echo.
	echo No One Hurt, Human Forget Sometimes, That`s Why Im here.  
	tool\fastboot reboot recovery
	tool\adb wait-for-usb-recovery > nul
	)

	:checkrcvry
tool\adb devices -l | findstr "product:omni_RMX2020 product:omni_RMX2027  product:omni_RMX3171 product:omni_rmx3171 recovery" > nul
 if errorlevel 1 (
    echo ADB:
    echo Device Not Connected In Recovey Mode.
	echo Finding Into Fatboot Mode.
	echo.
	goto checkadb
 ) else (
    echo ADB:
    echo Device Found In Recovery Adb Mode!
	echo Now Process Begin.
	timout /t 2 > nul
	Start /Max .\tool\FUM.bat
	exit
	)

