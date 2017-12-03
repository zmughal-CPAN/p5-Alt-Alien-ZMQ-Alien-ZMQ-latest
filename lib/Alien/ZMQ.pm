package Alien::ZMQ;
# ABSTRACT: Alien::ZMQ replacement that uses Alien::ZMQ::latest

use strict;
use warnings;

use Alien::ZMQ::latest;
use Text::ParseWords qw/shellwords/;

sub _source {
	return 'Alien::ZMQ::latest';
}

sub inc_dir {
	join ' ', map { s/^-I//r; }
		grep { /^-I/ }
		shellwords( Alien::ZMQ::latest->cflags );
}

sub libs {
	Alien::ZMQ::latest->libs;
}

1;
=head1 SEE ALSO

L<Alien::ZMQ::latest>

=cut
