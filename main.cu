#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <iostream>
#include <fstream>
#include <algorithm>
#include "solver.cuh"
#include "test/test.cuh"
#include "test/benchmark.cuh"
#include "utils.hpp"

void onSolutionFound(const u32 *solution) {
    std::cout << "SOLUTION FOUND:\n";

    for (u32 i = 0; i < PROOFSIZE; ++i) {
        std::cout << solution[i] << ' ';
    }
    std::cout << "\n";
    std::string csol = compress_solution(solution);
    std::string solution_hex = to_hex((const unsigned char *)csol.c_str(), csol.length());
    std::cout << solution_hex;


    std::cout << "\n================================================================================================================================\n";
}

int main (int argc, char *argv[]) {
    checkCudaErrors(cudaSetDeviceFlags(cudaDeviceScheduleYield));

    long nthreads = 8192;
    long nonce = 0;
    long tpb = 0;
    long range = 1;
    std::string header;
    int c;

    while ((c = getopt (argc, argv, "h:x:n:r:t:p:T:B")) != -1) {
        switch (c) {
            case 'h':
                header = std::string{optarg};
                break;
            case 'x':
                header = to_bytes(optarg);
                break;
            case 'n':
                nonce = strtol(optarg, nullptr, 10);
                break;
            case 't':
                nthreads = strtol(optarg, nullptr, 10);
                break;
            case 'p':
                tpb = strtol(optarg, nullptr, 10);
                break;
            case 'r':
                range = strtol(optarg, nullptr, 10);
                break;
            case 'T':
                return test();
            case 'B':
                benchmark();
                return 0;
            default:
                break;
        }
    }

    solve(header, nonce, onSolutionFound, nthreads, tpb, range);
}
