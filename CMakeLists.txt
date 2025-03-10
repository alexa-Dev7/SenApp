cmake_minimum_required(VERSION 3.10)

project(uws-server)

set(CMAKE_CXX_STANDARD 17)

find_package(OpenSSL REQUIRED)
find_package(ZLIB REQUIRED)

include_directories(/usr/local/include)

add_executable(uws-server main.cpp)
target_link_libraries(uws-server uWS ssl z pthread)
