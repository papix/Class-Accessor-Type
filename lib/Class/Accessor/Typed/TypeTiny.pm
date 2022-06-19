package Class::Accessor::Typed::TypeTiny;
use strict;
use warnings;
use utf8;

use Scalar::Util qw/blessed/;
use Type::Registry;
use Type::Utils;

my $reg = Type::Registry->for_class(__PACKAGE__);

sub type {
    my ($class, $type_name) = @_;
    return $type_name if blessed($type_name);

    if (my $type = $reg->simple_lookup($type_name)) {
        return $type;
    } else {
        my $type = Type::Utils::dwim_type(
            $type_name,
            fallback => [ 'lookup_via_mouse', 'make_class_type' ],
        );
        $type->{display_name} = $type_name;
        $reg->add_type($type, $type_name);
        return $type;
    }
}

sub type_role {
    my ($class, $type_name) = @_;
    return $type_name if blessed($type_name);

    if (my $type = $reg->simple_lookup($type_name)) {
        return $type;
    } else {
        my $type = Type::Utils::dwim_type(
            $type_name,
            fallback => ['make_role_type'],
        );
        $type->{display_name} = $type_name;
        $reg->add_type($type, $type_name);
        return $type;
    }
}

1;
