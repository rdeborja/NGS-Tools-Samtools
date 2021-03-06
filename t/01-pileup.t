use Test::More tests => 2;
use Test::Moose;
use Test::Exception;
use MooseX::ClassCompositor;
use Test::Files;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use File::Temp qw(tempfile tempdir);
use Data::Dumper;
use File::ShareDir ':ALL';

# setup the class creation process
my $test_class_factory = MooseX::ClassCompositor->new(
    { class_basename => 'Test' }
    );

# create a temporary class based on the given Moose::Role package
my $test_class = $test_class_factory->class_for('NGS::Tools::Samtools::Role::Pileup');

# instantiate the test class based on the given role
my $samtools;
lives_ok
    {
        $samtools = $test_class->new();
        }
    'Class instantiated';

my $bam = 'sample.bam';
my $region = 'chrX:48649325-48649977';

my $pileup_run = $samtools->create_pileup(
    bam => $bam,
    region => $region
    );
my $expected_command = join(' ',
    'samtools',
    'mpileup',
    '-A -O -r',
    'chrX:48649325-48649977',
    'sample.bam',
    '>',
    'sample.pileup.txt'
    );
is($pileup_run->{'cmd'}, $expected_command, "Command matches expected");
