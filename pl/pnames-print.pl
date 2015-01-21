#!/usr/local/bin/perl

#11/26/13: adapted from pname-list2txt.pl, called by display-pnames-nfv.sh.
# This program takes output from applications of pdgm-non-finite-prop-list.template  and formats it into the text pdgm-pname-nfv-list.txt, which identifies for each language the non-finite paradigms (presumably marked with a multiLex property) and their property cols.

my ($pnamefile) = @ARGV;
#print "input file = $pnamefile\n";

undef $/;
my $listdata;
open(IN, $pnamefile) or die "cannot open $pnamefile for reading";
while (<IN>)
{ 
    $listdata = $_;
	print $listdata;
}
close (IN);