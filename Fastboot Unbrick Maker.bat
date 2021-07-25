@echo off
color 0A
title Fastboot Unbrick Maker V01
cls
@echo [91mNote:- Before Use This Utility You Must Need 10GB free Space on your System.                             
@echo        You Must have Connected Into Recovery Mode.                                                           
@echo 		  Your Device Must Have Driver installed. "ADB OR MTK"                                                  
@echo     	  You Can Disconnect Your Device When script Prompt You Notification.                                   
@echo        This is Fully Automatic Process Don`t interrupt it.                                                   
@echo     	  Use It At Your Own Risk. If Somthing Wrong, And You Point Finger On me I WILL LAUGH ON YOU.           
@echo    	  Last But Not The least You Find Your Fastboot_Unbrick.Zip In The Script Directory Keep That Safe.[0m   
timeout /t 5 > nul
cls
mkdir files
echo Directory Created Successfully.
echo Now Magick Begain Just Wait, Be Patience For That.
timeout /t 1 > nul
adb devices
rem Will put here check condition.
echo.
echo device checked.
adb root 
echo.
echo Please Wait Pulling Super From Device.
adb pull /dev/block/by-name/super
echo Super Pulled Successfully
echo.
timeout /t 1 > nul
echo Please Wait Pulling Boot From Device.
adb pull /dev/block/by-name/boot .\files\boot.img
echo Boot Pulled Successfully.
echo.
timeout /t 1 > nul
echo Please Wait Pulling Recovery From Device.
adb pull /dev/block/by-name/recovery  .\files\recovery.img
echo Recovery Pulled Successfully.
echo.
timeout /t 1 > nul
echo Please Wait Pulling Vbmeta From Device.
adb pull /dev/block/by-name/vbmeta  .\files\vbmeta.img
echo Vbmeta Pulled Successfully.
echo.
timeout /t 1 > nul
echo All files Pulled.
echo Now Cooking Fastboot Unbrick.
echo.
@echo [91mDevice Work Done Now You Can Unplug Your Device From Pc.[0m
echo.
adb reboot
echo.
timeout /t 2 > nul
echo Making SuperChunk.
SparseConverter /compress .\super .\files 900MB
echo sparsechunk Done.
echo.
del /q super
timeout /t 1 > nul
echo Copying Script.
Copy rescue.bat .\files\rescue.bat
echo Copy script Done.
echo.
timeout /t 1 > nul
echo Collecting Files And Making Fastboot Unbrick For You.
echo Please Wait..
copy adb.exe .\files && copy AdbWinApi.dll .\files && copy AdbWinUsbApi.dll .\files && copy fastboot.exe .\files
set path=%ProgramFiles%\7-Zip; %path%
7z a -tzip Fastboot_Unbrick.zip "Readme.txt" files
echo Congratulations Your Fastboot Unbrick Is ready.
echo Time For Cleaning...
echo.
timeout /t 1 > nul
del /q files && rd files
echo Cleaning Done Process Ends In 2 Seconds.
timeout /t 2 > nul.
exit
