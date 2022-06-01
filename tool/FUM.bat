@echo off
:Script
setlocal EnableExtensions DisableDelayedExpansion
set files=.\tmp\files
color 0A
title FUMA BY @fire7ly 
cls
@echo 				====================================================================================================
@echo  							  		        MADE BY fire7ly
@echo    					              		Fastboot Unbrick Maker Advance.
@echo 				====================================================================================================
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
if not exist .\tmp mkdir %files% >> nul
echo Enivironment Created Successfully.
echo.
timeout /t 1 > nul
adb devices 
adb root 
echo.
echo device checked.
@echo.[91m
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
adb pull /dev/block/by-name/super .\tmp\super
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
adb pull /dev/block/by-name/boot .\tmp\files\boot.img>con
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
adb pull /dev/block/by-name/recovery  .\tmp\files\recovery.img>con
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
adb pull /dev/block/by-name/vbmeta  .\tmp\files\vbmeta.img>con
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
adb reboot
echo.
@echo [91mDevice Work Done, Your Device Boot To System Now. You Can Unplug It From Pc.[0m
echo.
rem Device Restarted So User Can Use That Till Files Coocking.
timeout /t 2 > nul
:sparsechunk
echo Making SuperChunk.
echo.
SparseConverter /compress .\tmp\super .\tmp 900MB > nul
:countchunk
dir /b .\tmp | findstr super_sparsechunk > .\tmp\super.txt
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
for %%i in (AdbWinApi.dll AdbWinUsbApi.dll fastboot.exe fastboot) do copy .\tool\%%i %files% > nul
copy .\tool\Readme.txt .\tmp\Readme.txt > nul
rem Copy Neccessory Files Into Folder.
:checkfiles
for %%i in (fastboot.exe fastboot AdbWinApi.dll AdbWinUsbApi.dll boot.img recovery.img rescue.bat rescue.sh) do (
if exist .\%files%\%%i ( 
    echo %%i is present 
) else (
    @echo [91m%%i is not present[0m 
)
)
:movesuper
for /f %%s in (.\tmp\super.txt) do move .\tmp\%%s %files% > nul
del /q .\tmp\super.txt
:SETFN
mkdir Product
IF "%ID%" GEQ "A**" (
@echo [91mFirmware Detacted: %ID% 
@echo Your Fastboot_Unbrick_%ID%.zip Will Be Aviliable In Product Folder Once It Done.
@echo Now sit Back and Do Any Other Work It Might Be Take Upto 15 Minutes, Depends On your Pc Performance.
@echo Chill Out Drink Coffee, Tea, Coke Anything You Like. Its Upto You LoL.[0m
echo.
timeout /t 2 > nul
goto 7zip
) else (
@echo [91m Error! Firmware Version Not Detected Enter It Manually.. 
 goto setname
 echo.
 )
:setname
set /p ID=Enter The Firmware Version (E.g. A01,C01,Octavi): 
IF "%ID%" GEQ "A**" (
@echo [91m Your Fastboot_Unbrick_%ID%.zip Will Be Aviliable In Product Folder Once It Done.
@echo Now sit Back and Do Any Other Work It Might Be Take Upto 15 Minutes, Depends On your Pc Performance.
@echo Chill Out Drink Coffee, Tea, Coke Anything You Like. Its Upto You, LoL.[0m
echo.
timeout /t 2 > nul
) else (
 echo Enter Your Device Firmware Version, E.g. A03,C01,RomName.
 echo Enter Again Option Is Not Valid!
 goto setname
 )
:7zip
rem Set Path For 7zip.
7za a -tzip .\Product\Fastboot_Unbrick_%ID%.zip .\tmp\files .\tmp\Readme.txt
echo.
@echo [91m Congratulations Your Fastboot_Unbrick_%ID%.zip Is Ready.[0m
echo.
rem Set Name Of Fastboot_Unbrick To User Desire.
if not exist .\Product\Fastboot_Unbrick_%ID%.zip ( @echo [91mFastboot_Unbrick.zip is not present[0m 
echo cleaning abort 
exit
)
if exist .\Product\Fastboot_Unbrick_%ID%.zip ( @echo [91mFastboot_Unbrick.zip is present[0m 
)
:cleaning
echo.
echo Time For Cleaning...
echo.
timeout /t 2 > nul
rd /s /q tmp 
@echo [91mOpening Folder For You.[0m
start .\Product
@echo [91mCleaning Done Process Ends In 2 Seconds.[0m
timeout /t 2 > nul
:end
goto :eof
