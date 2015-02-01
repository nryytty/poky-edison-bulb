# poky-edison-bulp

Very early stage cmake project template for Intel Edison projects.

To build run

    source /opt/poky-edison/1.6/environment-setup-core2-32-poky-linux
    mkdir build
    cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchains/oe-sdk_cross.cmake ..
    make

