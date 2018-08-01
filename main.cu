#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <iostream>
#include "solver.cuh"

void onSolutionFound(const u32 *solution) {
    std::cout << "SOLUTION FOUND: ";

    for (u32 i = 0; i < PROOFSIZE; ++i) {
        std::cout << solution[i] << ' ';
    }

    std::cout << "\n";
}

int main (int argc, char *argv[]) {
    long nthreads = 8192;
    long nonce = 0;
    long tpb = 0;
    long range = 1;
    const char *header = "";
    int c;

    while ((c = getopt (argc, argv, "h:n:r:t:p")) != -1) {
        switch (c) {
            case 'h':
                header = optarg;
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
            default:
                break;
        }
    }

    solve(header, nonce, onSolutionFound, nthreads, tpb, range);
}
