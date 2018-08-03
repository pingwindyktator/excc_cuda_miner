#pragma once
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <iostream>
#include <fstream>
#include <algorithm>
#include <chrono>
#include "../solver.cuh"
#include "test_data.hpp"
#include "../utils.hpp"

void benchmark() {
    u64 solution_count = 0;
    u64 total_time = 0; // ms

    for (auto& data : testData) {
        std::string header = to_bytes(data.header_hex);

        auto start = std::chrono::high_resolution_clock::now();
        solve(header, data.nonce, [&] (const u32 *solution) {
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
