prefix=@CMAKE_INSTALL_PREFIX@
exec_prefix=${prefix}
libdir=${exec_prefix}/lib@LIB_SUFFIX@
includedir=${prefix}/include

Name: bulp
Description: CMake library skeleton for Intel Edison projects
Version: @bulp_VERSION_STRING@

Libs: -L${libdir} -lmraa
Cflags: -I${includedir}
