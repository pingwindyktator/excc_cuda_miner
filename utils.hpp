#pragma once
#include <vector>
#include <cassert>
#include "eqcuda1445/solver.cuh"


inline std::string to_bytes(const std::string& hex) {
    std::string bytes;

    for (u64 i = 0; i < hex.length(); i += 2) {
        std::string byteString = hex.substr(i, 2);
        char byte = (char) strtol(byteString.c_str(), nullptr, 16);
        bytes += byte;
    }

    return bytes;
}

inline std::string compress_solution(const proof sol) {
    unsigned char csol[COMPRESSED_SOL_SIZE];
    uchar b;

    for (u32 i = 0, j = 0, bits_left = DIGITBITS + 1;
         j < COMPRESSED_SOL_SIZE; csol[j++] = b) {
        if (bits_left >=8) {
            // Read next 8 bits, stay at same sol index
            b = sol[i] >> (bits_left -= 8);
        } else { // less than 8 bits to read
            // Read remaining bits and shift left to make space for next sol index
            b = sol[i];
            b <<= (8 - bits_left); // may also set b=0 if bits_left was 0, which is fine
            // Go to next sol index and read remaining bits
            bits_left += DIGITBITS + 1 - 8;
            b |= sol[++i] >> bits_left;
        }
    }

    return std::string((const char *)csol, COMPRESSED_SOL_SIZE);
}

inline std::string to_hex(const unsigned char *data, u64 len) {
    static const char hexmap[] = {'0', '1', '2', '3', '4', '5', '6', '7',
                                  '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};

    std::string s(len * 2, ' ');
    for (u64 i = 0; i < len; ++i) {
        s[2 * i]     = hexmap[(data[i] & 0xF0) >> 4];
        s[2 * i + 1] = hexmap[data[i] & 0x0F];
    }
    return s;
}
