#!/usr/local/bin/perl

#11/11/13: adapted from earlier valsforproptsv2table.pl 
# This version of propvaltsv2table.pl uses printf to 
# transform a query.tsv file, output of a general propval query,
# into a table-like text output for text display 
# It is invoked by display-langspropval.sh

my ($langpropfile) = @ARGV;
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
my ( $header, $rest);
my (@heads, @headwidths, @rows);

open(IN, $langpropfile) or die "cannot open $langpropfile for reading";
while (<IN>)
{ 
    my $data = $_;
	$data =~ s/"//g;
	$data =~ s/⊤/ /g;
	# Get header and initialize colwidths 
	($header, $rest) = split('\n', $data, 2);
	$header =~ s/\?//g;
	$header =~ s/Label//g;
	@heads = split(/\t/, $header);
	$cols = $#heads;
	for (my $i = 0; $i<= $cols; $i++)
	{
		$headwidths[$i] = length($heads[$i]);
		#print "$i length of $heads[$i] = $headwidths[$i]\n";
	}
	$data =~ s/\?.*?\n//g;
	@rows = split '\n', $data;
    foreach my $row (@rows)
    {
		my @vals = split '\t', $row;
		for (my $i = 0; $i <= $cols; $i++)
		{
			my $lv = length($vals[$i]);
			my $lh = length($headwidths[$i]);
			#print "$i length of $vals[$i] = $lv\n";
			if ($lv > $headwidths[$i])
			{
				$headwidths[$i] = $lv;
				#print "$i now headwidths[$i] = $lv\n";
			}
		}
	}
}
close(IN); 
my $format ="";
my $tablewidth = 15;
foreach my $headwidth (@headwidths)
{
	$format .= "| %-".$headwidth."s";
	$tablewidth = $tablewidth + $headwidth;
}
$format .= "\n";	
#print "format = $format tablewidth = $tablewidth\n";
# print pdgm tsv data and header to tab-delimited tsv file
#unlink $tsvfile;
#open(OUT, ">$textfile") or die "cannot open $textfile for output"; 
#select(OUT);
print "-" x $tablewidth;
print "\n";
printf $format, @heads;
print "=" x $tablewidth;
print "\n";
foreach my $row (sort @rows)
{
	my @row = split '\t', $row;
	printf $format, @row;
}
print "-" x $tablewidth;
print "\n";

close(OUT);

