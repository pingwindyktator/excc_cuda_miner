cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_COMPILER g++)
set(CMAKE_C_COMPILER gcc)
project(gpu_miner CXX)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")
add_subdirectory(eqcuda1445)
set(CMAKE_CUDA_DEVICE_LINK_EXECUTABLE "")

add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME} eqcuda1445)

# [[ LINKING ERRORS:
get_filename_component(CUDA_LIB_PATH ${CUDA_CUDART_LIBRARY} DIRECTORY)
find_library(CUDA_cudadevrt_LIBRARY cudadevrt PATHS ${CUDA_LIB_PATH})
target_link_libraries(${PROJECT_NAME} ${CUDA_cudadevrt_LIBRARY})
# ]]