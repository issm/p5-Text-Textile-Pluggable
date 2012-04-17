use inc::Module::Install;
name 'Text-Textile-Pluggable';
all_from 'lib/Text/Textile/Pluggable.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
