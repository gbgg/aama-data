#!/usr/local/bin/perl

#11/12/13: adapted from earlier langspvtsv2table.pl 
# This script uses printf to 
# transform a query.tsv file, output of a general propval query,
# into a table-like text output for text display 
# It is invoked by display-langvterms.sh

my ($langpropfile, $qstring) = @ARGV;
my $qlabel = $langprofile;
$qlabel =~ s/tmp\/prop-val\/.*?\.(.*?)-resp\.tsv/\1/;
my $textfile = "tmp/prop-val/".$qlabel.".txt";
#print "pvfile = $langpropvalfile\n";
#print "textfile = $textfile\n";
#my $htmlfile = $tsvfile;
# $htmlfile =~ s/\.tsv/.html/;
#print "Language = $lang\n";
#print "HTML file = $htmlfile\n\n";

undef $/;
my (%tokenVals);
my (@heads, @colwidths, @rows);
# General strategy: work with hash of hashes %langTv, whose key is a lang and whose values are a hash %tokenVals, whose key is a token and whose value is a string of the morphosyntactic values of the token.
open(IN, $langpropfile) or die "cannot open $langpropfile for reading";
while (<IN>)
{ 
    my $data = $_;
	$data =~ s/"//g;
	$data =~ s/⊤/ /g;
	# Get header and initialize colwidths 
	@heads = ("Language", "Token", "Values");
	$cols = $#heads;
	$colwidths[0] = length($heads[0]);
	$colwidths[1] = length($heads[1]);
	#$colwidths[2] = 0;
	$data =~ s/\?.*?\n//g;
	@rows = split '\n', $data;
    foreach my $row (@rows)
    {
		my($lng, $token, $val) = split '\t', $row;
		my($lngToken) = $lng."%".$token;
		#print "$lng, $token, $val\n";
		$tokenVals{$lngToken} .= $val." ";
		#my $lv = length($tokenVals{$lngToken});
		#if ($lv > $colwidths[2]){$colwidths[2] = $lv;}
		my $lt = length($token);
		if ($lt > $colwidths[1]){$colwidths[1] = $lt;}
		my $ll = length($lng);
		if ($ll > $colwidths[0]){$colwidths[0] = $ll;}
	}
}
close(IN); 
my $format ="";
my $tablewidth = 15;
foreach my $colwidth (@colwidths)
{
	$format .= "| %-".$colwidth."s";
	$tablewidth = $tablewidth + $colwidth;
}
#$format .= "\n";	
print "format = \"$format\" tablewidth = $tablewidth\n";

#open(OUT, ">$textfile") or die "cannot open $textfile for output"; 
#select(OUT);
# Several print possibilities:

# 1) print to table
# Disabled for now. Yields cols. too wide to display.
#print "-" x $tablewidth;
#print "\n";
#printf $format, @heads;
#print "\n";
#print "=" x $tablewidth;
#print "\n";
#foreach my $langToken (sort keys  %tokenVals)
#{
#	my $vals = $tokenVals{$langToken};
#  my $values;
#	foreach $value (@values)
#	{
#		$values .= $value.", ";
#	}
#	my ($lang, $token) = split(/%/, $langToken);
#	printf $format, $lang, $token;
#	print "\t$values\n";
#
#print "-" x $tablewidth;
#print "\n";

#2) print to language-headed list
my $currentLang;
foreach my $langToken (sort keys  %tokenVals)
{
	my $vals = $tokenVals{$langToken};
	my @vals = split(/ /, $vals);
	my @values = sort(@vals);
	my $values;
	foreach $value (@values)
	{
		$values .= $value.", ";
	}
	$values =~ s/, $//;
	my ($lang, $token) = split(/%/, $langToken);
	my $headlength = length($lang) + length($qstring) + 2;
	if ($lang ne $currentLang)
	{
		print "\n";
		print "-" x $headlength;
		print "\n";
		print "$lang: $qstring\n";
		print "=" x $headlength;
		print "\n";
		$currentLang = $lang;
	}
	print "\t$token:\t$values\n";
}
print "-" x $headlength;

# 3) print pdgm tsv data and header to tab-delimited tsv file
#unlink $tsvfile;

#close(OUT);
