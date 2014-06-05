use Test::More tests => 1;
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
print Dumper($pileup_run);

my $template_dir = join('/',
    dist_dir('HPF-SGE'),
    'templates'
    );
my $template = 'submit_to_sge.template';

my $target_file = 'target.bed';
$pileup_run = $samtools->create_pileup(
    bam => $bam,
    target_file => $target_file
    );
print Dumper($pileup_run);

my @hold_for = ();
my $pipeline_script = $samtools->create_sge_shell_scripts(
    command => $pipeline_run->{'cmd'},
    jobname => join('_', 'mpileup'),
    template_dir => $template_dir,
    template => $template,
    memory => '8',
    hold_for => \@hold_for
    );
