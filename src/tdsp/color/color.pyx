cdef class Color:
    cdef float red
    cdef float green
    cdef float blue

    def __cinit__(self, float red=0, float green=0, float blue=0):
        self.red = red
        self.green = green
        self.blue = blue

    @property
    def red(self):
        return self.red

    @property
    def green(self):
        return self.green

    @property
    def blue(self):
        return self.blue

    def __getitem__(self, int key):
        if key == 0:
            return self.red
        if key == 1:
            return self.green
        if key == 2:
            return self.blue
        raise IndexError('Color index out of range')

    def __len__(self):
        return 3

    def __str__(self):
        return colorToString(self.red, self.green, self.blue).decode('ascii')

    def __repr__(self):
        cl = self.__class__
        return '%s.%s(%s)' % (cl.__module__, cl.__name__, str(self))

    def __richcmp__(Color self, Color c, int cmp):
        return cmpToRichcmp((self.red - c.red) or (self.green - c.green) or
                            (self.blue - c.blue), cmp)

    @staticmethod
    def make(x):
        if not isinstance(x, str):
            return Color(*x)

        st = bytes(x)
        cdef Frame[RGB] frame

        if toColor(st, frame):
            return Color(frame.at(0), frame.at(1), frame.at(2))
        raise ValueError("Can't understand color %s" % str(x)[1:])