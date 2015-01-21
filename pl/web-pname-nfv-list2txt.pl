#!/usr/local/bin/perl

#10/15/14: adapted from pname-list2txt.pl, called by display-pnames-nfv.sh.
# This program takes output from applications of pdgm-non-finite-prop-list.template  and formats it into the text pdgm-pname-nfv-list.txt, which identifies for each language the non-finite paradigms (presumably marked with a multiLex property) and their property cols.

my ($pnamefile, $lang) = @ARGV;
my $textfile = "../webapp/pvlists/pname-nfv-list-$lang.txt";
#print "input file = $pnamefile\n";
print "textfile = $textfile\n";

undef $/;
my $listdata;
my %nfvpdgmprops;
open(IN, $pnamefile) or die "cannot open $pnamefile for reading";
while (<IN>)
{ 
    $listdata = $_;
	$listdata =~ s/^\?.*?\n//g;
	$listdata =~ s/"//g;
	my @nfvprops = split(/\n/, $listdata);
	foreach my $nfvprop (@nfvprops)
	{
		my($morphClass, $prop) = split(/\t/, $nfvprop);
		$nfvpdgmprops{$morphClass} .= $prop.",";
	}
}

open(OUT, ">$textfile") or die "cannot open $textfile for output"; 
select(OUT);
foreach my $morphClass (sort keys %nfvpdgmprops)
{
	my $proplist = $nfvpdgmprops{$morphClass};
	$proplist =~ s/,$//;
	print $morphClass.":".$proplist."\n";
}
print "\n";
close(OUT);

