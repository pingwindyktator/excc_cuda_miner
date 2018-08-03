#pragma once
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <iostream>
#include <fstream>
#include <algorithm>
#include "../solver.cuh"
#include "test_data.hpp"
#include "../utils.hpp"

int test() {
    bool all_ok = true;

    for (auto& data : testData) {
        bool ok = false;
        std::string header = to_bytes(data.header_hex);

        solve(header, data.nonce, [&] (const u32 *solution) {
            std::string csol = compress_solution(solution);
            std::string solution_hex = to_hex((const unsigned char *)csol.c_str(), csol.length());

            ok |= (solution_hex == data.solution_hex);
        });

        if (!ok) {
            std::cout << "TEST FAILED FOR HEADER: \"" << data.header_hex << "\", NONCE: " << data.nonce << '\n';
            all_ok = false;
        }
        else {
            std::cout << "OK\n";
        }
    }

    if (all_ok) {
        std::cout << "ALL TESTS PASSED\n";
        return 0;
    }

    return 1;
}
