#!/bin/bash
echo ""
echo "============================================"
echo "Bulb - Project template for Intel Edison"
echo "============================================"

source /opt/poky-edison/1.6/environment-setup-core2-32-poky-linux
mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchains/oe-sdk_cross.cmake ..
make
