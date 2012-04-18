use ExtUtils::MakeMaker;

sub MY::test_via_harness {
    "\tprove --rc=.proverc t\n";
}

sub MY::top_targets {
    << "    ...";
all ::
\t
pure_all ::
\t
subdirs ::
\t
config ::
\t
    ...
}

WriteMakefile(
    NAME          => 'Text::Textile::Pluggable',
    AUTHOR        => 'issm <issmxx@gmail.com>',
    VERSION_FROM  => 'lib/Text/Textile/Pluggable.pm',
    PREREQ_PM     => {
        'parent'        => '0.224',
        'Text::Textile' => '2.12',
        'Class::Load'   => '0.13',
        'Try::Tiny'     => '0.11',  # in test
    },
    MIN_PERL_VERSION => '5.008001',
    test => {
        TESTS => 't/*.t t/*/*.t',
    },
);
