# Automatically generated by ./make_generated_classes.py from src/tdsp/color/color_list.template.pyx

from numbers import Number

cdef class _ColorList256:
    """A list of RGB floating point Colors, with many mutating functions.

       A ColorList looks quite like a Python list of Colors (which look like
       tuples) with the big interface difference that operations like + and *
       perform arithmetic and not list construction.

       Written in C++, this class should consume significantly fewer memory and
       CPU resources than a corresponding Python list, as well as providing a
       range of useful facilities.

       While ColorList provides a full set of functions and operations that
       create new ColorLists, in each case there is a corresponding mutating
       function or operation that works "in-place" with no heap allocations
       at all, for best performance.

       The base class ColorList is a list of Color, which are normalized to
       [0, 1]; the derived class ColorList256 is a list of Color256, which
       are normalized to [0, 255].
"""
    cdef ColorVector colors

    def __cinit__(self, items=None):
        """Construct a ColorList with an iterator of items, each of which looks
           like a Color."""
        if items is not None:
            if isinstance(items, _ColorList256):
                self.colors = (<_ColorList256> items).colors
            else:
                # A list of tuples, Colors or strings.
                self.colors.resize(len(items))
                for i, item in enumerate(items):
                    self[i] = item

    def __setitem__(self, object key, object x):
        cdef size_t length, slice_length
        cdef int begin, end, step, index
        cdef float r, g, b
        cdef _ColorList256 cl
        if isinstance(key, slice):
            begin, end, step = key.indices(self.colors.size())
            if sliceIntoVector(_to_ColorList256(x).colors, self.colors,
                               begin, end, step):
                return
            raise ValueError('attempt to assign sequence of one size '
                             'to extended slice of another size')
        index = key
        if not self.colors.fixKey(index):
            raise IndexError('ColorList index out of range ' + str(index))
        try:
            if isinstance(x, str):
                x = _Color256(x)
            r, g, b = x
            self.colors.setColor(index, r, g, b)
        except:
            raise ValueError('Can\'t convert ' + str(x) + ' to a color')

    def __getitem__(self, object key):
        cdef ColorS c
        cdef int index
        if isinstance(key, slice):
            begin, end, step = key.indices(self.colors.size())
            cl = _ColorList256()
            cl.colors = sliceVector(self.colors, begin, end, step)
            return cl

        index = key
        if not self.colors.fixKey(index):
            raise IndexError('ColorList index out of range ' + str(key))

        c = self.colors[index]
        return _Color256(c.red, c.green, c.blue)

    # Unary operators and corresponding mutators.
    cpdef abs(self):
        """Replace each color by its absolute value."""
        absColor(self.colors)
        return self

    def __abs__(self):
        cdef _ColorList256 cl = _ColorList256()
        cl.colors = self.colors
        cl.abs()
        return cl

    cpdef ceil(self):
        """Replace each color by its absolute value."""
        ceilColor(self.colors)
        return self

    def __ceil__(self):
        cdef _ColorList256 cl = _ColorList256()
        cl.colors = self.colors
        cl.ceil()
        return cl

    cpdef floor(self):
        """Replace each color by its floorolute value."""
        floorColor(self.colors)
        return self

    def __floor__(self):
        cdef _ColorList256 cl = _ColorList256()
        cl.colors = self.colors
        cl.floor()
        return cl

    cpdef invert(self):
        """Invert each color to its complement."""
        invertColor(self.colors)
        return self

    def __invert__(self):
        cdef _ColorList256 cl = _ColorList256()
        cl.colors = self.colors
        cl.invert()
        return cl

    cpdef neg(self):
        """Negate each color."""
        negateColor(self.colors)
        return self

    def __neg__(self):
        cdef _ColorList256 cl = _ColorList256()
        cl.colors = self.colors
        cl.negative()
        return cl

    cpdef round(self):
        """Round each color value to the nearest integer."""
        roundColor(self.colors)
        return self

    def __round__(self):
        cdef _ColorList256 cl = _ColorList256()
        cl.colors = self.colors
        cl.round()
        return cl

    cpdef trunc(self):
        """Truncate each value to an integer."""
        truncColor(self.colors)
        return self

    def __trunc__(self):
        cdef _ColorList256 cl = _ColorList256()
        cl.colors = self.colors
        cl.trunc()
        return cl

    cpdef append(self, object value):
        """Append to the list of colors."""
        cdef uint s
        s = self.colors.size()
        self.colors.resize(s + 1)
        try:
            self[s] = value
        except:
            self.colors.resize(s)
            raise
        return self

    cpdef hsv_to_rgb(self):
        """Convert each color in the list from HSV to RBG."""
        hsvToRgbInto(self.colors, integer)
        return self

    cpdef rgb_to_hsv(self):
        """Convert each color in the list from RBG to HSV."""
        rgbToHsvInto(self.colors, integer)
        return self

    cpdef clear(self):
        """Set all colors to black."""
        self.colors.clear()
        return self

    cpdef rotate(self, int pos):
        """In-place rotation of the colors forward by `pos` positions."""
        rotate(self.colors, pos)
        return self

    cpdef reverse(self):
        """Reverse the colors in place."""
        reverse(self.colors)
        return self

    cpdef duplicate(self, uint count):
        """Return a new `ColorList` with `count` copies of this one."""
        cl = _ColorList256()
        cl.colors = duplicate(self.colors, count)
        return cl

    cpdef extend(self, object values):
        """Extend the colors from an iterator."""
        cdef size_t s
        s = self.colors.size()
        try:
            for v in values:
                self.append(v)
        except:
            self.colors.resize(s)
            raise
        return self

    cpdef max_limit(self, float max):
        """Limit each color to be not greater than max."""
        if isinstance(max, Number):
            maxInto(<float> max, self.colors)
        else:
            maxInto(_to_ColorList256(max).colors, self.colors)
        return self

    cpdef min_limit(self, float min):
        """Limit each color to be not less than min."""
        if isinstance(min, Number):
            minInto(<float> min, self.colors)
        else:
            minInto(_to_ColorList256(min).colors, self.colors)
        return self

    cpdef pow(self, float c):
        """Raise each color to the given power (gamma correction)."""
        if isinstance(c, Number):
            powInto(<float> c, self.colors)
        else:
            powInto(_to_ColorList256(c).colors, self.colors)
        return self

    cpdef resize(self, size_t size):
        """Set the size of the ColorList, filling with black if needed."""
        self.colors.resize(size)
        return self

    cpdef rpow(self, c):
        """Right-hand (reversed) call of pow()."""
        if isinstance(c, Number):
            rpowInto(<float> c, self.colors)
        else:
            rpowInto(_to_ColorList256(c).colors, self.colors)
        return self

    # Mutating operations.
    def __iadd__(self, c):
        if isinstance(c, Number):
            addInto(<float> c, self.colors)
        else:
            addInto(_to_ColorList256(c).colors, self.colors)
        return self

    def __imul__(self, c):
        if isinstance(c, Number):
            multiplyInto(<float> c, self.colors)
        else:
            multiplyInto(_to_ColorList256(c).colors, self.colors)
        return self

    def __ipow__(self, c):
        if isinstance(c, Number):
             powInto(<float> c, self.colors)
        else:
             powInto(_to_ColorList256(c).colors, self.colors)
        return self

    def __isub__(self, c):
        if isinstance(c, Number):
             subtractInto(<float> c, self.colors)
        else:
             subtractInto(_to_ColorList256(c).colors, self.colors)
        return self

    def __itruediv__(self, c):
        if isinstance(c, Number):
            divideInto(<float> c, self.colors)
        else:
            divideInto(_to_ColorList256(c).colors, self.colors)
        return self

    def __add__(self, c):
        cdef _ColorList256 cl = _ColorList256()

        if isinstance(c, Number):
            addOver((<_ColorList256> self).colors, <float> c, cl.colors)
        elif isinstance(self, _ColorList256):
            addOver((<_ColorList256> self).colors,
                    _to_ColorList256(c).colors, cl.colors)
        elif isinstance(self, Number):
            addOver(<float> self, _to_ColorList256(c).colors, cl.colors)
        else:
            addOver(_ColorList256(self).colors,
                    (<_ColorList256> c).colors, cl.colors)
        return cl

    def __mul__(self, c):
        cdef _ColorList256 cl = _ColorList256()

        if isinstance(c, Number):
            mulOver((<_ColorList256> self).colors, <float> c, cl.colors)
        elif isinstance(self, _ColorList256):
            mulOver((<_ColorList256> self).colors,
                    _to_ColorList256(c).colors, cl.colors)
        elif isinstance(self, Number):
            mulOver(<float> self, _to_ColorList256(c).colors, cl.colors)
        else:
            mulOver(_ColorList256(self).colors,
                    (<_ColorList256> c).colors, cl.colors)
        return cl

    def __pow__(self, c, mod):
        cdef _ColorList256 cl = _ColorList256()
        if mod:
            raise ValueError('Can\'t handle three operator pow')

        if isinstance(c, Number):
            powOver((<_ColorList256> self).colors, <float> c, cl.colors)
        elif isinstance(self, _ColorList256):
            powOver((<_ColorList256> self).colors,
                    _to_ColorList256(c).colors, cl.colors)
        elif isinstance(self, Number):
            powOver(<float> self, _to_ColorList256(c).colors, cl.colors)
        else:
            powOver(_ColorList256(self).colors,
                    (<_ColorList256> c).colors, cl.colors)
        return cl

    def __sub__(self, c):
        cdef _ColorList256 cl = _ColorList256()

        if isinstance(c, Number):
            subOver((<_ColorList256> self).colors, <float> c, cl.colors)
        elif isinstance(self, _ColorList256):
            subOver((<_ColorList256> self).colors,
                    _to_ColorList256(c).colors, cl.colors)
        elif isinstance(self, Number):
            subOver(<float> self, _to_ColorList256(c).colors, cl.colors)
        else:
            subOver(_ColorList256(self).colors,
                    (<_ColorList256> c).colors, cl.colors)
        return cl

    def __truediv__(self, c):
        cdef _ColorList256 cl = _ColorList256()
        if isinstance(c, Number):
            divOver((<_ColorList256> self).colors, <float> c, cl.colors)
        elif isinstance(self, _ColorList256):
            divOver((<_ColorList256> self).colors,
                    _to_ColorList256(c).colors, cl.colors)
        elif isinstance(self, Number):
            divOver(<float> self, _to_ColorList256(c).colors, cl.colors)
        else:
            divOver(_ColorList256(self).colors,
                    (<_ColorList256> c).colors, cl.colors)
        return cl

    def __len__(self):
        return self.colors.size()

    def __repr__(self):
        return '_ColorList256(%s)' % str(self)

    def __richcmp__(_ColorList256 self, _ColorList256 other, int rcmp):
        return cmpToRichcmp(compareContainers(self.colors, other.colors), rcmp)

    def __sizeof__(self):
        return self.colors.getSizeOf()

    def __str__(self):
        return toString(self.colors).decode('ascii')

    @staticmethod
    def spread(_Color x, _Color y, size_t size):
        """Return a spread of `size` colors between Color x and Color y."""
        cdef _ColorList256 cl = _ColorList256()
        cl.colors = fillSpread(x.color, y.color, size)
        return cl


cdef _ColorList256 _to_ColorList256(object value):
    if isinstance(value, _ColorList256):
        return <_ColorList256> value
    else:
        return _ColorList256(value)
