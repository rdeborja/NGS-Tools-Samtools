package NGS::Tools::Samtools::Role::Pileup;
use Moose::Role;
use MooseX::Params::Validate;

use strict;
use warnings FATAL => 'all';
use namespace::autoclean;
use autodie;
use File::Basename;
use Carp;

=head1 NAME

NGS::Tools::Samtools::Role::Pileup

=head1 SYNOPSIS

A Perl Moose role for Samtools pileup files.

=head1 ATTRIBUTES AND DELEGATES

=head1 SUBROUTINES/METHODS

=head2 $obj->create_pileup()

Creates a pileup file.

=head3 Arguments:

=over 2

=item * bam: BAM file to process, required

=item * output: name of output file, optional

=item * samtools: full path to the samtools program, default: samtools

=item * program: name of samtools program to execute, default: mpileup

=item * target_file: name of target file containing intervals for analysis, optional

=item * maxcoverage: threshold for maximum coverage to output (converves memory), default: 10000000

=back

=head3 Return Values:

=over 2

=item * output: name of output pileup file

=item * cmd: name of command to execute or submit to a grid engine

=back

=cut

sub create_pileup {
	my $self = shift;
	my %args = validated_hash(
		\@_,
		bam => {
			isa         => 'Str',
			required    => 1
			},
		output => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			},
		samtools => {
			isa			=> 'Str',
			required	=> 0,
			default		=> 'samtools'
			},
		program => {
			isa			=> 'Str',
			required	=> 0,
			default		=> 'mpileup'
			},
		region => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			},
		target_file => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			},
		maxcoverage => {
			isa			=> 'Int',
			required	=> 0,
			default		=> ''
			},
		quality => {
			isa			=> 'Int',
			required	=> 0,
			default		=> 15
			}
		);

	my $output;
	if ($args{'output'} eq '') {
		$output = join('.',
			File::Basename::basename($args{'bam'}, qw( .bam )),
			'pileup',
			'txt'
			);;
		}
	else {
		$output = $args{'output'};
		}

	my $program = join(' ',
		$args{'samtools'},
		$args{'program'}
		);

	my $options = join(' ',
		'-A',
		'-O',
		);

	# setup the max coverage threshold
	if ($args{'maxcoverage'} ne '') {
		$options = join(' ',
			$options,
			'-d', $args{'maxcoverage'},
			'-L', $args{'maxcoverage'}
			);
		}

	# region at the command line takes precedence over the target_file
	if ($args{'region'} ne '') {
		# make sure the region specified matches the expected mpileup region of <chr>:<start>-<end>
		if ($args{'region'} =~ m/chr.*\:[0-9]*\-[0-9]*/) {
			$options = join(' ',
				$options,
				'-r',
				$args{'region'}
				);
			}
		else {
			Carp::croak("defined region does not match expected chr:posA-posB format");
			}
		}
	elsif ($args{'region'} eq '' && $args{'target_file'} ne '') {
		$options = join(' ',
			$options,
			'-l', $args{'target_file'}
			);
		}

	$options = join(' ',
		$options,
		$args{'bam'}
		);

	my $cmd = join(' ',
		$program,
		$options,
		'>', $output
		);

	my %return_values = (
		cmd => $cmd,
		output => $output
		);

	return(\%return_values);
	}

=head1 AUTHOR

Richard de Borja, C<< <richard.deborja at sickkids.ca> >>

=head1 ACKNOWLEDGEMENT

Dr. Adam Shlien, PI -- The Hospital for Sick Children

Dr. Roland Arnold -- The Hospital for Sick Children

Andrej Rosic -- The Hospital for Sick Children

=head1 BUGS

Please report any bugs or feature requests to C<bug-test-test at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=test-test>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc NGS::Tools::Samtools::Role::Pileup

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=test-test>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/test-test>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/test-test>

=item * Search CPAN

L<http://search.cpan.org/dist/test-test/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Richard de Borja.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

no Moose::Role;

1; # End of NGS::Tools::Samtools::Role::Pileup
