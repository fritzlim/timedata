#pragma once

#include <ctype.h>
#include <cmath>
#include <cstddef>
#include <iomanip>
#include <sstream>
#include <type_traits>

#include <timedata/base/math.h>

namespace timedata {

template <typename Number,
     typename std::enable_if<std::is_unsigned<Number>::value, int>::type>
Number abs(Number x) {
    return x;
}

template <typename Number,
     typename std::enable_if<std::is_signed<Number>::value, int>::type>
Number abs(Number x) {
    return x >= 0 ? x : -x;
}

template <typename Number>
Number absoluteDifference(Number x, Number y) {
    return (x > y) ? (x - y) : (y - x);
}

template <typename Number>
bool near(Number x, Number y, Number diff) {
    return absoluteDifference(x, y) <= diff;
}

template <typename Number>
bool near(Number x, Number y) {
    return near(x, y, Number(0.000001));
}

template <typename Number>
bool shift(Number& number) {
    auto result = bool(number & 1);
    number /= 2;
    return result;
}

template <typename Number>
Number trunc(Number);

template <typename T,
    typename std::enable_if<std::is_integral<T>::value, int>::type>
T trunc(T x) {
    return x;
}

template <typename T,
    typename std::enable_if<std::is_floating_point<T>::value, int>::type>
T trunc(T x) {
    return std::trunc(x);
}

inline bool isHex(char const* s) {
    return not s[strspn(s, "abcdef0123456789")];
}

inline uint64_t fromHex(char const* s) {
    long long unsigned decimalValue;
    sscanf(s, "%llu", &decimalValue);
    return decimalValue;
}

inline bool fromHexWithPrefix(char const* s, unsigned& result) {
    if (s[0] == '#')
        s++;
    else if (not (strncmp("0x", s, 2) and strncmp("0X", s, 2)))
        s += 2;
    if (not (strlen(s) == 6 and isHex(s)))
        return false;
    sscanf(s, "%u", &result);
    return true;
 }

// TODO: move elsewhere.
template <typename Collection>
std::string commaSeparated(Collection const& collection, int decimals) {
    std::string result;

    bool first = true;
    for (auto& c: collection) {
        if (first)
            first = false;
        else
            result += ", ";
        result += toString(c, decimals);
    }
    return result;
}

PowArray const& powArray() {
    static const PowArray array{{
        1ULL,
        10ULL,
        100ULL,
        1000ULL,
        10000ULL,
        100000ULL,
        1000000ULL,
        10000000ULL,
        100000000ULL,
        1000000000ULL,
        10000000000ULL,
        100000000000ULL,
        1000000000000ULL,
        10000000000000ULL,
        100000000000000ULL,
        1000000000000000ULL,
        10000000000000000ULL,
        100000000000000000ULL,
        1000000000000000000ULL,
        10000000000000000000ULL
    }};
    return array;
}

inline uint64_t pow10(unsigned log) {
    return powArray()[log];
}

inline unsigned log10(uint64_t exp) {
    auto& pa = powArray();
    unsigned b = std::upper_bound(pa.begin(), pa.end(), exp) - pa.begin();
    return std::max(b, unsigned(1)) - 1;
}

inline void removeTrailing(std::string& s, char ch) {
    auto i = s.size();
    for (; i > 0 and s[i - 1] == ch; --i);
    s.resize(i);
}

/** Convert a float to a string. */
inline std::string toString(float x, unsigned int decimals) {
    // Add 1 for the - sign and one for the .
    size_t size = log10(static_cast<uint64_t>(std::abs(x))) + 3 + decimals + 2;
    std::string number(size, ' ');
    number.resize(snprintf(&number[0], size, "%1.*f", decimals, x));
    if (number.find('.') != std::string::npos) {
        removeTrailing(number, '0');
        removeTrailing(number, '.');
    }
    return number;
}

template <typename T>
void skipSpaces(T* p) {
    for (; isspace(*p); ++p);
}

inline bool isNearFraction(float decimal, unsigned int denominator) {
    auto numerator = denominator * decimal;
    return std::abs(std::round(numerator) - numerator) < 0.0001f;
}

inline bool cmpToRichcmp(float diff, int richcmp) {
    switch (richcmp) {
        case 0: return diff < 0;
        case 1: return diff <= 0;
        case 2: return diff == 0;
        case 3: return diff != 0;
        case 4: return diff > 0;
        case 5: return diff >= 0;
        default:
            log("Bad richcmp", richcmp, diff);
            return false;
    }
}

template <typename C1, typename C2>
int compareContainers(C1 const& c1, C2 const& c2) {
    auto i1 = c1.begin();
    auto i2 = c2.begin();
    int i = 0;
    for (; i1 != c1.end() and i2 != c2.end(); ++i1, ++i2, ++i) {
        if (*i1 < *i2)
            return -1;
        if (*i1 > *i2)
            return 1;
    }
    if (i1 != c1.end())
        return 1;
    if (i2 != c2.end())
        return -1;
    return 0;
}

inline float divideByZero(float x) {
    if (x > 0)
        return std::numeric_limits<float>::infinity();
    if (x < 0)
        return -std::numeric_limits<float>::infinity();
    return std::nanf(nullptr);
}

inline float divPython(float x, float y) {
    return y ? (x / y) : divideByZero(x);
}

inline float powPython(float x, float y) {
    if (x > 0)
        return pow(x, y);
    if (x < 0)
        return -pow(-x, y);
    return y ? 0.0f : 1.0f;
}

inline float modPython(float x, float y) {
    /*
    In Python:
        for n, d in itertools.product((7, -7), (3, -3)):
            print('%s %% %s = %s' % (n, d, n % d))
         7 %  3 =  1
         7 % -3 = -2
        -7 % -3 = -1
        -7 %  3 =  2
*/
    if (not y)
        return divideByZero(x);

    auto d = int(x / y);
    auto mod = x - y * d;

    auto sameSigns = (x >= 0) == (y >= 0);
    return sameSigns ? mod : mod - y;
}

template <typename Collection>
typename Collection::value_type hashPython(Collection const& c) {
    // http://stackoverflow.com/a/2909572/43839
    using value_type = typename Collection::value_type;
    static value_type const mult = 101;
    value_type h = 0;
    for (auto& i: c)
        (h *= mult) += i;
    return mult * h;
}

template <typename Number>
Number roundPython(Number x, unsigned digits) {
    auto r = static_cast<Number>(pow10(digits));
    return std::round(x * r) / r;
}

}  // namespace timedata
