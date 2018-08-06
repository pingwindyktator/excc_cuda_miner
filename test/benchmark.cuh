#pragma once
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <iostream>
#include <fstream>
#include <algorithm>
#include <chrono>
#include "../eqcuda1445/solver.cuh"
#include "../utils.hpp"
#include "test_data.hpp"

void benchmark() {
    u64 solution_count = 0;
    u64 total_time = 0; // ms
    std::cout << "benchmark started...\n\n";

    for (auto& data : testData) {
        std::string header = to_bytes(data.header_hex);

        auto start = std::chrono::high_resolution_clock::now();
        solve(header, data.nonce, [&] (const proof solution) {
            ++solution_count;
        });
        auto end = std::chrono::high_resolution_clock::now();
        total_time += std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();

        if (solution_count > 100)
            break;
    }

    std::cout << "SOLUTIONS FOUND: " << solution_count << '\n';
    std::cout << "TOTAL TIME     : " << total_time << "ms" << '\n';
    std::cout << "HASHRATE       : " << double(solution_count) / total_time * 1000. << "sol/s" << '\n';
    std::cout << "HASHRATE       : " << double(solution_count) / total_time * 1000. * 60 * 60 << "sol/h" << '\n';
}
