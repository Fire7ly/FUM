@echo off
title Helper Script.
set path=.\tool;%path%
:check 7zip
if exist ".\tool\7za.exe" (
echo 7zip Found At Your System.
echo Now Process Begin.
goto checkadb
) else (
@echo [91m7zip not Found At Your System.
@echo Process Aborted.[0m  
timeout /t 5 > nul
exit
)
:checkadb
cls
tool\adb devices -l | findstr "product:RMX product:rmx" > nul
 if errorlevel 1 (
    echo ADB:
    echo Device Not Connected In Adb Mode.
	echo Finding Into Fastboot Mode.
	echo.
	goto checkfastboot
 ) else (
    echo ADB:
    echo Device Found In System ADB Mode!
	for /F "delims=" %%a in ('adb shell getprop ro.product.odm.model') do set DEVICE=%%a
	for /F "delims=" %%a in ('adb shell getprop ro.build.product') do set PRODUCT=%%a
	for /F "delims=" %%a in ('adb shell getprop ro.build.display.ota') do set ID=%%a
	for /F "delims=" %%a in ('adb shell getprop ro.oppo.market.name') do set NAME=%%a
	echo.
	tool\adb reboot recovery
	echo Wait For Reboot Into Recovery.
	tool\adb wait-for-usb-recovery > nul 
	goto checkrcvry
	)
	
:checkfastboot 
tool\fastboot devices -l | findstr "fastboot" > nul
 if errorlevel 1 (
        echo.
	echo Fastboot:
    echo Devices Not Connected In Fastboot Mode.
	echo Check Again In 2 Second.
	timeout /t 2 > nul			   
    goto checkrcvry
 ) else (
 	echo.
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
tool\adb devices -l | findstr "recovery" > nul
 if errorlevel 1 (
 	echo.
    echo ADB:
    echo Device Not Connected In Recovey Mode.
	echo Finding Into Fastboot Mode.
	echo.
	goto checkadb
 ) else (
 	echo.
        echo ADB:
        echo Device Found In Recovery Adb Mode!
	echo Now Process Begin.
	tool\adb wait-for-usb-recovery > nul
	timeout /t 2 > nul
	start /MAX .\tool\FUM.bat
	exit
	)
