#!/usr/local/bin/perl

#10/14/13: adapted from pdgmtsv2table.pl 
# This program takes output from applications of pdgm-finite-prop-list.template invoked by finite-prop-list-gen.sh and formats it into the text pdgm-prop-list.txt, which gives for each language the categories occurring in finite verb paradigms. The text is used by pdgm-display.sh for command-line display of pdgm(s) from a given language.

my ($propvalfile) = @ARGV;
my $textfile = "sparql/pdgms/pdgm-prop-list.txt";
print "input file = $propvalfile\n";
print "textfile = $textfile\n";

undef $/;
my $listdata;
open(IN, $propvalfile) or die "cannot open $propvalfile for reading";
while (<IN>)
{ 
    $listdata = $_;
	$listdata =~ s/"token.*?"\n//g;
	$listdata =~ s/\n//g;
	$listdata =~ s/##/\n\n/g;
	$listdata =~ s/\?property//g;
	$listdata =~ s/""/, /g;
	$listdata =~ s/,"/, /g;
	$listdata =~ s/'/"/g;
}

# print pdgm tsv data and header to tab-delimited tsv file
#unlink $tsvfile;
open(OUT, ">$textfile") or die "cannot open $textfile for output"; 
select(OUT);
print $listdata;
close(OUT);

	