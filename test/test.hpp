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
    std::cout << "test started...\n\n";

    for (auto& data : testData) {
        bool ok = false, verify_ok = true;
        verify_code verify_err = verify_code::POW_DUPLICATE;
        std::string header = to_bytes(data.header_hex);
        ++tests;

        equihash_solve(header.c_str(), header.length(), data.nonce, [&](const cproof solution)
        {
            std::string solution_hex = to_hex(solution, COMPRESSED_SOL_SIZE);

            ok |= (solution_hex == data.solution_hex);
//            verify_err = equihash_verify(header.c_str(), header.length(), data.nonce, solution); // TODO equihash_verify takes proof, not cproof
//            verify_ok &= (verify_err == verify_code::POW_OK);
        });

        if (!ok || !verify_ok) {
            std::cout << "TEST FAILED FOR HEADER: \"" << data.header_hex << "\", NONCE: " << data.nonce << '\n';
            if (!ok) std::cout << "GIVEN SOLUTION NOT FOUND\n";
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
