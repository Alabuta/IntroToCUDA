﻿cmake_minimum_required (VERSION 3.14 FATAL_ERROR)

if(NOT DEFINED PROJECT_VERSION)
    set(PROJECT_VERSION 1.0.0)
endif()

project(IntroToCUDA VERSION ${PROJECT_VERSION})

enable_language(CXX)

configure_file(
    "${PROJECT_SOURCE_DIR}/config.h.in"
    "${PROJECT_SOURCE_DIR}/include/config.h"
)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${PROJECT_SOURCE_DIR}/bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${PROJECT_SOURCE_DIR}/bin")

include_directories(SYSTEM include)
include_directories(src)

option(USE_CUDA_IMPL "Use CUDA implementation" ON)

if(USE_CUDA_IMPL)
	enable_language(CUDA)

	set(PROJECT_NAME_CUDA_IMPL cuda_impl)
	set(EXTRA_LIBS ${EXTRA_LIBS} ${PROJECT_NAME_CUDA_IMPL})

	add_library(${PROJECT_NAME_CUDA_IMPL} STATIC src/lib.cu)

	include_directories(SYSTEM "$ENV{CUDA_PATH}/include")
endif()

set(SOURCE_FILES
    src/main.hxx	src/main.cxx
)

add_executable(${PROJECT_NAME} ${SOURCE_FILES})

set_target_properties(${PROJECT_NAME} PROPERTIES
    VERSION ${PROJECT_VERSION}

    CXX_STANDARD 20
    CXX_STANDARD_REQUIRED NO
    CXX_EXTENSIONS OFF

    POSITION_INDEPENDENT_CODE ON

	CMAKE_CUDA_STANDARD 17
	CMAKE_CUDA_STANDARD_REQUIRED ON
	CUDA_SEPARABLE_COMPILATION ON

    DEBUG_POSTFIX .d
)

if (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
	target_compile_options(${PROJECT_NAME} PRIVATE
        -Wpedantic
        -Wall
        -Wextra
        -Wold-style-cast
        -Wnon-virtual-dtor
        -Wcast-align
        -Wunused
        -Wconversion
        -Wsign-conversion
        -Wnull-dereference
        -Wdouble-promotion
        -Wformat=2
        -Wduplicated-cond
        -Wduplicated-branches
        -Wlogical-op
        -Wuseless-cast
        # -Wlifetime

        #-fsanitize=thread -fsanitize=address
)

elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(${PROJECT_NAME} PRIVATE
        -Wpedantic
        -Wall
        -Wextra
        -Wold-style-cast
        -Wnon-virtual-dtor
        -Wcast-align
        -Wunused
        -Wconversion
        -Wsign-conversion
        -Wnull-dereference
        -Wdouble-promotion
        -Wformat=2

        #-fsanitize=thread -fsanitize=address
)

elseif(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
    target_compile_options(${PROJECT_NAME} PRIVATE
        /W3
)
endif()

target_link_libraries(${PROJECT_NAME} PRIVATE
    #-Wl,-no-undefined
    #-Wl,-no-allow-shlib-undefined
    #-Wl,-unresolved-symbols=report-all

    #pthread

    #stdc++fs

	${EXTRA_LIBS}
)
