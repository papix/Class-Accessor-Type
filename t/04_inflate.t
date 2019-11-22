use strict;
use warnings;
use Test::More;
use Test::Exception;

use DateTime;

{
    package
        L;

    use Class::Accessor::Typed (
        rw => {
            date => { isa => 'DateTime', inflate => sub { DateTime->from_epoch(epoch => shift) } },
        },
        new => 1,
    );
}

subtest 'new' => sub {
    subtest 'use DataTime object' => sub {
        my $obj = L->new(date => DateTime->from_epoch(epoch => 1234567890));
        isa_ok $obj, 'L';

        isa_ok $obj->date, 'DateTime';
        is $obj->date->epoch, 1234567890;
    };
    subtest 'use epoch (and inflate)' => sub {
        my $obj = L->new(date => 1234567890);
        isa_ok $obj, 'L';

        isa_ok $obj->date, 'DateTime';
        is $obj->date->epoch, 1234567890;
    };
};

subtest 'setter' => sub {
    subtest 'use DateTime object' => sub {
        my $obj = L->new(date => DateTime->from_epoch(epoch => 1234567890));
        $obj->date(DateTime->from_epoch(epoch => 1231231230));

        isa_ok $obj->date, 'DateTime';
        is $obj->date->epoch, 1231231230;
    };
    subtest 'use epoch (and inflate)' => sub {
        my $obj = L->new(date => DateTime->from_epoch(epoch => 1234567890));
        $obj->date(1231231230);

        isa_ok $obj->date, 'DateTime';
        is $obj->date->epoch, 1231231230;
    };
};

done_testing;