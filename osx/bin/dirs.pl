#!/usr/bin/perl
#

use strict;

my @dirs;
my %dirref;

my $DIR = "/Users/zorkian";

open FILE, "<$DIR/.dirs";
while (<FILE>) {
    chomp;
    my ($ct, $ts, $dir) = split /:/, $_;
    push @dirs, [ $ct, $ts, $dir ];
    $dirref{$dir} = $dirs[-1];
}
close FILE;

my $now = time;
if ($ARGV[0] eq '-a') {
    my $dir = $ARGV[1];
    $dir =~ s/~/$ENV{HOME}/;
    if (my $dirstat = $dirref{$dir}) {
        $dirstat->[0]++;
        $dirstat->[1] = $now;
    } else {
        push @dirs, [ 1, $now, $dir ];
        $dirref{$dir} = $dirs[-1];
    }
    open FILE, ">$DIR/.dirs";
    foreach my $dirstat (@dirs) {
        print FILE "$dirstat->[0]:$dirstat->[1]:$dirstat->[2]\n";
    }
    close FILE;
    exit 0;
}

my $qr = qr/$ARGV[0]/;
exit 1 unless $qr;

my (@out, $cmax, $ds);
foreach my $dirstat (@dirs) {
    next unless $dirstat->[2] =~ /$qr/;

    my $lscore = score($dirstat);
    if (!defined $cmax || $lscore > $cmax) {
        $cmax = $lscore;
        $ds = $dirstat;
    }
}

exit 0 unless $ds;
print "$ds->[2]";
exit 0;

sub score {
    my $age = $now - $_[0]->[1];
    if ($age < 86400) {
        return $_[0]->[0] * 4;
    } elsif ($age < 86400*7) {
        return $_[0]->[0] * 2;
    } elsif ($age > 86400*30) {
        return $_[0]->[0] / 2;
    }
    return $_[0]->[0];
}
