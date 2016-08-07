from . Base import *

value_type = 'float'

methods = add_methods(
    methods,
    base='sample',
    zero=dict(
        magic=(
            'abs',
            'ceil',
            'floor',
            'invert',
            'neg',
            'round',
            'trunc',),

        magic_int=(
            'hash',
            ),
        ),

    one=dict(
        magic_arithmetic=(
            'add',
            'truediv',
            'mod',
            'mul',
            'sub',
            ),

        return_class=(
            'limit_min',
            'limit_max',
            ),

        return_number=(
            'distance',
            'distance2',
            ),

        return_class_from_int=(
            'rotated',
            ),
        # no divmod!
	),

    three=dict(
        magic=(
            'pow',
            ),
        ),
    )
