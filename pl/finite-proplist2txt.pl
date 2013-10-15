#!/usr/local/bin/perl

#10/14/13: adapted from pdgmtsv2table.pl 
# This program takes output from applications of pdgm-finite-prop-list.template invoked by finite-prop-list-gen.sh and formats it into the text pdgm-prop-list.txt, which gives for each language the categories occurring in finite verb paradigms. The text is used by pdgm-display.sh for command-line display of pdgm(s) from a given language.

my ($propvalfile) = @ARGV;
my $textfile = "sparql/pdgms/pdgm-prop-list.txt";
print "input file = $propvalfile\n";
print "textfile = $textfile\n";

undef $/;
my ($header, $pdgmrows, $pheader, $vheader, $sheader, $lenp, $lenv, $lens);
my (@header, @pvrows);
my (%propvals);

open(IN, $propvalfile) or die "cannot open $propvalfile for reading";
while (<IN>)
{ 
    my $listdata = $_;
	$data =~ s/"//g;
	$data =~ s/⊤/ /g;
	# Get first line for header
	($header, $pvrows) = split(/\n/, $data, 2);
	$header =~ s/\?//g;
	#$header = "property\tvalue";
	#print "header = $header\n";
	#exit;
	#$header = "schema\t".$header;
	($pheader, $vheader) =split(/\t/, $header);
	$sheader = "schema";
	
	# Initialize colwidths with header
	$lens = length($sheader);
	$lenp = length($pheader);
	$lenv = length($vheader);

	@pvrows = split '\n', $pvrows;
    foreach my $pvrow (@pvrows)
    {
		my ($prop, $val) = split('\t', $pvrow);
		my $proplen = length($prop);
		my $lv = length($val);
		my $ls = index($prop, "/");
		my $lp = $proplen - $ls;
		if ($ls > $lens) {$lens = $ls;}
		if ($lp > $lenp) {$lenp = $lp;}
		if ($lv > $lenv) {$lenv = $lv;}
		$propvals{$prop} .= $val.' ';
	}
}
close(IN); 
my $format ="| %-".$lens."s | %-".$lenp."s | %s\n";
my $tablewidth = $lens + $lenp + $lenv + 15;

# print pdgm table file to STDOUT
select STDOUT;
#print "Format= $format\n";
#print "Tablewidth= $tablewidth\n\n";
print "-" x $tablewidth;
print "\n";
printf $format, $sheader, $pheader, $vheader;
print "=" x $tablewidth;
print "\n";
my ($schema, $property);
foreach my $prop (sort keys %propvals)
{
	if ($prop =~ /\//)
	{
		($schema, $property) = split(/\//, $prop);
	} else
	{
		$schema = ' ';
		$property = $prop;
	}
	my $vals = $propvals{$prop};
	my ($firstval, $restvals) = split(/ /, $vals, 2);
	my @restvals = split(/ /, $restvals);
	printf $format, $schema, $property, $firstval;
	foreach my $restval (@restvals)
	{
		printf $format, " ", " ", $restval;
	}
}
print "-" x $tablewidth;
print "\n";

# print pdgm tsv data and header to tab-delimited tsv file
#unlink $tsvfile;
open(OUT, ">$textfile") or die "cannot open $textfile for output"; 
select(OUT);
print "-" x $tablewidth;
print "\n";
printf $format, $sheader, $pheader, $vheader;
print "=" x $tablewidth;
print "\n";

my ($schema, $property);
foreach my $prop (sort keys %propvals)
{
	if ($prop =~ /\//)
	{
		($schema, $property) = split(/\//, $prop);
	} else
	{
		$schema = ' ';
		$property = $prop;
	}
	my $vals = $propvals{$prop};
	my ($firstval, $restvals) = split(/ /, $vals, 2);
	my @restvals = split(/ /, $restvals);
	printf $format, $schema, $property, $firstval;
	foreach my $restval (@restvals)
	{
		printf $format, " ", " ", $restval;
	}
}
print "-" x $tablewidth;
print "\n";

close(OUT);

