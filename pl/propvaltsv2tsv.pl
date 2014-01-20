#!/usr/local/bin/perl

#09/03/13: adapted from pdgmtsv2table.pl 
# The purpose of this version of propvaltsv2table.pl is to 
# transform a query.tsv file, output of a general propval query,
# into a table-like tsv output for display in spreadsheet 
# It is invoked by fuquery-prop-val.sh

my ($propvalfile) = @ARGV;
my $tsvfile = $propvalfile;
$tsvfile =~ s/-resp//;
my $lang = $tsvfile;
$lang =~ s/sparql\/prop-val\/propval\.(.*?)\.tsv/\1/;
$lang = uc($lang);
#my $htmlfile = $tsvfile;
# $htmlfile =~ s/\.tsv/.html/;
print "Language = $lang\n";
#print "HTML file = $htmlfile\n\n";

undef $/;
my ($header, $pdgmrows, $property);
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
	
	my $termid = "";
    @pvrows = split '\n', $pvrows;
    foreach my $pvrow (@pvrows)
    {
		my ($prop, $val) = split('\t', $pvrow);
		$propvals{$prop} .= $val.' ';
	}
}
close(IN); 

# print pdgm tsv data and header to tab-delimited tsv file
#unlink $tsvfile;
open(OUT, ">$tsvfile") or die "cannot open $tsvfile for output"; 
select(OUT);
printf "%-20s %-30s %-50s\n", "schema", $header, $lang;
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
	print $schema."\t".$property."\t".$firstval."\n";
	foreach my $restval (@restvals)
	{
		print "\t\t".$restval."\n";
	}
}
close(OUT);

