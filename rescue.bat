@echo off
color 0A
title Rescue
@echo This Fastboot Unbrick Erase Your Device Personal Data Use It At Your Own Risk.[0m
echo If you want to Stop It, You Have 5 second to Stop it, Use Ctrl+C. 
timeout /t 5 > nul
:Commands 
@echo [91mWork Started.[0m
fastboot devices
@echo [91mdevice connecting successfully.[0m
fastboot flash boot boot.img
@echo [91mSuccessful flashing boot.img[0m
fastboot --disable-verification flash vbmeta vbmeta.img
@echo [91mSuccessful flashing vbmeta.[0m
fastboot flash recovery recovery.img
@echo [91mSuccessful flashing recovery.[0m
fastboot flash super super_sparsechunk1
@echo [91mSuccessful flashing super_sparsechunk1[0m
fastboot flash super super_sparsechunk2
@echo [91mSuccessful flashing super_sparsechunk2[0m
fastboot flash super super_sparsechunk3
@echo [91mSuccessful flashing super_sparsechunk3[0m
fastboot flash super super_sparsechunk4
@echo [91mSuccessful flashing super_sparsechunk4[0m
fastboot flash super super_sparsechunk5
@echo [91mSuccessful flashing super_sparsechunk5[0m
fastboot flash super super_sparsechunk6
@echo [91mSuccessful flashing super_sparsechunk6[0m
fastboot flash super super_sparsechunk7
@echo [91mSuccessful flashing super_sparsechunk7[0m
fastboot erase userdata
@echo [91mSuccessful erased userdata[0m
fastboot -w
@echo [91mSuccessfully wiped userdata[0m
fastboot reboot
@echo [91mPlease be Patiante your device will boot in 5 second.[0m
timeout /t 2 > nul
:Greetings
@echo [31m     All set. 
echo     Setup Your Device Now. Have A nice Day.[0m
timeout /t 2 > nul
exit
