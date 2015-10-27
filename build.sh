#!/bin/bash

# setup environment
source _setenv_android.bash

# Update environment variables
export CC=gcc

# Build OpenSSL library

cd openssl-1.0.2d/
rm -rf build
mkdir build
./Configure no-ssl2 no-ssl3 shared no-zlib no-comp no-hw no-engine -fPIC -pie -fpic --prefix=`pwd`/build android
make -j4 depend
make -j4
make -j4 install_sw
cd ..

# Update environment variables
export CC=arm-linux-androideabi-gcc

# Build Expat library (LibExpat)
cd expat-2.1.0/
rm -rf build
mkdir build
./configure --prefix=`pwd`/build --with-sysroot=$ANDROID_SYSROOT --host=arm-linux-androideabi
make -j4
make -j4 install
cd ..

# Build Libevent
export CFLAGS="--sysroot=$ANDROID_SYSROOT -pie -fPIE -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
cd libevent-2.0.22-stable/
rm -rf build
mkdir build
./configure --with-sysroot=$ANDROID_SYSROOT --host=arm-linux-androideabi --prefix=`pwd`/build/
make -j4
make -j4 install

# Configure and build Unbound
cd unbound-1.5.4/
rm -rf build
mkdir build
./configure --prefix=`pwd`/build --with-sysroot=$ANDROID_NDK_SYSROOT --host=arm-linux-androideabi --with-ssl=`pwd`/../openssl-1.0.2d/build/ --with-libexpat=`pwd`/../expat-2.1.0/build/ --with-libevent=`pwd`/../libevent-2.0.22-stable/build/ --enable-checking --with-pthreads --with-pic --with-run-dir="" --with-pidfile="" --with-chroot-dir="" --with-conf-file=""
make -j4
make -j4 install
