#!/usr/local/bin/perl

#12/12/13: adapted to bin/display-pdgms-. . ..sh
# The purpose of this version of pdgmtsv2table.pl is to 
# transform a query.tsv file, output of a paradigm-formation query,
# into a table-formatted text output for display on STDOUT or in 
# text (or html) file. It is invoked by pdgm-display.sh

my ($pdgmfile, $title) = @ARGV;
my $filename = $pdgmfile;
$filename =~ s/\.tsv//;
my $textfile = $filename.".txt";
my $htmlfile = $filename.".html";
#print "Text file = $textfile\n";
#print "HTML file = $htmlfile\n\n";

# $collength and @collength to zero out cols with no entries
# @colwidths1/2, @header1/2. @pdgmrows1/2  are before and 
# after zero-length cols are eliminated
undef $/;
my ($header, $pdgmrows1, $collength);
my (@header1, @colwidths1, @pdgmrows1, @collength);
my (@header2, @colwidths2, @pdgmrows2);

# First get array @colwidths1 with maximum size cell in each col
open(IN, $pdgmfile) || die "cannot open $pdgmfile for reading";
while (<IN>)
{ 
    my $data = $_;
	$data =~ s/"//g;
	$data =~ s/⊤/ /g;
	# Get first line for header
	($header, $pdgmrows1) = split(/\n/, $data, 2);
	$header =~ s/\?//g;
	# Initialize colwidths1 with header
	my $colwidths = $header;
	@header1 = split('\t', $header);
	@colwidths1 = split( '\t', $colwidths);
	for (my $i = 0; $i <= $#colwidths1; $i++)
	{
		$colwidths1[$i] = length($colwidths1[$i]);
		$collength[$i] = 0;
	}
	my $termid = "";
    @pdgmrows1 = split '\n', $pdgmrows1;
    foreach my $pdgmrow (@pdgmrows1)
    {
		#print "pdgmrow = $pdgmrow\n";
		my @rowterms = split('\t', $pdgmrow);
		for (my $i = 0; $i <= $#rowterms; $i++)
		{
			my $termwidth = length($rowterms[$i]);
			if ($termwidth > $colwidths1[$i]) {$colwidths1[$i] = $termwidth;}
			if ($rowterms[$i] =~ /\w/) {$collength[$i] = 1;}
			#print "rowterms[$i] = $rowterms[$i]\tcollength[$i] = $collength[$i]\n";
		}
	}
}
close(IN); 
#print "collengths = @collength\n";
# Make new @header2, @colwidths2, @pdgmrows2 

for (my $i = 0; $i <= $#colwidths1; $i++)
{
	if ($collength[$i] == 1)
	{
		push(@colwidths2, $colwidths1[$i]);
		push(@header2, $header1[$i]);
	}
}	
#print "pdgmrows1 = \n$pdgmrows1\n";
foreach my $pdgmrow (@pdgmrows1)
{
	#print "pdgmrow = $pdgmrow\n";
	my @rowterms1 = split('\t', $pdgmrow);
	my $rowterms2;
	for (my $i = 0; $i <= $#rowterms1; $i++)
	{
		if ($collength[$i] == 1) {$rowterms2 .= $rowterms1[$i]."\t";}
	}
	$pdgmrows2 .= $rowterms2."\n";
}
#print "pdgmrows2 = \n$pdgmrows2\n";
@pdgmrows2 = split(/\n/, $pdgmrows2);
		
my $format ="| ";
my $tablewidth = 2*(@colwidths2 + 3) + 3;
foreach my $colwidth (@colwidths2)
{
	$format .= "%-".$colwidth."s | ";
	$tablewidth += $colwidth;
}
$format .= "\n";
#print "format = $format\n";
# print pdgm table file to STDOUT
select STDOUT;
print "\nPARADIGM: $title\n";
#my(@queries) = split(/\+/,$qstring);
#foreach my $query (@queries)
#{ 
#	print "\t$query\n";
#}
#print "\n";
#print "Format= $format\n";
#print "Tablewidth= $tablewidth\n\n";
print "-" x $tablewidth;
print "\n";
printf $format, @header2;
print "=" x $tablewidth;
print "\n";
foreach my $pdgmrow (@pdgmrows2)
 {
	my @rowterms = split('\t', $pdgmrow);
	printf $format, @rowterms;
}
print "-" x $tablewidth;
print "\n";


# print pdgm tsv data and header to tab-delimited txt file
open(OUT, ">$textfile") || die "cannot open $textfile for output"; 
select(OUT);
print "@header2\n";
print "@pdgmrows2\n";
close(OUT);

# print pdgm to html table
open(OUT, ">$htmlfile") || die "cannot open $htmlfile for output"; 
select(OUT);
print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
print "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"\n";
print "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n";
print "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n";
print "    <head>\n";
print "        <title>$filename</title>\n";
print "    </head>\n";
print "    <body>\n";
print "        <h1>$filename</h1>\n";
print "            <table>\n";
print "                <thead>\n";
print "                    <tr>\n";
foreach my $heading (@header2)
{
	print "                        <th align=\"left\">$heading</th>\n";
}
print "                    </tr>\n";
print "                </thead>\n";
print "                <tbody>\n";
foreach my $pdgmrow (@pdgmrows2)
{
	print "<tr>\n";
	my @rowterms = split('\t', $pdgmrow);
	foreach my $rowterm (@rowterms)
	{
		print "<td>$rowterm</td>";
	}		
	print "\n</tr>\n";
}
print "                </tbody>\n";
print "            </table>\n";
print "    </body>\n";
print "</html>\n";
close(OUT); 
