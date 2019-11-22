use strict;
use warnings;
use Test::More;
use Test::Exception;

{
    package
        L;

    use Class::Accessor::Typed (
        rw => {
            rw => { isa => 'M', inflate => sub { M->new(shift) } },
        },
        new => 1,
    );
}
{    
    package
        M;
    
    sub new {
        my ($class, $value) = @_;

        return bless {
            value => $value,
        }, $class;
    }

    sub value { shift->{value} }
}

subtest 'new' => sub {
    subtest 'use M object' => sub {
        my $obj = L->new(rw => 'hello');
        isa_ok $obj, 'L';

        isa_ok $obj->rw, 'M';
        is $obj->rw->value, 'hello';
    };
    subtest 'use epoch (and inflate)' => sub {
        my $obj = L->new(rw => M->new('hello'));
        isa_ok $obj, 'L';

        isa_ok $obj->rw, 'M';
        is $obj->rw->value, 'hello';
    };
};

subtest 'setter' => sub {
    subtest 'use M object' => sub {
        my $obj = L->new(rw => 'hello');
        $obj->rw(M->new('good bye'));

        isa_ok $obj->rw, 'M';
        is $obj->rw->value, 'good bye';
    };
    subtest 'use epoch (and inflate)' => sub {
        my $obj = L->new(rw => 'hello');
        $obj->rw('good bye');

        isa_ok $obj->rw, 'M';
        is $obj->rw->value, 'good bye';
    };
};

done_testing;