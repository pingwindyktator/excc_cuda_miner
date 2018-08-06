#pragma once
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <iostream>
#include <fstream>
#include <algorithm>
#include "../eqcuda1445/solver.cuh"
#include "../utils.hpp"
#include "test_data.hpp"

int test(long max_tests) {
    u64 tests = 0;
    std::cout << "test started...\n\n";

    for (auto& data : testData) {
        bool ok = false, verify_ok = true;
        verify_code verify_err = POW_DUPLICATE;
        std::string header = to_bytes(data.header_hex);
        ++tests;

        solve(header, data.nonce, [&] (const proof solution) {
            std::string csol = compress_solution(solution);
            std::string solution_hex = to_hex((const unsigned char *)csol.c_str(), csol.length());

            ok |= (solution_hex == data.solution_hex);
            verify_err = verify(solution, header, data.nonce);
            verify_ok &= (verify_err == POW_OK);
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
