use 5.006;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'NGS::Tools::Samtools',
    license             => 'Artistic_2_0',
    dist_author         => q{Richard de Borja <richard.deborja@sickkids.ca>},
    dist_abstract       => 'A Perl wrapper for the CLI Samtools suite of tools',
    dist_version_from   => 'lib/NGS/Tools/Samtools.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
    },
    add_to_cleanup     => [ 'NGS-Tools-Samtools-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
