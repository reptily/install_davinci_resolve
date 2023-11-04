#!/bin/bash

sudo zypper in libpango-1_0-0 libpango-1_0-0-32bit libjpeg62 libapr1-0 libapr-util1-0 libopencl-clang14 libOpenCL1 libOpenCL1-32bit unzip

function downloadDavinci()
{
    rm -f DaVinci_Resolve_18.6.2_Linux.zip
    wget https://media.reptily.ru/davinci/DaVinci_Resolve_18.6.2_Linux.zip
}

function downloadGdkPixbuf()
{
    rm -f gdk-pixbuf2-2.42.10-2.fc38.x86_64.rpm
    wget https://media.reptily.ru/davinci/gdk-pixbuf2-2.42.10-2.fc38.x86_64.rpm
}

if [ ! -f ./gdk-pixbuf2-2.42.10-2.fc38.x86_64.rpm ]; then
    downloadGdkPixbuf
fi


if [ ! -f ./DaVinci_Resolve_18.6.2_Linux.zip ]; then
    downloadDavinci
fi

MD5_GDK="287e7441e888e12c7d79211213ff1584"
MD5_GDK_FILE=$(md5sum gdk-pixbuf2-2.42.10-2.fc38.x86_64.rpm | awk '{print $1}')

if [ "$MD5_GDK" != "$MD5_GDK_FILE" ]; then
 downloadGdkPixbuf
fi

MD5_DAVINCI="f069181fb77f5ddb25266f886da15f18"
MD5_DAVINCI_FILE=$(md5sum DaVinci_Resolve_18.6.2_Linux.zip | awk '{print $1}')

if [ "$MD5_DAVINCI" != "$MD5_DAVINCI_FILE" ]; then
 downloadDavinci
fi

if [ ! -f DaVinci_Resolve_18.6.2_Linux.run ]; then
    unzip DaVinci_Resolve_18.6.2_Linux.zip
fi

MD5_DAVINCI_RUN="9920012b84adf58a1785c9c212a2ac52"
MD5_DAVINCI_RUN_FILE=$(md5sum DaVinci_Resolve_18.6.2_Linux.run | awk '{print $1}')

if [ "$MD5_DAVINCI_RUN" != "$MD5_DAVINCI_RUN_FILE" ]; then
 rm -f DaVinci_Resolve_18.6.2_Linux.run
 unzip DaVinci_Resolve_18.6.2_Linux.zip
fi

export SKIP_PACKAGE_CHECK=1
sudo ./DaVinci_Resolve_18.6.2_Linux.run

rm -fr usr
rpm2cpio ./gdk-pixbuf2-2.42.10-2.fc38.x86_64.rpm | cpio -idmv
sudo cp usr/lib64/* /opt/resolve/libs/ -r
sudo cp /usr/lib64/libglib-2.0* /opt/resolve/libs

/opt/resolve/bin/resolve
