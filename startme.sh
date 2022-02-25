#!/bin/bash

# Welcome to Fastboot Unbrick Maker script by fire7ly & ksurf7 for linux 
# It`s a dirty implementation of fastboot unbrick maker for linux.


# Disclaimer: This is open source software and is provided as is without any kind of warranty or support whatsoever.
# By using and viewing this software you agree to the following terms:
# Under no circumstances shall the author be held responsible for any damages that may arrise from the (inappropriate) use of this software.
# All responsibility, liability and risk lies with the end-user. You hereby agree not to abuse this software for illegal purposes.
# The end-user is free to improve the underlying algorithm (as long as no malicious code is added) as well as redistribute this script in his own project
# as long as this comment section and the title section of the script will remain also we use many utilites in order to work with this script all goes to their respective owner.

# Author: fire7ly
# Creation date: February 2022
# Last updated: Initial ( dirty implementation )

# Requirements: debion Based linux Operating System With apt Package manager + at least 20 GB free space on device for dumping data

# Description: A script for making fastboot flashable rom from linux operating system, Used In following curcumtances |
# 1. fix your device while loop 
# 2. dead boot 
# 3. revert back to stock from custom roms
# 4. upgrade / downgrade
# run this command to make the script executable: => chmod +x startme.sh

# Usage: Plug your device with adb debugging enabled and run executable script it will detect your device and boot it into recovery to dump partitions.

# Please post your feedback, suggestions and improvements in the official thread:
# https://forum.xda-developers.com/t/fastboot-unbrick-maker-fum.4352353

PATH=$PATH
lolcat=/usr/games/lolcat
figlet=/usr/bin/figlet
unzip=/usr/bin/unzip
ROOT_UID=0
mono=/bin/mono
RED="\e[31m"
GREEN="\e[32m"
END="\e[0m"

clear

if [ "$UID" -ne "$ROOT_UID" ]; then
    echo -e "${RED}Run script with superuser (root) rights. It needed because on some linux distros fastboot doesn't work without root.${END}"
    exit 87
fi

if [ -f "/usr/bin/figlet" ] && [ -f "/usr/games/lolcat" ] && [ -f "/usr/bin/unzip" ]; then
    echo "Requirement Already Satisfied! Going Ahead.."  | $lolcat
else
    echo -e "${RED} Requirement Not Satisfied Installing Them.. Please Wait..${END}"
    apt install lolcat figlet wget unzip zip -y 2>/dev/null |grep "null" | cut -d '.' -f 1
    echo "Requirement Are Satisfied! Going Ahead.." | $lolcat
fi

if [ -f /usr/bin/zip ]; then
    echo -e "${GREEN}Zip Is Present In System.. Finding Next Target...${END}"
else
    echo -e "${RED}Zip Is Not Present In System.. Installing Zip To System. Please Wait..${END}"
    apt install zip
    echo -e "${GREEN}Successfully Installed Zip..${END}"
fi

if [ -f /usr/bin/mono ]; then
 echo -e "${GREEN}Mono Is Present In System.. Finding Next Target...${END}"
else
 echo -e "${RED}Mono Is Not Present In System.. Installing Mono To System. Please Wait..${END}"
 apt install mono-xsp4 -y #2>/dev/null |grep "null" | cut -d '.' -f 1
 echo -e "${GREEN}Successfully Installed Mono..${END}"
fi

if [ -f "$PWD/tool/adb" ] && [ -f "$PWD/tool/fastboot" ]; then
    echo -e "${GREEN}Adb and fastboot found in current folder.${END}"
else
    echo -e "${RED}Adb and fastboot not found in current folder.. Installing Adb, Please Wait..${END}"
    mkdir -p tmp && cd tmp &&  wget https://dl.google.com/android/repository/platform-tools_r31.0.3-linux.zip && unzip platform-tools_r31.0.3-linux.zip platform-tools/adb platform-tools/fastboot && cd ..
    mv ./tmp/platform-tools/adb ./tmp/platform-tools/fastboot ./tool/
    rm -rf ./tmp/*
    echo -e "${GREEN}Successfully Fatched Adb And Fastboot..${END}"
fi
echo -e "${GREEN} All Set Good To Go! ${END}"
bash ./tool/FUM.sh
