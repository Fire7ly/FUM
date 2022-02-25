#!/bin/bash
ZIP_EXEC=$(which zip)
MONO_EXEC=$(which mono)
ROOT_UID=0
lolcat=/usr/games/lolcat
work_dir=./tool
tmp=./tmp
adb=./tool/adb
fastboot=./tool/fastboot
RED="\e[31m"
GREEN="\e[32m"
END="\e[0m"

if [ "$UID" -ne "$ROOT_UID" ]; then
    echo -e "${RED}Run script with superuser (root) rights. It needed because on some linux distros fastboot doesn't work without root.${END}"
    exit 87
fi

if [ -d "$tmp/files" ]; then
    echo -e "${RED}Found 'tmp' folder here, Cleaning it to avoid errors...${END}"
    rm -rf $tmp/* && mkdir -p $tmp/files
else
    echo -e "${RED}'tmp' folder not found here, Creating It....${END}"
    mkdir -p $tmp/files
fi

if [ -f "$tmp/super" ]; then
    echo  -e "${RED}Found 'super' partition here, deleting it to avoid errors...${END}"
    rm $tmp/super
fi

function restart_adb_server {
    $adb kill-server
    echo -e "${GREEN}Starting ADB server...${END}"
    $adb start-server
}

function check_adb {
    if $adb devices -l | grep -q "product:RMX"; then
        echo -e "${GREEN}ADB: Device found.${END}"
        reboot_to_recovery

    elif $adb devices -l | grep -q "product:rmx"; then
        echo -e "${GREEN}ADB: Device found.${END}"
        reboot_to_recovery

    else
        echo -e "${RED}ADB: Device not connected in ADB mode.${END}"
        echo -e  "${RED}ADB: Looking for device connected in fastboot mode...${END}"
        sleep 2
        check_fastboot
    fi
}

function check_fastboot {
    if $fastboot devices -l | grep -q "fastboot"; then
        echo -e  "${RED}Fastboot: Found device in Fastboot mode. Rebooting to ADB recovery mode in 40 seconds...${END}"
        $fastboot reboot recovery
        sleep 40
        check_recovery
    else
        echo -e "${RED}Device not found in Fastboot mode. Looking for ADB recovery mode...${END}"
        sleep 2
        check_recovery
    fi
}

function check_recovery {
    if $adb devices -l | grep -q "recovery"; then
        echo -e "${GREEN}ADB: Device found in recovery mode.${END}"
        MainScript
    else
        echo -e "${RED}ADB: Device not connected in ADB recovery mode.${END}"
        echo -e "${RED}ADB: Checking again in ADB system mode...${END}"
        sleep 2
        check_adb
    fi
}

function reboot_to_recovery {
    echo -e  "${RED}Your device is rebooting to recovery in 40 seconds...${END}"
    $adb reboot recovery
    sleep 40
    check_recovery
}

function pull_super {
    $adb pull /dev/block/by-name/super $tmp/super
    if [ -f "$tmp/super" ]; then
        echo -e "${GREEN}super partition pulled successfully.${END}"
        chmod ugo+rwx $tmp/super
    else
        echo -e "${RED}super partition not found.${END}"
        echo -e  "${RED}Pulling again.${END}"
        pull_super
    fi
}

function pull_boot {
    $adb pull /dev/block/by-name/boot $tmp/files/boot.img
    if [ -f "$tmp/files/boot.img" ]; then
        echo -e "${GREEN}boot partition pulled successfully.${END}"
        chmod ugo+rwx $tmp/files/boot.img
    else
        echo -e "${RED}boot partition not found.${END}"
        echo -e "${RED}Pulling again.${END}"
        pull_boot
    fi
}

function pull_recovery {
    $adb pull /dev/block/by-name/recovery $tmp/files/recovery.img
    if [ -f "$tmp/files/recovery.img" ]; then
        echo -e "${GREEN}recovery partition pulled successfully.${END}"
        chmod ugo+rwx $tmp/files/recovery.img
    else
        echo -e "${RED}recovery partition not found.${END}"
        echo -e "${RED}Pulling again.${END}"
        pull_recovery
    fi
}

function pull_vbmeta {
    $adb pull /dev/block/by-name/vbmeta $tmp/files/vbmeta.img
    if [ -f "./tmp/files/vbmeta.img" ]; then
        echo -e "${GREEN}vbmeta partition pulled successfully.${END}"
        chmod ugo+rwx $tmp/files/vbmeta.img
    else
        echo -e "${RED}vbmeta partition not found.${END}"
        echo -e "${RED}Pulling again.${END}"
        pull_vbmeta
    fi
}



function MainScript {
    clear
    figlet -f "Bloody" -d ./tool/.figlet-fonts/  -w $(tput cols) -c  FUM | $lolcat
    COLUMNS=$(tput cols)
    d=" Todat Is : $(date +%Y-%m-%d)"
    t1="MADE With ❤ BY @fire7ly & @ksurf7"
    t2=" Fastboot Unbrick Maker Advance."
    printf "%*s\n" $(((${#t1}+$COLUMNS)/2)) "$t1" | $lolcat
    printf "%*s\n" $(((${#t2}+$COLUMNS)/2)) "$t2" | $lolcat
    printf "%*s\n" $(((${#d}+$COLUMNS)/2)) "$d"
    echo -e "${RED}Note: Before Use This Utility You Must Need 10GB free Space on your System.${END}"
    echo -e "${RED}      You Can Disconnect Your Device When script Prompt You Notification.${END}"
    echo -e "${RED}      This is Fully Automatic Process Don't interrupt it.${END}"
    echo -e "${RED}      Use It At Your Own Risk. If Somthing Wrong, And You Point Finger On me I WILL LAUGH ON YOU.${END}"
    echo -e "${RED}      Last But Not The least You Find Your Fastboot_Unbrick.Zip In The Script Directory Keep That Safe.${END}"

    $adb root

    echo -e "${GREEN}Starting pulling super partition from your device.${END}"
    echo -e "${GREEN}This may take a while, get a cup of coffee.${END}"

    pull_super

    echo -e "${GREEN}Pulling boot partition from your device...${END}"

    pull_boot

    echo -e "${GREEN}Pulling recovery partition from your device...${END}"

    pull_recovery

    echo -e "${GREEN}Pulling vbmeta partition from your device...${END}"

    pull_vbmeta

    echo -e "${GREEN}All files pulled. Rebooting your device to system...${END}"

    $adb reboot

    echo -e "${RED}Now you can unplug your phone from PC.${END}"

    echo -e "${GREEN}Making SparseChunk...${END}"

    /bin/mono ./tool/SparseConverter.exe /compress ./tmp/super ./tmp/ 900MB

    echo -e "${GREEN}Files Moving.${END}"

    mv './tmp/\super_sparsechunk1' ./tmp/files/super_sparsechunk1
    mv './tmp/\super_sparsechunk2' ./tmp/files/super_sparsechunk2
    mv './tmp/\super_sparsechunk3' ./tmp/files/super_sparsechunk3
    mv './tmp/\super_sparsechunk4' ./tmp/files/super_sparsechunk4
    mv './tmp/\super_sparsechunk5' ./tmp/files/super_sparsechunk5
    mv './tmp/\super_sparsechunk6' ./tmp/files/super_sparsechunk6
    mv './tmp/\super_sparsechunk7' ./tmp/files/super_sparsechunk7

    echo -e "${GREEN}Making SparseChunk done.${END}"

    rm $tmp/super

    cp $work_dir/rescue* $tmp/files/ && cp $work_dir/Readme.txt $tmp

    echo -e "${GREEN} Script copied.${END}"

    echo -e "${GREEN}Collecting files...${END}"

    cp $work_dir/*.dll $work_dir/fastboot* $tmp/files/

    chmod ugo+rwx ./tmp/files

    read -p "Which firmware do you have? (e.g. A25, A59, C01, Octavi) " firmware_ver

    echo -e "${GREEN}Starting making a zip file...${END}"

    sleep 5

    mkdir -p Product

    cd tmp && zip -r "../Product/Fastboot_Unbrick_$firmware_ver.zip" * && cd ..

    chmod ugo+rwx "./Product/Fastboot_Unbrick_$firmware_ver.zip"

    echo -e "${GREEN}Your Fastboot_Unbrick_$firmware_ver.zip is ready. Enjoy.${END}"

    rm -rf $tmp

    exit
}

if [ -f "$ZIP_EXEC" ]; then
    echo -e "${GREEN}Zip found on your system.${END}"
else
    echo -e "${RED}Zip not found on your system.${END}"
    echo -e "${RED}Install zip and run script again.${END}"
    exit
fi

if [ -f "$MONO_EXEC" ]; then
    echo -e "${GREEN}Mono found on your system.${END}"
else
    echo -e "${RED}Mono not found on your system. Trying TO Install It..${END}"
    echo -e "${RED}Install mono and run script again.${END}"
    exit
fi

if [ -f "$adb" ] && [ -f "$fastboot" ]; then
    echo -e "${GREEN}Adb and fastboot found in current folder.${END}"
	chmod +x $adb $fastboot
else
    echo -e "${RED}Adb and fastboot not found in current folder.${END}"
    echo -e "${RED}Place it here and then run script again.${END}"
    exit
fi

restart_adb_server
check_adb

exit
