#pragma once

#include <tdsp/base/math.h>

namespace tdsp {

struct Combiner {
    float scale, offset;

    // A bit flag - is a color component muted?
    uint mute;

    // A bit flag - is a color component inverted?
    uint invert;

    float operator()(float x, uint i) const {
        static uint const flags[] = {1, 2, 4, 8, 16, 32, 64, 128};
        THROW_IF_GE(i, std::end(flags) - std::begin(flags), "flags");
        if (flags[i] & mute)
            return 0;
        auto r = (x * scale) + offset;
        return (flags[i] & invert) ? tdsp::invert(r) : r;
    }
};

} // tdsp
