cmake_minimum_required(VERSION 3.10)

get_filename_component(CWD ${CMAKE_CURRENT_SOURCE_DIR} NAME)

project(${CWD})

set(TARGET ${CMAKE_PROJECT_NAME}.elf)

# Path settings
include_directories(include)
file(GLOB SRCS "*.c" "*.cpp")

add_executable(${TARGET} ${SRCS})

# Commands
add_custom_target(run
    COMMAND ${TARGET}
    DEPENDS ${TARGET}
)

# Options
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
