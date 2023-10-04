# Stop messy in source builds
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)
set(CMAKE_DISABLE_SOURCE_CHANGES  ON)

if ( ${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR} )
    message( FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there. You may need to remove CMakeCache.txt." )
endif()

# Start Build Config -----------------------------------
cmake_minimum_required(VERSION 3.8)
set(CMAKE_SKIP_RPATH true)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_COLOR_MAKEFILE ON)

# Library output name for the final binaries
set(HDBPP_HEALTH_CHECK_NAME "HdbppHealthCheck")

# Versioning
set(VERSION_MAJOR "0")
set(VERSION_MINOR "1")
set(VERSION_PATCH "0")
set(VERSION_METADATA "")
set(VERSION_STRING ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})

# Add any include paths from the command line
list(APPEND INCLUDE_PATHS ${CMAKE_INCLUDE_PATH})
list(APPEND INCLUDE_PATHS ${CMAKE_SOURCE_DIR})
list(APPEND LIBRARY_PATHS ${CMAKE_LIBRARY_PATH})

# Start the project
project(hdbpp_health_check)# VERSION ${VERSION_STRING} LANGUAGES CXX)

option(ENABLE_CLANG "Enable clang code and layout analysis" OFF)

# arch install definitions
include(GNUInstallDirs)

message(STATUS "Searching for libraries...")

# Variable to contain a list of all the libs we depend on
#set(HDBPP_HC_LIBRARIES dl) 

# allow pkg-config to search the CMAKE_PREFIX_PATH 
set(PKG_CONFIG_USE_CMAKE_PREFIX_PATH ON)
list(APPEND CMAKE_PREFIX_PATH "/usr")

# Find Dependencies  ---------------------
include(FindPkgConfig)

# Attempt to find the various libraries the project is dependent on
#if(HDBPP_HC_LIBRARIES)
#    list(APPEND LIBRARY_PATHS ${CMAKE_BINARY_DIR})
#    find_libraries(LIBRARIES ${HDBPP_HC_LIBRARIES} SEARCH_PATHS ${LIBRARY_PATHS})
#    set(HDBPP_HC_FOUND_LIBRARIES ${FOUND_LIBRARIES})
#endif(HDBPP_HC_LIBRARIES)

# First find tango
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_CURRENT_SOURCE_DIR}/cmake")
find_package(Tango REQUIRED)

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

# Thirdparty Integration -----------------------------------

# Header only http requests library
add_subdirectory(thirdparty/cpp-httplib EXCLUDE_FROM_ALL)

# Json parser, this is header only and offers no interface library, so make our own
add_library(rapidjson INTERFACE)
target_include_directories(rapidjson INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/rapidjson/include>)

# Code Analysis -----------------------------------
if(ENABLE_CLANG)
    set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

    # To find clang, find_program will search your PATH environment variable.
    # Ensure if you have a non-standard clang install, that it has been added
    # to your path.
    find_program(CLANG_TIDY_EXE 
        NAMES "clang-tidy" 
        DOC "Path to clang-tidy executable")

    if(NOT CLANG_TIDY_EXE)
        message(STATUS "clang-tidy not found.")
    else(NOT CLANG_TIDY_EXE)
        message(STATUS "clang-tidy found: ${CLANG_TIDY_EXE}")
        set(DO_CLANG_TIDY "${CLANG_TIDY_EXE}")
    endif(NOT CLANG_TIDY_EXE)
endif(ENABLE_CLANG)

# Source -----------------------------------

add_subdirectory(src)

# Build Targets  -----------------------------------

add_executable(hdbpp_health_check ${SRC_FILES})
target_compile_features(hdbpp_health_check PUBLIC cxx_std_11)

target_link_libraries(hdbpp_health_check 
    PRIVATE Tango::Tango ${HDBPP_ES_FOUND_LIBRARIES} httplib Threads::Threads rapidjson)

target_include_directories(hdbpp_health_check 
    PRIVATE 
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src>
        ${INCLUDE_PATHS}
        "${PROJECT_BINARY_DIR}")

set_target_properties(hdbpp_health_check 
    PROPERTIES 
        OUTPUT_NAME ${HDBPP_HEALTH_CHECK_NAME}
        LINK_FLAGS "-Wl,--no-undefined"
        CXX_EXTENSIONS OFF)

if(DO_CLANG_TIDY)
    set_target_properties(hdbpp_health_check 
        PROPERTIES 
            CXX_CLANG_TIDY ${DO_CLANG_TIDY})
endif(DO_CLANG_TIDY)

target_compile_options(hdbpp_health_check
    PUBLIC -Wall -Wextra
    PRIVATE -Wall -Wextra "$<$<CONFIG:DEBUG>:-g>")

message(STATUS "Configured hdbpp-health-check project")
