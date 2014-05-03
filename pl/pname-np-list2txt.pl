#!/usr/local/bin/perl

#11/26/13: adapted from pname-list2txt.pl, called by display-pnames-nfv.sh.
# This program takes output from applications of pdgm-non-finite-prop-list.template  and formats it into the text pdgm-pname-nfv-list.txt, which identifies for each language the non-finite paradigms (presumably marked with a multiLex property) and their property cols.
# see if can unify with pname-fv,nfv-list2txt.pl


my ($pnamefile, $lang) = @ARGV;
#print "input file = $pnamefile\n";
my $pos = $pnamefile;
#print "pos = $pos\n";non
$pos =~ s/sparql\/pdgms\/output\/pnames-(.*?)-.*/\1/;
#$pos = s/^.*?-(.*?)-.*/\1/;
#print "pos = $pos\n";
my $textfile = "sparql/pdgms/pname-$pos-list-$lang.txt";
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
	{no
		my($multilex, $prop) = split(/\t/, $nfvprop);
		$nfvpdgmprops{$multilex} .= $prop.",";
	}
}

my $index = 1;
foreach my $multilex (sort keys %nfvpdgmprops)
{
	my $proplist = $nfvpdgmprops{$multilex};
	$proplist =~ s/,$//;
	print $index.". ".$multilex.":".$proplist."\n";
	$index++;
}
# print pdgm tsv data and header to tab-delimited tsv file
#unlink $tsvfile;
my $index = 1;
open(OUT, ">$textfile") or die "cannot open $textfile for output"; 
select(OUT);
foreach my $multilex (sort keys %nfvpdgmprops)
{
	my $proplist = $nfvpdgmprops{$multilex};
	$proplist =~ s/,$//;
	print $index.". ".$multilex.":".$proplist."\n";
	$index++;
}
print "\n";
close(OUT);

