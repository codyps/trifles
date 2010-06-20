#! /usr/bin/env perl
use strict;

sub read_torrent($) {
	if (@_ != 1) {
		die 'bad args';
	}
	my $fh = @_;

	local $/;
	my $tf = <$fh>;
}

sub act_add($@) {
	my ($tf, @trackers) = @_;
	if (@trackers < 1) {
		die 'must specify tracker[s] to add';
	}

}

sub act_rm($\@) {
	if (@_ < 1) {
		die 'must have at least 1 removal regex.';
	}
}

sub act_show($\@) {
	my ($tf, @rest) = @_;

	# Check for 'announce'
	if ($tf =~ /announce(\d*):/s ) {
		my $ct = substr($tf, $+[0], $1);
		print "$ct\n";
	}

	# Check for 'announce-list'
	if ($tf =~ /announce-list/) {
		print "found announce-list\n";
	}
}

if (@ARGV < 2) {
	print STDERR "usage: rwt.pl <torrent> {add|rm|show} [stuff]\n";
	exit 1;
}

my ($torrent, $action, @rest) = @ARGV;
my $tf;
open( my $fh, "<", $torrent) || die "couldn't open $torrent";
{
	local $/;
	$tf = <$fh>;
}
close($fh);

for ($action) {
	if    (/^[+a]/)  { act_add($tf, @rest) }
	elsif (/^[sp]/)  { act_show($tf, @rest) }
	elsif (/^[-rd]/) { act_rm($tf, @rest) }
}

