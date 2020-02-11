use strict;
use warnings;
use Test::More;
use Test::Exception;

{
    package
        L;

    use Class::Accessor::Typed (
        rw => {
            rw1 => { isa => 'Str', default => 'default value' },
            rw2 => 'Int',
        },
        ro => {
            ro1 => 'Str',
            ro2 => 'Int',
        },
        wo => {
            wo => 'Int',
        },
    );

    package
        M;
    
    use Class::Accessor::Typed;

    Class::Accessor::Typed->mk_accessors(
        rw1 => { isa => 'Str', default => 'default value' },
        rw2 => 'Int',
    );
    Class::Accessor::Typed->mk_ro_accessors(
        ro1 => 'Str',
        ro2 => 'Int',
    );
    Class::Accessor::Typed->mk_wo_accessors(
        wo => 'Int',
    );

    package
        N;

    use Class::Accessor::Typed (
        rw => {
            rw  => 'Str',
        },
        new => 0,
    );
}

subtest 'new' => sub {
    for my $pkg (qw/L M/) {
        subtest $pkg => sub {
            my $obj = $pkg->new(
                rw1 => 'RW1',
                rw2 => 321,
                ro1 => 'RO1',
                ro2 => 123,
                wo  => 222,
            );
            isa_ok $obj, $pkg;

            subtest 'validation error' => sub {
                throws_ok {
                    $pkg->new(
                        rw1 => 'RW1',
                        rw2 => 'RW2',
                        ro1 => 'RO1',
                        ro2 => 123,
                        wo  => 222,
                    );
                } qr/'rw2': Validation failed for 'Int' with value RW2/;
            };

            subtest 'missing mandatory parameter' => sub {
                throws_ok {
                    $pkg->new(
                        rw1 => 'RW1',
                        rw2 => 321,
                        ro1 => 'RO1',
                        ro2 => 123,
                    );
                } qr/missing mandatory parameter named '\$wo'/;
            };

            subtest 'default option' => sub {
                my $obj = $pkg->new(
                    rw2 => 321,
                    ro1 => 'RO1',
                    ro2 => 123,
                    wo  => 222,
                );

                is $obj->rw1, 'default value';
            };

            subtest 'unknown arguments' => sub {
                my $warn = '';
                local $SIG{__WARN__} = sub {
                    $warn .= "@_";
                };

                my $obj = $pkg->new(
                    rw1     => 'RW1',
                    rw2     => 321,
                    ro1     => 'RO1',
                    ro2     => 123,
                    wo      => 222,
                    unknown => 'unknown',
                );

                like $warn, qr/unknown arguments: unknown/;
                isa_ok $obj, $pkg;
                ok ! exists $obj->{unknown};
            };
        };
    }

    subtest 'disable new option' => sub {
        throws_ok {
            N->new(rw => 'RW');
        } qr/Can't locate object method "new" via package "N"/;
    };
};

subtest 'getter' => sub {
    for my $pkg (qw/L M/) {
        subtest $pkg => sub {
            my $obj = $pkg->new(
                rw1 => 'RW1',
                rw2 => 321,
                ro1 => 'RO1',
                ro2 => 123,
                wo  => 222,
            );
        
            is $obj->rw1, 'RW1';
            is $obj->rw2, 321;
            is $obj->ro1, 'RO1';
            is $obj->ro2, 123;
        
            throws_ok {
                $obj->wo;
            } qr/cannot alter the value of 'wo' on objects of class '$pkg'/;
        };
    }
};

subtest 'setter' => sub {
    for my $pkg (qw/L M/) {
        subtest $pkg => sub {
            my $obj = $pkg->new(
                rw1 => 'RW1',
                rw2 => 321,
                ro1 => 'RO1',
                ro2 => 123,
                wo  => 222,
            );
        
            $obj->rw1('sample');
            is $obj->rw1, 'sample';
        
            throws_ok {
                $obj->rw2('sample');
            } qr/'rw2': Validation failed for 'Int' with value sample/;
        
            throws_ok {
                $obj->ro1('sample');
            } qr/cannot access the value of 'ro1' on objects of class '$pkg'/;
        
            $obj->wo(333);
            is $obj->{wo}, 333;
        };
    }
};

done_testing;
