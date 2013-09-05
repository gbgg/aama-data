#!/usr/local/bin/perl

#09/03/13: adapted from earlier pdgmtsv2table.pl 
# This version of propvaltsv2table.pl uses printf to 
# transform a query.tsv file, output of a general propval query,
# into a table-like text output for text display 
# It is invoked by fuquery-prop-val.sh

my ($propvalfile) = @ARGV;
my $textfile = $propvalfile;
print "pvfile = $propvalfile\n";
$textfile =~ s/-resp\.tsv/.txt/;
print "textfile = $textfile\n";
my $lang = $textfile;
$lang =~ s/tmp\/prop-val\/propval\.(.*?)\.txt/\1/;
$lang = uc($lang);
#my $htmlfile = $tsvfile;
# $htmlfile =~ s/\.tsv/.html/;
print "Language = $lang\n";
#print "HTML file = $htmlfile\n\n";

undef $/;
my ($header, $pdgmrows, $pheader, $vheader, $sheader, $lenp, $lenv, $lens);
my (@header, @pvrows);
my (%propvals);

open(IN, $propvalfile) or die "cannot open $propvalfile for reading";
while (<IN>)
{ 
    my $data = $_;
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

