### declare
    void math_$name(C$classname&, C$classname&)

### define
    cpdef $classname ${name}_into($classname self):
        """$documentation that mutates self."""
        math_$name(self.cdata, self.cdata)
        return self

    cpdef $classname $name($classname self):
        return self.${name}_into()

    cpdef $classname ${name}_to($classname self, $classname out):
        """$documentation that writes to another $classname."""
        math_$name(self.cdata, out.cdata)
        return out
