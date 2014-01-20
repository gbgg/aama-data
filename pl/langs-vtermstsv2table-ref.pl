#!/usr/local/bin/perl

#11/12/13: adapted from earlier langspvtsv2table.pl 
# This script uses printf to 
# transform a query.tsv file, output of a general propval query,
# into a table-like text output for text display 
# It is invoked by display-langvterms.sh

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
my (%tokenVals, %langTv);
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
	$colwidths[2] = 0;
	$data =~ s/\?.*?\n//g;
	@rows = split '\n', $data;
	my ($currentToken, $currentLang);
    foreach my $row (@rows)
    {
		my($lng, $token, $val) = split '\t', $row;
		#print "$lng, $token, $val\n";
		if ($lng eq $currentLang)
		{
			if ($token eq $currentToken)
			{
				$tokenVals{$currentToken} .= $val." ";
			}else{
				my $lv = length($tokenVals{$currentToken});
				if ($lv > $colwidths[2]){$colwidths[2] = $lv;}
				my $lt = length($token);
				if ($lt > $colwidths[1]){$colwidths[1] = $lt;}
				$currentToken = $token;
				$tokenVals{$currentToken} .= $val." ";
			}
		}else{
			my $tokenValsRef = \%tokenVals;
			$langTv{"tokenVals"} = $tokenValsRef;
			$langTv{"lang"} = $currentLang;
		}
		my $ll = length($lng);
		if ($ll > $colwidths[0]){$colwidths[0] = $ll;}
		$currentToken = $token;
		$tokenVals{$currentToken} .= $val." ";
		$currentLang = $lng;
	}
}
close(IN); 
foreach my $token (sort keys %tokenVals)
{
	print "$token = $tokenVals{$token}\n";
}
my $format ="";
my $tablewidth = 15;
foreach my $colwidth (@colwidths)
{
	$format .= "| %-".$colwidth."s";
	$tablewidth = $tablewidth + $colwidth;
}
#$format .= "\n";	
print "format = \"$format\" tablewidth = $tablewidth\n";
# print pdgm tsv data and header to tab-delimited tsv file
#unlink $tsvfile;
#open(OUT, ">$textfile") or die "cannot open $textfile for output"; 
#select(OUT);
print "-" x $tablewidth;
print "\n";
printf $format, @heads;
print "\n";
print "=" x $tablewidth;
print "\n";
foreach my $lang (sort keys  %langTv)
{
	print "LANG = $lang\n";
#	my $specifiedprops = $graphref->{"specifiedprops"};
	my $tokenVals = $lang->{"tokenVals"};
	foreach my $token (sort keys %{$tokenVals})
	{
		my $vals = $tokenVals{$token};
		printf $format, $lang, $token, $vals;
	}
}
print "-" x $tablewidth;
print "\n";

close(OUT);

