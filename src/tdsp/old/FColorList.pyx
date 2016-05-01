cdef extern from "tdsp/FColorList.h" namespace "tdsp":
    cdef cppclass FColorList:
        FColor& at(size_t pos)
        void combine(FColorList)
        void copy(FColorList)
        size_t count(FColor)
        void extend(FColorList)
        void eraseOne(size_t pos)
        void eraseRange(size_t b, size_t e)
        void gamma(float)
        const FColor& get(size_t pos)
        long index(FColor)
        void insertRange(size_t b1, FColorList, size_t b2, size_t e2)
        FColorList interpolate(FColorList, float ratio, unsigned int smooth)
        void push_back(FColor)
        void resize(size_t size)
        void reserve(size_t size)
        void reverse()
        void scale(float)
        void set(size_t pos, FColor)
        void setAll(FColor)
        size_t size()
        void sort()