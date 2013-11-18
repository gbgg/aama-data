#!/usr/local/bin/perl

#11/05/13: adapted from earlier valsforproptsv2table.pl 
# This version of propvaltsv2table.pl uses printf to 
# transform a query.tsv file, output of a general propval query,
# into a table-like text output for text display 
# It is invoked by fuquery-prop-val.sh

my ($langpropfile, $value) = @ARGV;
my $textfile = "langsforval-".$value.".txt";
#print "pvfile = $propvalfile\n";
#print "textfile = $textfile\n";
#my $value = $langpropfile;
#$value =~ s/tmp\/prop-val\/.*?\.(.*?)-resp\.tsv/\1/;
$value = uc($value);
#my $htmlfile = $tsvfile;
# $htmlfile =~ s/\.tsv/.html/;
#print "Language = $lang\n";
#print "HTML file = $htmlfile\n\n";

undef $/;
my ( $lenl, $lenp, $lenv);
my (@rows);

open(IN, $langpropfile) or die "cannot open $langpropfile for reading";
while (<IN>)
{ 
    my $data = $_;
	$data =~ s/"//g;
	$data =~ s/⊤/ /g;
	$data =~ s/\?.*?\n//g;
	#print "data = %$data%\n";
	# Initialize colwidths with header
	$lenl = length($value);
	$lenp = length($value);
	$lenv = length($value);
	@rows = split '\n', $data;
    foreach my $row (@rows)
    {
		my ($lang, $pred) = split '\t', $row;
		my $ll = length($lang);
		if ($ll > $lenl) {$lenl = $ll;}
		my $lp = length($pred);
		if ($lp > $lenp) {$lenp = $lp;}
	}
}
close(IN); 
my $format ="| %-".$lenv."s | %-".$lenl."s | %-".$lenp."s\n";
my $tablewidth = $lenv + $lenl + $lenp + 15;
print "format = %$format%\n";
# print pdgm tsv data and header to tab-delimited tsv file
#unlink $tsvfile;
#open(OUT, ">$textfile") or die "cannot open $textfile for output"; 
#select(OUT);
print "-" x $tablewidth;
print "\n";
printf $format, $value, "lang", "property";
print "=" x $tablewidth;
print "\n";
foreach my $row (sort @rows)
{
	my ($lang, $pred) = split '\t', $row;
	printf $format, " ", $lang, $pred;
}
print "-" x $tablewidth;
print "\n";

close(OUT);

