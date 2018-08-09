cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
message(FATAL_ERROR "cmake wont work now, please use build scripts")
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CUDA_COMPILER /usr/local/cuda-9.2/bin/nvcc)
project(eqcuda1445 LANGUAGES CXX CUDA)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -O3")

FIND_PACKAGE(CUDA 8.0 REQUIRED)

set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} -arch sm_35 -O3 -Xptxas -O3 -Xcompiler -O3)
include_directories(${CUDA_INCLUDE_DIRS})

set(SOURCE_FILES blake/blake2b.cpp solver.cu)
add_library(${PROJECT_NAME} SHARED ${SOURCE_FILES})
set_target_properties(${PROJECT_NAME} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
target_link_libraries(${PROJECT_NAME} ${CUDA_LIBRARIES})