### comment
"""This is template code common to both Samples and Lists."""

### declare
import cython
from numbers import Number

### define

cdef class $classname:
    """$class_documentation"""
    cdef C$classname cdata

    START = $start
    RANGE = $range
    MODEL_NAME = '$model'

    cpdef $classname copy($classname self):
        """Return a new copy of self."""
        cdef $classname s = $classname()
        s.cdata = self.cdata
        return s

    def __copy__($classname self):
      return self.copy()

    def __deepcopy__($classname self, memodict=None):
        return self.copy()

    def __repr__($classname self):
        return '$classname(%s)' % str(self)

    def __str__($classname self):
        return toString(self.cdata).decode('ascii')

    def __sizeof__($classname self):
        return getSizeof(self.cdata)
