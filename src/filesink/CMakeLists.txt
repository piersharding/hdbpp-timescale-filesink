cmake_minimum_required(VERSION 3.11)
project(hdbpp-filesink)

# C++14 required
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# FileSink library (header-only)
add_library(filesink INTERFACE)
target_include_directories(filesink INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# Example/test program
add_executable(filesink_example example.cpp)
target_link_libraries(filesink_example PRIVATE filesink pthread)

# Unit tests
add_executable(filesink_test test.cpp)
target_link_libraries(filesink_test PRIVATE filesink)

# Install headers
install(FILES
    FileSinkConfig.h
    CSVWriter.h
    TableWriter.h
    FileSink.h
    DESTINATION include/filesink
)
