cmake_minimum_required(VERSION 2.8.4)
project (bulb)

FIND_PACKAGE (Threads)

set (CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall -fno-omit-frame-pointer")
set (CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -Wall")
set (LIB_INSTALL_DIR "lib${LIB_SUFFIX}" CACHE PATH "Installation path for libraries")

# Set CMAKE_LIB_INSTALL_DIR if not defined
include(GNUInstallDirs)

# Appends the cmake/modules path to MAKE_MODULE_PATH variable.
set (CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules ${CMAKE_MODULE_PATH})

# Make a version file containing the current version from git.
include (GetGitRevisionDescription)
git_describe (VERSION "--tags")
if ("x_${VERSION}" STREQUAL "x_GIT-NOTFOUND")
    message (WARNING " - Install git to compile a production bulb!")
    set (VERSION "v0.0.1-dirty")
endif ()

message (INFO " - Bulb Version ${VERSION}")

#parse the version information into pieces.
string (REGEX REPLACE "^v([0-9]+)\\..*" "\\1" VERSION_MAJOR "${VERSION}")
string (REGEX REPLACE "^v[0-9]+\\.([0-9]+).*" "\\1" VERSION_MINOR "${VERSION}")
string (REGEX REPLACE "^v[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" VERSION_PATCH "${VERSION}")
string (REGEX REPLACE "^v[0-9]+\\.[0-9]+\\.[0-9]+\\-([0-9]+).*" "\\1" VERSION_COMMIT "${VERSION}")
string (REGEX REPLACE "^v[0-9]+\\.[0-9]+\\.[0-9]+-[0-9]+\\-(.*)" "\\1" VERSION_SHA1 "${VERSION}")
set (VERSION_SHORT "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}")

if ("${VERSION_COMMIT}" MATCHES "^v.*")
    set (VERSION_COMMIT "")
endif()

configure_file (${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules/version.c.in
                ${CMAKE_CURRENT_BINARY_DIR}/src/version.c)

# this is the library version, independant of git revision
set (project_VERSION_MAJOR ${VERSION_MAJOR})
set (project_VERSION_MINOR ${VERSION_MINOR})
set (project_VERSION_PATCH ${VERSION_PATCH})
set (project_VERSION_STRING ${project_VERSION_MAJOR}.${project_VERSION_MINOR}.${project_VERSION_PATCH})
set (CMAKE_SWIG_FLAGS "")

find_path (SYSTEM_USR_DIR "stdlib.h")
include_directories (${SYSTEM_USR_DIR})

option (GTEST "Build all gtests." OFF)
option (IPK "Generate IPK using CPack" OFF)

include (TargetArch)
target_architecture (DETECTED_ARCH)
message( INFO " - Target arch is ${DETECTED_ARCH}")

if (DETECTED_ARCH STREQUAL "i586" OR DETECTED_ARCH STREQUAL "x86_64" OR DETECTED_ARCH STREQUAL "i386")
    set (X86PLAT ON)
elseif (DETECTED_ARCH MATCHES "arm.*")
    set (ARMPLAT ON)
else ()
    message(FATAL_ERROR "Only x86 and arm platforms currently supported")
endif()

if (GTEST)
    enable_testing ()
    add_subdirectory (tests)
endif ()

if (IPK)
    set(CPACK_GENERATOR "DEB" "TGZ")
    set(OPKG_ARCH ${DETECTED_ARCH})
    set(CPACK_BINARY_DIR ${CMAKE_BINARY_DIR})
    set(CPACK_DEBIAN_PACKAGE_MAINTAINER "nryytty") #required
    set(project_PACKAGE_ON_TAG ".")
    if ("${VERSION_COMMIT}" STREQUAL "")
        set(project_PACKAGE_ON_TAG "")
    endif()
    set(CPACK_PACKAGE_VERSION "${project_VERSION_MAJOR}.${project_VERSION_MINOR}.${project_VERSION_PATCH}${project_PACKAGE_ON_TAG}${VERSION_COMMIT}")
    set(CPACK_PACKAGE_NAME "${PROJECT_NAME}${project_VERSION_MAJOR}")
    set(CPACK_DEBIAN_PACKAGE_SECTION "libs")
    set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE ${DETECTED_ARCH})
    set(CPACK_SYSTEM_NAME ${DETECTED_ARCH})
    set(CPACK_DEBIAN_PACKAGE_PROVIDES "${PROJECT_NAME}")
    set(CPACK_DEBIAN_PACKAGE_REPLACES ${CPACK_DEBIAN_PACKAGE_PROVIDES})
    set(CPACK_DEBIAN_PACKAGE_CONFLICTS ${CPACK_DEBIAN_PACKAGE_PROVIDES})
    set(WDIR "${CPACK_TOPLEVEL_DIRECTORY}/${CPACK_PACKAGE_FILE_NAME}")
    include (CPack)
endif()

add_subdirectory (src)
