#pragma once
#include <functional>
#include <cstdint>


#define WN	                (144)      //
#define WK	                (5)        // algorithm parameters, prefixed with W (for Wagner) to reduce include file conflicts
#define BLAKE_PERSONAL      "ZcashPoW"
#define HEADERNONCELEN      (140)
#define NDIGITS		        (WK + 1)
#define DIGITBITS	        (WN / NDIGITS)
#define BASE                (1 << DIGITBITS)
#define PROOFSIZE           (1 << WK)
#define NHASHES             (2 * BASE)
#define HASHESPERBLAKE      (512 / WN)
#define HASHOUT             (HASHESPERBLAKE * WN / 8)
#define COMPRESSED_SOL_SIZE (PROOFSIZE * (DIGITBITS + 1) / 8)
#define MAXSOLS             (10)

typedef uint16_t u16;
typedef uint64_t u64;
typedef uint32_t u32;
typedef unsigned char uchar;
typedef u32 proof[PROOFSIZE];

enum class verify_code { POW_OK, POW_HEADER_LENGTH, POW_DUPLICATE, POW_OUT_OF_ORDER, POW_NONZERO_XOR };

inline const char *verify_code_str(verify_code code) {
    switch (code) {
        case verify_code::POW_OK:
            return "OK";
        case verify_code::POW_HEADER_LENGTH:
            return "wrong header length";
        case verify_code::POW_DUPLICATE:
            return "duplicate index";
        case verify_code::POW_OUT_OF_ORDER:
            return "indices out of order";
        case verify_code::POW_NONZERO_XOR:
            return "nonzero xor";
        default:
            return "<unknown_verify_code>";
    }
}

void cuda_init();


verify_code verify(const char *header, u64 header_len, u32 nonce, const proof indices);


int solve(const char *header, u64 header_len,
          u32 nonce,
          std::function<void(const proof)> onSolutionFound);


inline int solve(const char *header, u64 header_len,
        u32 nonce,
        void (*onSolutionFound)(const proof)) {
    return solve(header, header_len, nonce, std::function<void(const proof)>(onSolutionFound));
}
