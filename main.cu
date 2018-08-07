#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <iostream>
#include <fstream>
#include <algorithm>
#include "eqcuda1445/eqcuda1445.cuh"
#include "test/test.cuh"
#include "test/benchmark.cuh"
#include "utils.hpp"

void onSolutionFound(const proof solution) {
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
    cuda_init();

    u32 nonce = 0;
    std::string header;
    int c;

    while ((c = getopt (argc, argv, "h:x:n:T:B")) != -1) {
        switch (c) {
            case 'h':
                header = std::string{optarg};
                break;
            case 'x':
                header = to_bytes(optarg);
                break;
            case 'n':
                nonce = static_cast<u32>(strtoul(optarg, nullptr, 10));
                break;
            case 'T':
                return test(strtol(optarg, nullptr, 10));
            case 'B':
                benchmark();
                return 0;
            default:
                break;
        }
    }

    solve(header.c_str(), header.length(), nonce, onSolutionFound);
}
