cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CUDA_COMPILER /usr/local/cuda-9.2/bin/nvcc)
project(gpu_miner LANGUAGES CXX CUDA)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -O3")

FIND_PACKAGE(CUDA REQUIRED)
set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} -arch sm_35 -O3 -Xptxas -O3 -Xcompiler -O3)
include_directories(${CUDA_INCLUDE_DIRS})

set(SOURCE_FILES eqcuda1445/blake/blake2b.cpp eqcuda1445/solver.cu)

add_executable(${PROJECT_NAME} ${SOURCE_FILES} main.cu)
set_target_properties(${PROJECT_NAME} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
