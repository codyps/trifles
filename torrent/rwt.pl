#! /usr/bin/env perl
use strict;

if ($ARGV < 2) {
	print STDERR "usage: rwt.pl torrent\n";
	exit 1;
}

my $torrent = shift @ARGV;

open( my $fh, "<", $torrent) || die "couldn't open $torrent";

