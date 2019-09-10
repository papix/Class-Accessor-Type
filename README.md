[![Build Status](https://travis-ci.com/papix/Class-Accessor-Type.svg?branch=master)](https://travis-ci.com/papix/Class-Accessor-Type)
# NAME

Class::Accessor::Typed - Class::Accessor::Lite with Type (like Smart::Args)

# SYNOPSIS

    package Synopsis;

    use Class::Accessor::Typed (
        rw => {
            baz => { isa => 'Str', default => 'string' },
        },
        ro => {
            foo => 'Str',
            bar => 'Int',
        },
        wo => {
            hoge => 'Int',
        },
        new => 1,
    );

# DESCRIPTION

Class::Accessor::Typed is variant of `Class::Accessor::Lite`. It supports argument validation like `Smart::Args`.

# LICENSE

Copyright (C) papix.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

papix <mail@papix.net>
