### define
    cpdef $classname $name($classname self):
        """Mutator corresponding to Python magic method __${name}__."""
        self.cdata = magic_$name(self.cdata)
        return self

    cpdef $classname ${name}_into($classname self):
        """$documentation"""
        self.cdata = magic_$name(self.cdata)
        return self
