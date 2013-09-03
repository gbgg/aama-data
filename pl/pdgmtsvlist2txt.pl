#!/usr/local/bin/perl

# rev 02/08/13

# This version of pdgmtsvlist2txt.pl is to be run in the tools/rq-ru/pdgm-def
# directory. It is invoked by run-rq-and-transform.sh. It takes the 
# pdgm-finite-props.tsv output of pdgm-finite-props.rq, 
# format: "?lang ?langVar ?property", and transforms it to a text file of 
# format: "?lang-?langVar\tproperty-list, where property-list is a 
# space-separated list of properties.

#Should try to see if script can be generalized.

# rev 02/22/13
# changed $lang, $langvar to $aamalang


my ($qfile) = @ARGV;
my ($txtfile) = $qfile;
$txtfile =~ s/(.*?)\..*?$/\1.txt/;
print "qfile = $qfile\n";
print "txtfile = $txtfile\n";

my $langname;
my %langproplist;
open(IN, $qfile) || die "cannot open $qfile for reading";
while (<IN>)
{ 
	my $pdgmprop = $_;
	$pdgmprop =~ s/["\n\r]//g;
	if ($pdgmprop !~ /\?/)
	{
		my ($aamalang, $prop) = split(/\t/, $pdgmprop);
		$langproplist{$aamalang} .= $prop.", ";
	}
}

open(OUT, ">$txtfile") || die "cannot open $txtfile for output"; 
select(OUT);
foreach my $language (sort keys %langproplist)
{
	my $proplist = $langproplist{$language};
	$proplist =~ s/, $//;
	print $language." : ".$proplist."\n\n";
}
close(OUT); 
