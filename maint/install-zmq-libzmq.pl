#!/usr/bin/env perl
# ABSTRACT: Script to test a ZMQ::* package on each system

use strict;
use warnings;

use Env qw(@PATH $PERL_CPANM_OPT $ARCHFLAGS $PERL_ALT_INSTALL);

sub cpanm {
	my (@args) = @_;

	my @default = qw(--build-args 'OTHERLDFLAGS=' --verbose);
	if( grep { 'Alt::Alien::ZMQ::Alien::ZMQ::latest' } @args ) {
		$PERL_ALT_INSTALL = 'OVERWRITE';
	}

	my @non_alien_zmq_dep_args = grep { $_ !~ /^(ZMQ::(LibZMQ[34]|FFI)|Net::Async::ZMQ)$/ } @args;

	if( grep { $_ !~ /^--?/ } @non_alien_zmq_dep_args ) {
		# if what remains is not an option
		my $exit_non_azmq = system(qw(cpanm), @default, @non_alien_zmq_dep_args);
		die "cpanm @non_alien_zmq_dep_args failed" if $exit_non_azmq;
	}

	if( $^O eq 'MSWin32' ) {
		# set PATH to libzmq.dll before installing ZMQ::LibZMQ3
		eval {
			require Alien::ZMQ::latest;
			push @PATH, Alien::ZMQ::latest->bin_dir;
		} or die "Could not load Alien::ZMQ::latest: $@";
	}

	my $exit = system(qw(cpanm), @default, @args);

	die "cpanm @default @args failed" if $exit;
}

sub install_windows {
	my (@args) = @_;
	delete $ENV{PERL_CPANM_OPT};
	cpanm(@args);
}
sub install_macos {
	my (@args) = @_;
	$ARCHFLAGS = '-arch x86_64';
	cpanm(@args);
}

sub install_linux {
	my (@args) = @_;
	cpanm(@args);
}

sub main {
	my (@args) = @ARGV;
	if( $^O eq 'MSWin32' ) {
		install_windows(@args);
	} elsif( $^O eq 'darwin' ) {
		install_macos(@args);
	} elsif( $^O eq 'linux' ) {
		install_linux(@args);
	} else {
		die "unknown OS";
	}
}

main;
