use Test::More tests => 2;
use Test::Moose;
use Test::Exception;
use MooseX::ClassCompositor;
use Test::Files;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use File::Temp qw(tempfile tempdir);
use Data::Dumper;

# setup the class creation process
my $test_class_factory = MooseX::ClassCompositor->new(
    { class_basename => 'Test' }
    );

# create a temporary class based on the given Moose::Role package
my $test_class = $test_class_factory->class_for('NGS::Tools::Samtools::Role::IndexStats');

# instantiate the test class based on the given role
my $samtools;
my $bam = 'test.bam';
my $samtools_program = '/usr/local/bin/samtools';
lives_ok
    {
        $samtools = $test_class->new();
        }
    'Class instantiated';

my $idxstats_run = $samtools->generate_idxstats(
    bam => $bam,
    samtools => $samtools_program
    );
my $expected_cmd = join(' ',
    'samtools',
    'idxstats',
    'test.bam',
    '>',
    'test.idxstats'
    );
is($idxstats_run->{'cmd'}, $expected_cmd, "Command matches expected");
