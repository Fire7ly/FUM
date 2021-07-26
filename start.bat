@echo off 
cls
title FUM BY @fire7ly
color 3
@echo ======================================================
@echo  				MADE BY fire7ly
@echo   UNIVERSAL FASTBOOT UNBRICK MAKER FOR REALME DEVICES
@echo ======================================================
:checkadb
adb get-state | findstr "device" > nul
 if errorlevel 1 (	
    echo.
	echo ADB:
    echo Device Not Connected In ADB Mode.
	echo Checking In Fastboot Mode.
	echo.
	goto checkfastboot
 ) else (
    echo.
	echo ADB:
    echo Device Found In System ADB Mode!
	echo Booting Into Recovery Mode.
	adb reboot recovery
	adb wait-for-usb-recovery
	goto checkrecovery
	timeout /t 8 > nul
	)
 
 :checkfastboot 
fastboot devices -l | findstr "fastboot" > nul
 if errorlevel 1 (
	echo.
	echo Fastboot:
    echo Devices Not Connected In Fastboot Mode.
	echo Check Again In 2 Second.
	timeout /t 2 > nul
	goto checkrecovery
 ) else (
	echo.
	echo Fastboot:
    echo Device Found In Bootloader Mode! Rebooting into recovery mode!
	fastboot reboot recovery
	echo Script is Waiting for device boot into recovery. 
	adb wait-for-usb-recovery > nul
	)
	:checkrecovery
adb get-state | findstr "recovery" > nul
 if errorlevel 1 (
	echo.
	echo ADB:
    echo Devices Not Connected In Recovery Mode.
	echo Check Again In 2 Second.
	timeout /t 2 > nul
	goto checkadb
 ) else (
	echo.
	echo ADB:
    echo Device Found In Recovery ADB Mode!
	echo Script is Waiting for device boot into recovery.
	CALL FUM.bat
	)
