#pragma once
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <iostream>
#include <fstream>
#include <algorithm>
#include "../eqcuda1445/eqcuda1445.cuh"
#include "../utils.hpp"
#include "test_data.hpp"

int test(long max_tests) {
    u64 tests = 0;
    std::cout << "test started...\n";

    for (auto& data : testData) {
        bool ok = false, verify_ok = true;
        verify_code verify_err = verify_code::POW_DUPLICATE;
        std::string header = to_bytes(data.header_hex);
        ++tests;
        std::vector<std::string> actual_sols;

        equihash_solve(header, data.nonce, [&](const cproof solution)
        {
            std::string solution_hex = to_hex(solution, COMPRESSED_SOL_SIZE);
            actual_sols.push_back(solution_hex);

            ok |= (solution_hex == data.solution_hex);
            verify_err = equihash_verify(header, data.nonce, solution);
            verify_ok &= (verify_err == verify_code::POW_OK);
        });

        if (!ok || !verify_ok) {
            std::cout << "TEST FAILED FOR HEADER: \"" << data.header_hex << "\", NONCE: " << data.nonce << '\n';
            if (!ok) {
                std::cout << "EXPECTED SOLUTION NOT FOUND. SOLUTIONS FOUND:\n";
                for (auto&& sol : actual_sols) std::cout << sol << '\n';
                std::cout << "EXPECTED SOLUTION:\n";
                std::cout << data.solution_hex << '\n';
            }
            if (!verify_ok) std::cout << "VERIFICATION FAILED: " << verify_code_str(verify_err) << '\n';
            return 1;
        }

        if (tests >= max_tests) {
            break;
        }
    }


    std::cout << "ALL TESTS PASSED\n";
    return 0;
}
