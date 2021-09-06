@echo off
:Script
setlocal EnableExtensions DisableDelayedExpansion
color 0A
title FUMA BY @fire7ly 
cls
@echo 				===================================================================================================
@echo  											MADE BY fire7ly
@echo    					    	   		Fastboot Unbrick Maker Advance.
@echo 				===================================================================================================
@echo 					[91mNote:- Before Use This Utility You Must Need 10GB free Space on your System.
@echo                                  		 This is Fully Automatic Process Don`t interrupt it.
@echo 						 Your Device Must Have Driver installed. "ADB OR MTK"
@echo     					  You Can Disconnect Your Device When script Prompt You Notification.[0m
@echo   				  [91mUse It At Your Own Risk. If Somthing Wrong, And You Point Finger On me I WILL LAUGH ON YOU.[0m
echo    			         Last But Not The least You Find Your Fastboot_Unbrick.Zip In The Product Folder Keep That Safe.
:PROMPT
SET /P AREYOUSURE=Are you sure (Y/N)? :
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END
rem Making Directory
echo.
@echo [91mSo you are sure. Okay, let's go ...[0m
echo.
if exist .\tmp rd /s /q .\tmp  
if not exist .\tmp mkdir .\tmp\files >> nul
echo Enivironment Created Successfully.
echo.
timeout /t 1 > nul
tool\adb devices 
tool\adb root 
echo.
for /F "delims=" %%a in ('adb.exe shell getprop ro.product.odm.model') do set DEVICE=%%a
for /F "delims=" %%a in ('adb.exe shell getprop ro.build.product') do set PRODUCT=%%a
for /F "delims=" %%a in ('adb.exe shell getprop ro.build.display.ota') do set ID=%%a
for /F "delims=" %%a in ('adb.exe shell getprop ro.oppo.market.name') do set NAME=%%a
echo.
echo device checked.
@echo [91m.
echo Hostname: %NAME%
echo Detected: %DEVICE% (%PRODUCT%)
echo Firmware: %ID%
rem script starts.
echo.
echo Now Magick Begain Be Patience For That.
echo.[0m
:super
echo Please Wait Pulling Super From Device.
echo This May Take A While Be Patience.
tool\adb pull /dev/block/by-name/super .\tmp\super
if exist .\tmp\super (
echo.
echo Super Pulled Successfully 
echo.
) else (
@echo [91mSuper Not Found. Pulling Again.[0m 
goto Super
)
echo.
timeout /t 1 > nul
:boot
echo Please Wait Pulling Boot From Device.
tool\adb pull /dev/block/by-name/boot .\tmp\files\boot.img>con
if exist .\tmp\files\boot.img (
echo.
echo Boot Pulled Successfully 
echo.
) else (
@echo [91mBoot Not Found. Pulling Again.[0m 
goto boot
)
echo.
timeout /t 1 > nul
:recovery
echo Please Wait Pulling Recovery From Device.
tool\adb pull /dev/block/by-name/recovery  .\tmp\files\recovery.img>con
if exist .\tmp\files\recovery.img (
echo.
echo Recovery Pulled Successfully. 
echo.
) else (
@echo [91mrecovery Not Found. Pulling Again.[0m 
goto recovery
)
echo.
timeout /t 1 > nul
:vbmeta
echo Please Wait Pulling Vbmeta From Device.
tool\adb pull /dev/block/by-name/vbmeta  .\tmp\files\vbmeta.img>con
if exist .\tmp\files\boot.img (
echo.
echo Vbmeta Pulled Successfully. 
echo.
) else (
@echo [91mvbmeta Not Found. Pulling Again.[0m 
goto vbmeta
)
echo.
timeout /t 1 > nul
:pulled
rem script Pulled All Needed Files.
echo All files Pulled.
echo.
echo Now Cooking Fastboot Unbrick.
echo.
:unplug
tool\adb reboot
echo.
@echo [91mDevice Work Done, Your Device Boot To System Now. You Can Unplug It From Pc.[0m
echo.
rem Device Restarted So User Can Use That Till Files Coocking.
timeout /t 2 > nul
:sparsechunk
echo Making SuperChunk.
echo.
tool\SparseConverter /compress .\tmp\super .\tmp\files 900MB
echo sparsechunk Done.
echo.
rem SuperChunk Done. Delete Super To Save Space.
del /q .\tmp\super
rem Delete Super For Save Space Upto 6GB.
timeout /t 1 > nul
:copy
echo Copying Script.
Copy .\tool\rescue.* .\tmp\files\ > nul
echo Copy script Done.
echo.
timeout /t 1 > nul
echo Collecting Files And Making Fastboot Unbrick For You.
echo Please Wait..
copy .\tool\adb.exe .\tmp\files && copy .\tool\AdbWinApi.dll .\tmp\files && copy .\tool\AdbWinUsbApi.dll .\tmp\files && copy .\tool\fastboot.exe .\tmp\files >> nul
copy .\tool\adb .\tmp\files && copy .\tool\fastboot .\tmp\files && copy .\tool\Readme.txt .\tmp\Readme.txt >> nul
rem Copy Neccessory Files Into Folder.
:checkfiles
if exist .\tmp\files\adb.exe ( echo adb.exe is present ) 
if not exist .\tmp\files\adb.exe (@echo [91madb is not present[0m)
if exist .\tmp\files\adb ( echo adb is present ) 
if not exist .\tmp\files\adb (@echo [91madb is not present[0m)
if exist .\tmp\files\fastboot ( echo fastboot is present ) 
if not exist .\tmp\files\fastboot (@echo [91mfastboot is not present[0m)
if exist .\tmp\files\AdbWinApi.dll ( echo AdbWinApi.dll is present ) 
if not exist .\tmp\files\AdbWinApi.dll (@echo [91mAdbWinApi.dll is not present[0m )
if exist .\tmp\files\AdbWinUsbApi.dll ( echo AdbWinUsbApi.dll is present ) 
if not exist .\tmp\files\AdbWinUsbApi.dll (@echo [91mAdbWinUsbApi.dlll is not present[0m )
if exist .\tmp\files\boot.img ( echo boot.img is present ) 
if not exist .\tmp\files\boot.img (@echo [91m boot.img is not present[0m )
if exist .\tmp\files\fastboot.exe ( echo fastboot.exe is present ) 
if not exist .\tmp\files\fastboot.exe (@echo [91m fastboot.exe is not present[0m )
if exist .\tmp\files\recovery.img ( echo recovery.img is present ) 
if not exist .\tmp\files\recovery.img (@echo [91m recovery.img is not present[0m )
if exist .\tmp\files\rescue.bat ( echo rescue.bat is present ) 
if not exist .\tmp\files\recovery.img (@echo [91m recovery.img is not present[0m )
if exist .\tmp\files\rescue.sh ( echo rescue.sh is present )
if not exist .\tmp\files\rescue.sh (@echo [91m rescue.sh is not present[0m )
if exist .\tmp\files\super_sparsechunk6 ( echo super_sparsechunk6 is present ) 
if not exist .\tmp\files\super_sparsechunk6 (@echo [91m super_sparsechunk6 is not present[0m )
if exist .\tmp\files\super_sparsechunk1 ( echo super_sparsechunk1 is present ) 
if not exist .\tmp\files\super_sparsechunk1 (@echo [91m super_sparsechunk1 is not present[0m )
if exist .\tmp\files\super_sparsechunk7 ( echo super_sparsechunk7 is present ) 
if not exist .\tmp\files\super_sparsechunk7 (@echo [91m super_sparsechunk7 is not present[0m )
:SETFN
mkdir Product
IF "%ID%" GEQ "A**" (
@echo [91m Firmware Detacted: %ID% 
@echo Your Fatboot_Unbrick_%ID%.zip Will Be Aviliable In Product Folder Once It Done.
@echo Now sit Back and Do Any Other Work It Might Be Take Upto 15 Minutes, Depends On your Pc Performance.
@echo Chill Out Drink Coffee, Tea, Coke Anything You Like. Its Upto You LoL.[0m
echo.
timeout /t 2 > nul
goto 7zip
) else (
 echo %ID% was unexpected at this time.
@echo [91m Error! Firmware Version Not Detected Enter It Manually.. 
 goto setname
 echo.
 )
:setname
set /p ID=Enter The Firmware Version (E.g. A01,C01,Octavi): 
IF "%ID%" GEQ "A**" (
@echo [91m Your Fatboot_Unbrick_%ID%.zip Will Be Aviliable In Product Folder Once It Done.
@echo Now sit Back and Do Any Other Work It Might Be Take Upto 15 Minutes, Depends On your Pc Performance.
@echo Chill Out Drink Coffee, Tea, Coke Anything You Like. Its Upto You, LoL.[0m
echo.
timeout /t 2 > nul
) else (
 echo %ID% was unexpected at this time.
 echo Enter Your Device Firmware Version, E.g. A03,C01,RomName.
 echo Enter Again Option Is Not Valid!
 goto setname
 )
:7zip

set path=%ProgramFiles%\7-Zip; %path%
rem Set Path For 7zip.
7z a -tzip .\Product\Fatboot_Unbrick_%ID%.zip .\tmp\files .\tmp\Readme.txt
echo.
@echo [91m Congratulations Your Fatboot_Unbrick_%ID%.zip Is Ready.[0m
echo.
rem Set Name Of Fastboot_Unbrick To User Desire.
:cleaniing
echo Time For Cleaning...
echo.
timeout /t 2 > nul
rd /s /q tmp 
@echo [91m Opening Folder For You.[0m
start .\Product
@echo [91m Cleaning Done Process Ends In 2 Seconds.[0m
timeout /t 2 > nul
:end
goto :eof
rem exit