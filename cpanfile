requires 'perl', '5.008001';

requires 'Carp';
requires 'Module::Load';
requires 'Mouse::Util::TypeConstraints';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Exception';
};

