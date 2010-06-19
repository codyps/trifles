#! /usr/bin/env perl
#
# Add/delete trackers recursively from all torrents.
# Free to copy and mutilate any way you like :)
#

sub usage {
	print <<EOF
usage: perl tracker_modify.pl [OPTIONS...] <-a add_file>
                              <-d delete_file> <directory>
Requires an add_file or delete_file or both.

Main Options:
-a add_file	File location of tracker list to add.
		(seperate tiers by empty line)
-d delete_file	File location of tracker hostname list to delete.
		(hostnames only, supports regular expression)
directory	Directory to recursively scan for torrents to modify

Optional flags:
-e .extension	Match files with extension, use null for all files 
		(default .torrent)
-deladd		Add tracker list only to torrents with a delete match 
		(default disabled)
-noconfirm 	Do not confirm the modifying process (default disabled)

Examples:

> perl tracker_modify.pl -a add_file /home/user/torrent
Add trackers to all files with extension .torrent in /home/user/torrent

> perl tracker_modify.pl -e null -deladd -a add_file -d delete_file \
>> /home/user/torrent
Add trackers only to files that have a delete match, all extensions
in /home/user/torrent

----------add_file example----------
http://tracker.openbittorrent.com:80/announce
udp://tracker.openbittorrent.com:80/announce

http://tracker.publicbt.com:80/announce
udp://tracker.publicbt.com:80/announce
------------------------------------
Notice the blank line between tiers!

---------delete_file example--------
.thepiratebay.org\$
.prq.to\$
moviex.info\$
^91.191.138.
------------------------------------
List of hostnames to remove. ^ = beginning \$ = end of hostname,
first line is basically *.thepiratebay.org and the last line 91.191.138.*
EOF
;
	exit(0);
}

my $ext = '.torrent';

foreach $i (@ARGV) {
	my $argv_enext = 1 if ($i =~ /^-e/);
	my $argv_anext = 1 if ($i =~ /^-a/);
	my $argv_dnext = 1 if ($i =~ /^-d$/);
	my $noconf = 1 if ($i =~ /^-noconfirm/);
	my $deladd = 1 if ($i =~ /^-deladd/);
	next if ($i =~ /^-/);
	if ($argv_enext) {
		undef($argv_enext);
		$ext = $i;
		$ext = '' if ($i eq 'null'); 
	}
	if ($argv_anext) {
		undef($argv_anext);
		open(FILE,$i) || die "Unable to open $i";
		@add_list = <FILE>;
		close(FILE);
	}
	if ($argv_dnext) {
		undef($argv_dnext);
		open(FILE,$i) || die "Unable to open $i";
		@del_list = <FILE>;
		close(FILE);
	}
	$directory = $i;
}
die "Must have add_list & del_list for -deladd, which will only add to torrents that have a delete match" if ($deladd && (!$add_list[0] || !$del_list[0]));
print "Unable to open directory: $directory\n" if (!-d $directory && $directory);
&usage if (!-d $directory);

if (!$add_list[0] && !$del_list[0]) {
	print "You must have an add file or delete file or both.\n";
	&usage;
}

if (!$noconf) {
	print "Scanning directory (will confirm changes before modifying)\n\n";
	sleep(2);
}
@final = ();
&dirscan($directory);
$total_files = $#final + 1;

print "\nTotal torrents: $total_files\n";
if ($add_list[0]) {
	print "Adding trackers:\n";
	print $_ foreach (@add_list);
	print "\n\n";
}
if ($del_list[0]) {
	print "Deleting trackers (regular expression matching):\n";
	print $_ foreach (@del_list);
	print "\n\n";
}
print "File extension: $ext\n" if ($ext);
print "Run directory: $directory\n";
if (!$noconf) {
	print "Continue to modify ? [y/n] ";
	$yn = <STDIN>;
	if ($yn !~ /^y/i) {
		print "Cancelled\n";
		exit(0);
	}
}

if ($add_list[0]) {
	@final_add = ();
	@array_add = ();
	foreach $l (@add_list) {
		$l =~ s/(\n|^\s+|\s+$)//g;
		if ($l !~ /[A-za-z0-9]/) {
			push(@final_add,[@array_add]) if ($array_add[0] =~ /[A-Za-z0-9]/);
			@array_add = ();
			next;
		}
		push(@array_add,$l);
	}
	push(@final_add,[@array_add]) if ($array_add[0]);
}
if ($del_list[0]) {
	$del_string = '';
	foreach $i (@del_list) {
		$i =~ s/(\n|^\s+|\s+$)//g;
		$del_string .= $i.'|' if ($i =~ /[A-Za-z0-9]/); 
	}
	chop $del_string;
}
foreach $f (@final) {
	print $f.'...';
	open(FIX,$f) || print "Unable to read $f";
	my $decode = modify(join('',<FIX>));
	close(FIX);
	if ($decode) {
		open(NEW,'>'.$f) || print "Unable to write to $f";
		print NEW $decode;
		close(NEW);
		print "success";
	}
	else { print "no changes"; }
	print "\n";
}

sub dirscan {
	my $dir = shift;
	my @dirlist;
	$dir .= '/' if ($dir !~ /\/$/);
	opendir(DIR,$dir) || print "Unable to open $dir\n";
	while ($f = readdir(DIR)) {
		next if ($f =~ /^\.\.?$/);
		if (($f =~ /$ext$/||!$ext) && -f $dir.$f) {
			print $dir.$f."\n";
			push(@final,$dir.$f);
		}
		push(@dirlist,$dir.$f) if (-d $dir.$f && $f !~ /^\.\.?$/);
	}
	closedir(DIR);
	foreach $ii (@dirlist) {
		&dirscan($ii);
	}
}
sub modify {
	my $read_file = shift;
	my $made_changes = 0;
	my $read = bdecodefile($read_file);
	my @announce = ();
	my %used;
	my $deladd_match = 0;
        if (!$read) {
                $read = bdecode($read_file);
        }
	if ($final_add[0]) {
		if ($deladd) {
			my $uhx = -1;
			foreach $uh (@{$read->{'announce-list'}}) {
				$uhx++;
				foreach $uhh (@{$uh}) {
					my $domain = $uhh;
					$domain =~ s/.*:\/\///g;
					$domain =~ s/(\/|:).*//g;
					$deladd_match = 1 if ($domain =~ /$del_string/);
				}
			}
			my $domain = $read->{'announce'};
			$domain =~ s/.*:\/\///g;
			$domain =~ s/(\/|:).*//g;
			$deladd_match = 1 if ($domain =~ /$del_string/);
		}
		if (!$deladd || $deladd_match) {
			$made_changes = 1;
			unshift(@{$read->{'announce-list'}},@final_add);
		}
	}
	if ($del_string) {
		my $uhx = -1;
		my $ahx = -1;
		foreach $uh (@{$read->{'announce-list'}}) {
			$uhx++;
			my $uhhx = -1;
			my $add_ahx = 0;
			foreach $uhh (@{$uh}) {
				$uhhx++;
				my $domain = $uhh;
				$domain =~ s/.*:\/\///g;
				$domain =~ s/(\/|:).*//g;
				if ($domain =~ /$del_string/ || $used{$uhh}) {
					$made_changes = 1;
				}
				else {
					if (!$add_ahx) {
						$add_ahx = 1;
						$ahx++;
					}
					$announce[$ahx] = [] if (!$announce[$ahx]);
					push(@{$announce[$ahx]},$read->{'announce-list'}[$uhx][$uhhx]);
					$used{$uhh} = 1;
				}
			}
		}
		$read->{'announce-list'} = [@announce];
		if ($read->{'announce'}) {
			my $domain = $read->{'announce'};
			$domain =~ s/.*:\/\///g;
			$domain =~ s/(\/|:).*//g;
			if ($domain =~ /$del_string/) {
				if ($final_add[0][0] =~ /[A-Za-z0-9]/) {
					$read->{'announce'} = $final_add[0][0];
				}
				elsif ($read->{'announce-list'}[0][0] =~ /[A-Za-z0-9]/) {
					$read->{'announce'} = $read->{'announce-list'}[0][0];
				}
			}
		}
	}
	if ($made_changes) {
		return bencode($read);
	}
	else {
		return 0;
	}
}
sub bencode {
    my $data = shift;
    my $enc = '';
    if (ref($data) eq 'HASH') {
	no locale;
	foreach (sort(keys %{$data})) {
	    $enc .= bencode($_) . bencode($data->{$_});
	}
	return('d' . $enc . 'e');
    }
    if (ref($data) eq 'ARRAY') {
	foreach (@{$data}) { $enc .= bencode($_); }
	return('l' . $enc . 'e');
    }
    if ($data =~ /^\d+$/) {
	return('i' . $data . 'e');
    }
    return(join(':', length($data), $data));
}
sub bdecodefile {
    my $data = shift;
    my $pref = shift;
    my $c = substr($data, $$pref, 1);
    if ($c eq 'd') {
	# hash
	$$pref++;		# eat the 'd'
	my %d = ();
	while (substr($data, $$pref, 1) ne 'e') {
	    my $key = bdecodefile($data, $pref);
	    $d{$key} = bdecodefile($data, $pref);
	    if ($_btdead)  {
		undef($_btdead);
		return 0;
	    }
	}
	$$pref++;		# eat the 'e'
	return(\%d);
    } elsif ($c eq 'l') {
	# list
	$$pref++;		# eat the 'l'
	my @l = ();
	while (substr($data, $$pref, 1) ne 'e') {
	    push(@l, bdecodefile($data, $pref));
	    if ($_btdead)  {
		undef($_btdead);
		return 0;
	    }
	}
	$$pref++;		# eat the 'e'
	return(\@l);
    } elsif ($c eq 'i') {
	if (substr($data, $$pref) =~ /^i(\d+)e/s) {
	    # number
	    $$pref += length($1) + 2;
	    return($1);
	} else { $_btdead = 1; return 0; }
    } else {
	# data buffer with length $len
	if (my($len, $dat) = (substr($data, $$pref) =~ /^(\d+):(.*)/s)) {
	    my $dlen = length($dat);
	    if ($len > $dlen) { $_btdead = 1; return 0; }
	    $$pref += length($len) + 1;	# move past length field + ':'
	    my $buf = substr($data, $$pref, $len);
	    $$pref += $len;	# move past data buffer
	    return($buf);
	} else { $_btdead = 1; return 0; }
    }
}
sub _bdecode_chunk {
	my ( $q, $r ); # can't declare 'em inline because of qr//-as-closure
	my $str_rx = qr/ \G ( 0 | [1-9] \d* ) : ( (??{
		# workaround: can't use quantifies > 32766 in patterns,
		# so for eg. 65536 chars produce something like '(?s).{32766}.{32766}.{4}'
		$q = int( $^N \/ 32766 );
		$r = $^N % 32766;
		$q--, $r += 32766 if $q and not $r;
		"(?s)" . ( ".{32766}" x $q ) . ".{$r}"
	}) ) /x;

	if( m/$str_rx/xgc ) {
		return $2;
	}
	elsif( m/ \G i ( 0 | -? [1-9] \d* ) e /xgc ) {
		return $1;
	}
	elsif( m/ \G l /xgc ) {
		my @list;
		until( m/ \G e /xgc ) {
			push @list, _bdecode_chunk();
		}
		return \@list;
	}
	elsif( m/ \G d /xgc ) {
		my $last_key;
		my %hash;
		until( m/ \G e /xgc ) {
			m/$str_rx/xgc;

			my $key = $2;

			$last_key = $key;
			return 0 if ($bemustdie);
			$hash{ $key } = _bdecode_chunk();
		}
		return \%hash;
	}
	else {
		$bemustdie = 1;
	}
}
sub bdecode {
	local $_ = shift;
	$bemustdie = 0;
	my $data = _bdecode_chunk();
	return $data;
}

