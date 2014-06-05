use Test::More tests => 1;
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
my $test_class = $test_class_factory->class_for('NGS::Tools::Samtools::Role::PileupParser');

# instantiate the test class based on the given role
my $samtools;
lives_ok
	{
		$samtools = $test_class->new();
		}
	'Class instantiated';

my $pileup_file = "8046_5.gatk.pileup.chrX_48649518.txt";
my $import_pileup = $samtools->import_pileup(
	pileup => $pileup_file
	);
