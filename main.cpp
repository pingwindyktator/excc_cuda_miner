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
    std::cout << __FUNCTION__ << '\n';
    return false;
}

void solutionf(const std::vector<uint32_t> &index_vector, size_t cbitlen, const unsigned char *compressed_sol) {
    std::cout << __FUNCTION__ << ' ';
    std::vector<int> soln;
    auto             osoln = GetMinimalFromIndices(index_vector, cbitlen);
    std::transform(osoln.begin(), osoln.end(), std::back_inserter(soln), [](unsigned char c) { return int(c); });
    std::cout << soln << '\n';
}

void hashdonef() {
    std::cout << __FUNCTION__ << '\n';
}

int main() {
    std::unique_ptr<cuda, std::function<void(cuda *)>> solver{new cuda(0, 0), [](cuda *c) { cuda::stop(*c); }};

    cuda::start(*solver);

    const char *tequihash_header = "block header";
    uint32_t    nonce            = 2;
    uint32_t    expandedNonce[8] = {0};
    expandedNonce[0]             = htole32(nonce);

    cuda::solve(tequihash_header, static_cast<unsigned int>(strlen(tequihash_header)), (const char *)&expandedNonce,
                sizeof(expandedNonce), cancelf, solutionf, hashdonef, *solver);

    return 0;
}
