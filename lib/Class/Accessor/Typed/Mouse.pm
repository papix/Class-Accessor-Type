package Class::Accessor::Typed::Mouse;
use strict;
use warnings;
use utf8;

use Mouse::Util::TypeConstraints ();

*_get_isa_type_constraint  = \&Mouse::Util::TypeConstraints::find_or_create_isa_type_constraint;
*_get_does_type_constraint = \&Mouse::Util::TypeConstraints::find_or_create_does_type_constraint;

sub type {
    my ($class, $type_name) = @_;
    return _get_isa_type_constraint($type_name);
}

sub type_role {
    my ($class, $type_name) = @_;
    return _get_does_type_constraint($type_name);
}

1;
