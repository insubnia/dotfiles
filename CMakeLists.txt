cmake_minimum_required(VERSION 3.16)

get_filename_component(CWD ${CMAKE_CURRENT_SOURCE_DIR} NAME)

project({CWD})

file(GLOB SRCS "*.c" "*.cpp")

include_directories(include)

add_executable(${CWD}.elf ${SRCS})
