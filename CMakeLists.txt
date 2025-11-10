cmake_minimum_required(VERSION 3.31)
project(vcpkg-ports-builder)

find_package( slang-rhi CONFIG REQUIRED )

add_executable( test main.cpp )
target_link_libraries(test PUBLIC slang::slang-rhi)