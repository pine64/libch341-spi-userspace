cmake_minimum_required(VERSION 3.29)
project(pinedio-usb C)

set(CMAKE_C_STANDARD 11)

add_compile_options(-g -Wall)

add_library(pinedio-usb STATIC libpinedio-usb.c)
find_package(PkgConfig REQUIRED)
pkg_check_modules(LIBUSB REQUIRED libusb-1.0)
target_link_libraries(pinedio-usb ${LIBUSB_LIBRARIES})
target_compile_options(pinedio-usb PRIVATE ${LIBUSB_CFLAGS_OTHER})
target_include_directories(pinedio-usb PRIVATE ${LIBUSB_INCLUDE_DIRS})

add_executable(pinedio-test test.c)
target_link_libraries(pinedio-test PRIVATE pinedio-usb)
