use inc::Module::Install;
name 'Text-Textile-Pluggable';
all_from 'lib/Text/Textile/Pluggable.pm';

requires 'parent'        => '0.224';
requires 'Text::Textile' => '2.12';
requires 'Class::Load'   => '0.13';

tests 't/*.t t/*/*.t t/*/*/*.t';

test_requires 'Test::More';
test_requires 'Test::Differences' => '0.61';
test_requires 'Try::Tiny'         => '0.11';

auto_set_repository;
#auto_include;
WriteAll;
