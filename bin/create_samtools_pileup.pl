#!/usr/bin/perl

### create_samtools_pileup.pl ##############################################################################
# Create a pileup file.

### HISTORY #######################################################################################
# Version       Date            Developer           Comments
# 0.01          2014-05-08      rdeborja            initial development.

### INCLUDES ######################################################################################
use warnings;
use strict;
use Carp;
use Getopt::Long;
use Pod::Usage;
use NGS::Tools::Samtools;
use File::ShareDir ':ALL';

### COMMAND LINE DEFAULT ARGUMENTS ################################################################
# list of arguments and default values go here as hash key/value pairs
our %opts = (
	bam => undef,
	region => 'chrX:48649325-48649977',
	maxcoverage => 10000000,
	samtools => '/hpf/tools/centos/samtools/0.1.19/bin/samtools',
	memory => 16,
    execute => 'none'
    );

### MAIN CALLER ###################################################################################
my $result = main();
exit($result);

### FUNCTIONS #####################################################################################

### main ##########################################################################################
# Description:
#   Main subroutine for program
# Input Variables:
#   %opts = command line arguments
# Output Variables:
#   N/A

sub main {
    # get the command line arguments
    GetOptions(
        \%opts,
        "help|?",
        "man",
        "bam|b=s",
        "region|r:s",
        "maxcoverage|m:i",
        "samtools|s:s",
        "execute|e:s"
        ) or pod2usage(64);
    
    pod2usage(1) if $opts{'help'};
    pod2usage(-exitstatus => 0, -verbose => 2) if $opts{'man'};

    while(my ($arg, $value) = each(%opts)) {
        if (!defined($value)) {
            print "ERROR: Missing argument \n";
            pod2usage(128);
            }
        }

    my $template_dir = join('/',
    	dist_dir('HPF-SGE'),
    	'templates'
    	);
    my $template = 'submit_to_sge.template';

    my $samtools = NGS::Tools::Samtools->new();
    my $pileup = $samtools->create_pileup(
    	bam => $opts{'bam'},
    	region => $opts{'region'},
    	maxcoverage => $opts{'maxcoverage'},
    	samtools => $opts{'samtools'}
    	);
    my @hold_for = ();
    my $pileup_script = $samtools->create_sge_shell_scripts(
    	command => $pileup->{'cmd'},
    	jobname => join('_', 'pileup'),
    	template_dir => $template_dir,
    	template => $template,
    	memory => $opts{'memory'},
    	hold_for => \@hold_for
    	);

    if ($opts{'execute'} eq 'sge') {
        system("qsub", $pileup_script->{'output'});
        }
    elsif ($opts{'execute'} eq 'shell') {
        system($pileup_script->{'output'});
        }
    else {
        "Script can be found in $pileup_script->{'output'}\n\n";
        }

    return 0;
    }


__END__


=head1 NAME

create_samtools_pileup.pl

=head1 SYNOPSIS

B<create_samtools_pileup.pl> [options] [file ...]

    Options:
    --help          brief help message
    --man           full documentation
    --bam           BAM file to process
    --region        regions to review
    --maxcoverage   maximum depth of coverage to report on
    --samtools      full path to the Samtools program
    --execute       method of execution (sge, shell, none)

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exit.

=item B<--man>

Print the manual page.

=item B<--bam>

BAM file to process

=item B<--region>

Region of the review to generate pileup.

=item B<--maxcoverage>

Maximum depth of coverage to report on.

=item B<--samtools>

Full path to the Samtools program.

=item B<--execute>

Method of executing, can be sge (to submit to cluster), shell (for command line using BASH)
or none (do not execute).

=back

=head1 DESCRIPTION

B<create_samtools_pileup.pl> Create a pileup file.

=head1 EXAMPLE

create_samtools_pileup.pl  --bam file.bam --region chrX:1190475-1190478 --execute shell

=head1 AUTHOR

Richard de Borja -- Molecular Genetics

The Hospital for Sick Children

=head1 SEE ALSO

=cut

