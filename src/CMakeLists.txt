# sources
set (project_LIB_SRCS_NOAUTO
  ${PROJECT_SOURCE_DIR}/src/bulb.cpp
)
set (project_LIB_SRCS
    ${project_LIB_SRCS_NOAUTO}
    ${CMAKE_CURRENT_BINARY_DIR}/version.c # generated version file
)

#includes
set (project_LIB_INCLUDE_DIRS
  ${PROJECT_SOURCE_DIR}/include
)
include_directories(
  ${project_LIB_INCLUDE_DIRS}
)

add_executable(${PROJECT_NAME} ${project_LIB_SRCS})
#set_target_properties (${PROJECT_NAME}
#   PROPERTIES
#   SOVERSION ${project_VERSION_MAJOR}
#   VERSION ${project_VERSION_STRING}
#)

target_link_libraries(${PROJECT_NAME} mraa pthread)

macro (project_CREATE_INSTALL_PKGCONFIG generated_file install_location)
  configure_file (${generated_file}.cmake ${CMAKE_CURRENT_BINARY_DIR}/${generated_file} @ONLY)
  install (FILES ${CMAKE_CURRENT_BINARY_DIR}/${generated_file} DESTINATION ${install_location})
endmacro (project_CREATE_INSTALL_PKGCONFIG)
project_create_install_pkgconfig (${PROJECT_NAME}.pc lib${LIB_SUFFIX}/pkgconfig)

