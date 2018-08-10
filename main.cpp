#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <iostream>
#include <fstream>
#include <algorithm>
#include "eqcuda1445/eqcuda1445.cuh"
#include "test/test.hpp"
#include "test/benchmark.hpp"
#include "utils.hpp"

void onSolutionFound(const cproof solution) {
    std::cout << "SOLUTION FOUND:\n";

    for (u32 i = 0; i < COMPRESSED_SOL_SIZE; ++i) {
        std::cout << int(solution[i]) << ' ';
    }
    std::cout << "\n";
    std::string solution_hex = to_hex(solution, COMPRESSED_SOL_SIZE);
    std::cout << solution_hex;


    std::cout << "\n================================================================================================================================\n";
}

int main (int argc, char *argv[]) {
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

    equihash_solve(header.c_str(), header.length(), nonce, onSolutionFound);
}
