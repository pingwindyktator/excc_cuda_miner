cmake_minimum_required(VERSION 3.10)
project(gpu_miner)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Og")

option(USE_CUDA_TROMP "USE CUDA_TROMP" ON)
option(USE_CUDA_DJEZO "USE CUDA_DJEZO" OFF)

# CUDA DJEZO ###################
if (USE_CUDA_DJEZO)
    add_definitions(-DUSE_CUDA_DJEZO)
    add_subdirectory(cuda_djezo)
endif()
################################

# CUDA TROMP ###################
if (USE_CUDA_TROMP)
    add_definitions(-DUSE_CUDA_TROMP)
    add_subdirectory(cuda_tromp)
endif()
################################

# OPTIMIZATIONS ################
if(CMAKE_COMPILER_IS_GNUCXX)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m64 -msse2")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m64 -msse2")
    add_definitions(-Og)
endif()
################################

# BOOST ########################
set(Boost_USE_STATIC_LIBS ON)
set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
find_package(Boost REQUIRED COMPONENTS system log_setup log date_time filesystem thread)
if (Boost_FOUND)
    include_directories (SYSTEM ${Boost_INCLUDE_DIR})
    link_directories (${Boost_LIBRARY_DIRS})
else()
    message("Boost_FOUND NOT FOUND")
endif ()
set(LIBS ${LIBS} ${Boost_LIBRARIES})
###############################

set(SOURCE_FILES
    main.cpp
    utils.hpp
    blake2/blake2bx.cpp
    blake2/blake2.h
    blake2/blake2b-load-sse2.h
    blake2/blake2b-load-sse41.h
    blake2/blake2b-round.h
    blake2/blake2-config.h
    blake2/blake2-impl.h
    blake2/blake2-round.h)


add_executable(${PROJECT_NAME} ${SOURCE_FILES})
if (USE_CUDA_TROMP)
    target_link_libraries(${PROJECT_NAME} cuda_tromp)
endif()
if (USE_CUDA_DJEZO)
    target_link_libraries(${PROJECT_NAME} cuda_djezo)
endif()
