#pragma once
#include <functional>
#include <cstdint>

// algorithm parameters, prefixed with W (for Wagner) to reduce include file conflicts
#ifndef WN
#define WN	144
#endif

#ifndef WK
#define WK	5
#endif

#ifndef HEADERNONCELEN
#define HEADERNONCELEN 140
#endif

#ifndef BLAKE_PERSONAL
#define BLAKE_PERSONAL "ZcashPoW"
#endif

#define NDIGITS		(WK+1)
#define DIGITBITS	(WN/(NDIGITS))

typedef uint16_t u16;
typedef uint64_t u64;
typedef uint32_t u32;
typedef unsigned char uchar;
static const u32 BASE = 1<<DIGITBITS;
static const u32 PROOFSIZE = 1<<WK;
static const u32 NHASHES = 2*BASE;
static const u32 HASHESPERBLAKE = 512/WN;
static const u32 HASHOUT = HASHESPERBLAKE*WN/8;
static const u32 COMPRESSED_SOL_SIZE = (PROOFSIZE * (DIGITBITS + 1) / 8);
static const u32 MAXSOLS = 10; // nothing larger found in 100000 runs
typedef u32 proof[PROOFSIZE];

enum verify_code { POW_OK, POW_HEADER_LENGTH, POW_DUPLICATE, POW_OUT_OF_ORDER, POW_NONZERO_XOR };

inline std::string verify_code_str(verify_code code) {
    switch (code) {
        case POW_OK:
            return "OK";
        case POW_HEADER_LENGTH:
            return "wrong header length";
        case POW_DUPLICATE:
            return "duplicate index";
        case POW_OUT_OF_ORDER:
            return "indices out of order";
        case POW_NONZERO_XOR:
            return "nonzero xor";
        default:
            return "<unknown_verify_code>";
    }
}

#define checkCudaErrors(ans) { gpuAssert((ans), __FILE__, __LINE__); } // TODO automatic
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true) {
    if (code != cudaSuccess) {
        fprintf(stderr, "GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
        if (abort) exit(code);
    }
}

int solve(const std::string &header,
        u32 nonce, std::function <void(const proof)> onSolutionFound,
        u64 nthreads = 8192,
        u64 tpb = 0,
        u64 range = 1,
        bool debug_logs = false);

verify_code verify(const proof indices, const std::string &header, u32 nonce);
