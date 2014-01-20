#!/usr/local/bin/perl

#09/03/13: adapted from earlier pdgmtsv2table.pl 
# This version of propvaltsv2table.pl uses printf to 
# transform a query.tsv file, output of a general propval query,
# into a table-like text output for text display 
# It is invoked by fuquery-prop-val.sh

my ($propvalfile, $type) = @ARGV;
my $textfile = "valsforprop-".$type.".txt";
#print "pvfile = $propvalfile\n";
#print "textfile = $textfile\n";
my $lang = $propvalfile;
$lang =~ s/tmp\/prop-val\/.*?\.(.*?)-resp\.tsv/\1/;
$lang = uc($lang);
#my $htmlfile = $tsvfile;
# $htmlfile =~ s/\.tsv/.html/;
#print "Language = $lang\n";
#print "HTML file = $htmlfile\n\n";

undef $/;
my ( $lenp, $lenv, $lenl);
my (@vrows);

open(IN, $propvalfile) or die "cannot open $propvalfile for reading";
while (<IN>)
{ 
    my $data = $_;
	$data =~ s/"//g;
	$data =~ s/⊤/ /g;
	$data =~ s/\?valuelabel\n//;
	
	# Initialize colwidths with header
	$lenl = length($lang);
	$lenp = length($type);
	$lenv = length($type);

	@vrows = split '\n', $data;
    foreach my $vrow (@vrows)
    {
		my $lv = length($vrow);
		if ($lv > $lenv) {$lenv = $lv;}
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
printf $format, $lang, $type, "value";
print "=" x $tablewidth;
print "\n";
foreach my $value (sort @vrows)
{
	printf $format, " ", " ", $value;
}
print "-" x $tablewidth;
print "\n";

close(OUT);

