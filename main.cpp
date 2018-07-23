#include <cstring>
#include <iostream>
#include <memory>
#include "cuda_djezo/cuda_djezo.hpp"
#include <iostream>
#include "prettyprint.hpp"


bool cancelf() {
    std::cout << __FUNCTION__ << '\n';
    return false;
}

void solutionf(const std::vector<uint32_t> &index_vector, size_t DIGITBITS, const unsigned char *) {
    std::cout << __FUNCTION__ << ' ' << index_vector << '\n';
}

void hashdonef() {
    std::cout << __FUNCTION__ << '\n';
}

int main() {
    std::unique_ptr<cuda_djezo, std::function<void(cuda_djezo *)>> solver{new cuda_djezo(0, 0),
                                                                          [](cuda_djezo *c) { cuda_djezo::stop(*c); }};

    cuda_djezo::start(*solver);

    const char *tequihash_header = "block header";
    const char *nonce            = "2";

    cuda_djezo::solve(tequihash_header, static_cast<unsigned int>(strlen(tequihash_header)), nonce,
                      static_cast<unsigned int>(strlen(nonce)), cancelf, solutionf, hashdonef, *solver);

    return 0;
}
