#ifndef GPU_MINER_UTILS_HPP
#define GPU_MINER_UTILS_HPP

#include <vector>
#include <cassert>

inline void EhIndexToArray(const uint32_t i, unsigned char* array)
{
    uint32_t bei = htobe32(i);
    memcpy(array, &bei, sizeof(uint32_t));
}

inline void CompressArray(const unsigned char* in, size_t in_len,
                          unsigned char* out, size_t out_len,
                          size_t bit_len, size_t byte_pad)
{
    assert(bit_len >= 8);
    assert(8 * sizeof(uint32_t) >= 7 + bit_len);

    size_t in_width{ (bit_len + 7) / 8 + byte_pad };
    assert(out_len == bit_len*in_len / (8 * in_width));

    uint32_t bit_len_mask{ ((uint32_t)1 << bit_len) - 1 };

    // The acc_bits least-significant bits of acc_value represent a bit sequence
    // in big-endian order.
    size_t acc_bits = 0;
    uint32_t acc_value = 0;

    size_t j = 0;
    for (size_t i = 0; i < out_len; i++) {
        // When we have fewer than 8 bits left in the accumulator, read the next
        // input element.
        if (acc_bits < 8) {
            acc_value = acc_value << bit_len;
            for (size_t x = byte_pad; x < in_width; x++) {
                acc_value = acc_value | (
                        (
                                // Apply bit_len_mask across byte boundaries
                                in[j + x] & ((bit_len_mask >> (8 * (in_width - x - 1))) & 0xFF)
                        ) << (8 * (in_width - x - 1))); // Big-endian
            }
            j += in_width;
            acc_bits += bit_len;
        }

        acc_bits -= 8;
        out[i] = (acc_value >> acc_bits) & 0xFF;
    }
}

inline std::vector<unsigned char> GetMinimalFromIndices(std::vector<uint32_t> indices,
                                                 size_t cBitLen)
{
    assert(((cBitLen + 1) + 7) / 8 <= sizeof(uint32_t));
    size_t lenIndices{ indices.size()*sizeof(uint32_t) };
    size_t minLen{ (cBitLen + 1)*lenIndices / (8 * sizeof(uint32_t)) };
    size_t bytePad{ sizeof(uint32_t) - ((cBitLen + 1) + 7) / 8 };
    std::vector<unsigned char> array(lenIndices);
    for (int i = 0; i < indices.size(); i++) {
        EhIndexToArray(indices[i], array.data() + (i*sizeof(uint32_t)));
    }
    std::vector<unsigned char> ret(minLen);
    CompressArray(array.data(), lenIndices,
                  ret.data(), minLen, cBitLen + 1, bytePad);
    return ret;
}

#endif //GPU_MINER_UTILS_HPP
