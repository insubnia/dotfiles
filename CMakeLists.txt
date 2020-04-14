cmake_minimum_required(VERSION 3.10)

get_filename_component(CWD ${CMAKE_CURRENT_SOURCE_DIR} NAME)

project(${CWD})

include_directories(include)

# Target
set(TARGET ${CMAKE_PROJECT_NAME}.elf)

# Source files
file(GLOB SRCS "*.c" "*.cpp")

add_executable(${TARGET} ${SRCS})
add_custom_target(run
    COMMAND ${TARGET}
    DEPENDS ${TARGET}
)
