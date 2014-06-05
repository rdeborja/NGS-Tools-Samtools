use Test::More tests => 3;
use Test::Files;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use File::Temp qw(tempfile tempdir);
use Data::Dumper;

BEGIN: {
    use_ok('NGS::Tools::Samtools');
	}

my $samtools = NGS::Tools::Samtools->new();
isa_ok($samtools, NGS::Tools::Samtools);
can_ok($samtools, qw(create_pileup import_pileup));

