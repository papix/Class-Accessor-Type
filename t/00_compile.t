use strict;
use Test::More 0.98;

use_ok $_ for qw(
    Class::Accessor::Typed
    Class::Accessor::Typed::Mouse
);

if (eval { require Type::Tiny; 1 }) {
    use_ok 'Class::Accessor::Typed::TypeTiny';
}

done_testing;

