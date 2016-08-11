import contextlib, csv, json, os, pathlib, stat, string, sys


def substituter(**kwds):
    return lambda t: string.Template(t or '').substitute(**kwds)


def read_template(lines, f):
    parts = []
    result = {}
    name = None
    first = not True

    def new_section():
        def r(s):
            return s.strip()
        if parts:
            if not name:
                raise ValueError('No name in %s' % f)
            while parts and not parts[-1].strip():
                parts.pop()
            result[name] = ''.join(parts)
            parts.clear()

    for line in lines:
        if line.startswith('###'):
            new_section()
            _, name = line.split()
        else:
            parts.append(line)
    new_section()
    return result


def substitute_templates(*names, **kwds):
    filename = '/'.join(('src', 'pyx', 'timedata', 'template') + names) + '.pyx'
    sub = substituter(**kwds)

    try:
        parts = read_template(open(filename), filename)
        return [sub(parts.get(i)) for i in ('declare', 'define')]

    except Exception as e:
        s = ' '.join(str(i) for i in e.args)
        raise e.__class__('%s in file %s' % (s, filename))


class Context(object):
    def __init__(self, **kwds):
        for (k, v) in kwds.items():
            setattr(self, k, v)


def substitute_context(context, **kwds):
    context = dict(context)
    sub = substituter(**kwds)

    for k, v in context.pop('substitutions', {}).items():
        context[k] = sub(v)
    return Context(**context)


def add_methods(old_methods=None, **new_methods):
    """Merge two class description dictionaries."""
    import copy
    def tup(v):
        return (v, ) if isinstance(v, str) else v

    result = copy.deepcopy(old_methods or {})
    for signature, categories in new_methods.items():
        if signature == 'base':
            result[signature] = result.get(signature, ()) + tup(categories)
        else:
            cat_dict = result.setdefault(signature, {})
            for category, methods in categories.items():
                cat_dict[category] = cat_dict.get(category, ()) + tup(methods)
    return result
