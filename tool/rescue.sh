#!/bin/bash
ROOT_UID=0

if [ "$UID" -ne "$ROOT_UID" ]; then
    echo "Run script with superuser (root) rights. It needed because on some linux distros fastboot doesn't work without root."
    exit 87
fi

if [ -f "$PWD/adb" ] && [ -f "$PWD/fastboot" ]; then
    echo "Adb and fastboot found in current folder."
else
    echo "Adb and fastboot not found in current folder."
    echo "Place it here and then run script again."
    exit
fi

clear
echo "===================================="
echo "       rescue.sh for linux/unix"
echo "     This File Is System Genrated"
echo "===================================="
echo ""
echo "Use Fastboot Unbrick According To Your UI Version."
echo "Dont Use RUI 1 Fastboot Unbrick On RUI 2 Or Vice Versa, Otherwise Your Device Got Hardbrick."
echo "This Fastboot Unbrick Erase Your Device Personal Data, Use It At Your Own Risk."
echo "If you want to Stop It, You Have 5 second to Stop it, Use Ctrl+C."
sleep 5

echo "Starting..."
echo "Looking for device..."
if fastboot devices -l | grep -q "fastboot"; then
    echo "Device found in fastboot mode."
else
    echo "Device not found in fastboot mode. Connect it in fastboot mode and run script again."
    exit
fi

echo "Flashing boot image..."
./fastboot flash boot boot.img
echo "Flashed boot.img"
./fastboot --disable-verification flash vbmeta vbmeta.img
echo "Flashed vbmeta.img"
./fastboot flash recovery recovery.img
echo "Flashed recovery.img"
echo "Starting flashing super partition chunks..."
echo "Flashing chunk 1..."
./fastboot flash super super_sparsechunk1
echo "Flashing chunk 2..."
./fastboot flash super super_sparsechunk2
echo "Flashing chunk 3..."
./fastboot flash super super_sparsechunk3
echo "Flashing chunk 4..."
./fastboot flash super super_sparsechunk4
echo "Flashing chunk 5..."
./fastboot flash super super_sparsechunk5
echo "Flashing chunk 6..."
./fastboot flash super super_sparsechunk6
echo "Flashing chunk 7..."
./fastboot flash super super_sparsechunk7
echo "Flashed all super chunks!"
echo "Erasing userdata partition..."
./fastboot erase userdata
echo "Erased userdata partition."
./fastboot -w
./fastboot reboot
echo "Process finished!"
echo "Your device will boot soon, enjoy."
read -p "Press enter to exit..." just_something