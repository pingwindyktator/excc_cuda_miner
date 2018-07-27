#include <cstring>
#include <iostream>
#include <iostream>
#include <memory>
#if defined USE_CUDA_DJEZO
#include "cuda_djezo/cuda_djezo.hpp"
#define cuda cuda_djezo
#elif defined USE_CUDA_TROMP
#include "cuda_tromp/cuda_tromp.hpp"
#define cuda cuda_tromp
#endif
#include "prettyprint.hpp"
#include "utils.hpp"

bool cancelf() {
    return false;
}

void solutionf(const std::vector<uint32_t> &index_vector, size_t cbitlen, const unsigned char *compressed_sol) {
    std::vector<int> soln;
    auto             osoln = GetMinimalFromIndices(index_vector, cbitlen);
    std::transform(osoln.begin(), osoln.end(), std::back_inserter(soln), [](unsigned char c) { return int(c); });
    for (auto s : index_vector) {
        std::cout << int(s) << ' ';
    }

    std::cout << '\n';
}

void hashdonef() {
}

int main() {
    std::unique_ptr<cuda, std::function<void(cuda *)>> solver{new cuda(0, 0), [](cuda *c) { cuda::stop(*c); }};

    cuda::start(*solver);

    const char *input = "block header";
    const auto *tequihash_header = reinterpret_cast<const unsigned char *>(input);
    uint32_t    nonce            = 1;

    cuda::solve(tequihash_header, static_cast<unsigned int>(strlen(input)), nonce, cancelf, solutionf, hashdonef, *solver);

    return 0;
}
