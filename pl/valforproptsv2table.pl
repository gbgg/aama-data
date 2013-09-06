#!/usr/local/bin/perl

#09/03/13: adapted from earlier pdgmtsv2table.pl 
# This version of propvaltsv2table.pl uses printf to 
# transform a query.tsv file, output of a general propval query,
# into a table-like text output for text display 
# It is invoked by fuquery-prop-val.sh

my ($propvalfile, $type) = @ARGV;
my $textfile = "valsforprop-".$type.".txt";
print "pvfile = $propvalfile\n";
print "textfile = $textfile\n";
my $lang = $propvalfile;
$lang =~ s/tmp\/prop-val\/.*?\.(.*?)-resp\.tsv/\1/;
$lang = uc($lang);
#my $htmlfile = $tsvfile;
# $htmlfile =~ s/\.tsv/.html/;
print "Language = $lang\n";
#print "HTML file = $htmlfile\n\n";

undef $/;
my ($header, $pdgmrows, $pheader, $vheader, $sheader, $lenp, $lenv, $lens);
my (@header, @vrows);
my (%propvals); #?

open(IN, $propvalfile) or die "cannot open $propvalfile for reading";
while (<IN>)
{ 
    my $data = $_;
	$data =~ s/"//g;
	$data =~ s/⊤/ /g;
	# Get first line for header
	($header, $vrows) = split(/\n/, $data, 2);
	$header =~ s/\?//g;
	#$header = "property\tvalue";
	#print "header = $header\n";
	#exit;
	#$header = "schema\t".$header;
	#($pheader, $vheader) =split(/\t/, $header);
	#$sheader = "schema";
	
	# Initialize colwidths with header
	$lenl = length($lang);
	$lenp = length($type);
	$lenv = length($header);

	@vrows = split '\n', $vrows;
    foreach my $vrow (@vrows)
    {
		#my ($prop, $val) = split('\t', $pvrow);
		#my $proplen = length($prop);
		my $lv = length($vrow);
		#my $ls = index($prop, "/");
		#my $lp = $proplen - $ls;
		#if ($ls > $lens) {$lens = $ls;}
		#if ($lp > $lenp) {$lenp = $lp;}
		if ($lv > $lenv) {$lenv = $lv;}
		#$propvals{$prop} .= $val.' ';
	}
}
close(IN); 
my $format ="| %-".$lenl."s | %-".$lenp."s | %s\n";
my $tablewidth = $lenl + $lenp + $lenv + 15;

# print pdgm tsv data and header to tab-delimited tsv file
#unlink $tsvfile;
#open(OUT, ">$textfile") or die "cannot open $textfile for output"; 
#select(OUT);
print "-" x $tablewidth;
print "\n";
printf $format, "language, property, value";
print "=" x $tablewidth;
print "\n";
[9/10/13 -- BEGIN HERE]
my ($schema, $property);
foreach my $value (sort @vrows)
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

