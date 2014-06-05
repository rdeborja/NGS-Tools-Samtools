#!/usr/bin/perl

### create_samtools_mpileup.pl ##############################################################################
# Execute the SAMTools mpileup program on a BAM file.

### HISTORY #######################################################################################
# Version       Date            Developer           Comments
# 0.01          2014-05-25      rdeborja            Initial development

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
	samtools => 'samtools',
	target_file => '',
	maxcoverage => 100000000,
	execute => 'none',
	memory => 8,
    quality => '20'
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
        "samtools|s:s",
        "target_file|t:s",
        "maxcoverage|m:i",
        "execute|e:s",
        "memory|m:i",
        "quality|q:i"
        ) or pod2usage(64);
    
    pod2usage(1) if $opts{'help'};
    pod2usage(-exitstatus => 0, -verbose => 2) if $opts{'man'};

    while(my ($arg, $value) = each(%opts)) {
        if (!defined($value)) {
            print "ERROR: Missing argument \n";
            pod2usage(128);
            }
        }

    # setup the templates to use
    my $template_dir = join('/',
    	dist_dir('HPF-SGE'),
    	'templates'
    	);
    my $template = 'submit_to_sge.template';

    my $samtools = NGS::Tools::Samtools->new();
    my $samtools_mpileup = $samtools->create_pileup(
    	bam => $opts{'bam'},
    	samtools => $opts{'samtools'},
    	target_file => $opts{'target_file'},
    	maxcoverage => $opts{'maxcoverage'},
        quality => $opts{'quality'}
    	);
    my @hold_for = ();
    my $pileup_script = $samtools->create_sge_shell_scripts(
    	command => $samtools_mpileup->{'cmd'},
    	jobname => join('_', 'mpileup'),
    	template_dir => $template_dir,
    	template => $template,
    	memory => $opts{'memory'},
    	hold_for => \@hold_for
    	);

    # execute the script based on the passed argument
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

create_samtools_mpileup.pl

=head1 SYNOPSIS

This tool will create an executable shell script for the SAMTools mpileup program.

B<create_samtools_mpileup.pl> [options] [file ...]

    Options:
    --help          brief help message
    --man           full documentation
    --bam           name of BAM file to process (required)
    --samtools      full path to the samtools program (default: samtools)
    --target_file   full path to the target BED file containing regions to output (optional)
    --maxcoverage   maximum coverage threshold, (default: 100000000)
    --execute       options for executing command ['none', 'sge', 'pbs', 'shell'] (default: none)
    --memory        memory to allocate to the job, applicable only to --execute set to 'sge' or 'pbs'
    --quality       minimum acceptable base quality score for pileup output (default: 20)
=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exit.

=item B<--man>

Print the manual page.

=item B<--bam>

Name of BAM file to process (required)

=item B<--samtools>

Full path to the SAMTools program.  The default assumes "samtools" is in the path.

=item B<--target_file>

Full path to a target BED file.

=item B<--maxcoverage>

Maximum coverage to output pileup information.  SAMTools default is 250, we have upped this to
100,000,000.  This will be applied to both SNVs and INDELs.

=item B<--quality>

Minimum acceptable base quality score to output to pileup file (default: 20)

=back

=head1 DESCRIPTION

B<create_samtools_mpileup.pl> Execute the SAMTools mpileup program on a BAM file.

=head1 EXAMPLE

create_samtools_mpileup.pl --bam file.bam --samtools /usr/local/bin/samtools --target_file target.bed --maxcoverage 1000 --quality 30

=head1 AUTHOR

Richard de Borja -- Molecular Genetics

The Hospital for Sick Children

=head1 SEE ALSO

=cut

