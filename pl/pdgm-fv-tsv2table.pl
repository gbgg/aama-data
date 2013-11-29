#!/usr/local/bin/perl

#06/03/13: adapted to bin/pdgm-display.sh
# The purpose of this version of pdgmtsv2table.pl is to 
# transform a query.tsv file, output of a paradigm-formation query,
# into a table-formatted text output for display on STDOUT or in 
# text file. It is invoked by pdgm-display.sh

my ($pdgmfile, $title) = @ARGV;
my $filename = $pdgmfile;
$filename =~ s/\.tsv//;
my $textfile = $filename.".txt";
my $htmlfile = $filename.".html";
#print "Text file = $textfile\n";
#print "HTML file = $htmlfile\n\n";
#print "qstring=$qstring\n";

undef $/;
my ($header, $pdgmrows);
my (@header, @colwidths, @pdgmrows);

# First get array @colwidths with maximum size cell in each col
open(IN, $pdgmfile) || die "cannot open $pdgmfile for reading";
while (<IN>)
{ 
    my $data = $_;
	$data =~ s/"//g;
	$data =~ s/⊤/ /g;
	# Get first line for header
	($header, $pdgmrows) = split(/\n/, $data, 2);
	$header =~ s/\?//g;
	# Initialize colwidths with header
	my $colwidths = $header;
	@header = split('\t', $header);
	@colwidths = split( '\t', $colwidths);
	foreach my $colwidth (@colwidths)
	{
		$colwidth = length($colwidth);
	}
	my $termid = "";
    @pdgmrows = split '\n', $pdgmrows;
    foreach my $pdgmrow (@pdgmrows)
    {
		my @rowterms = split('\t', $pdgmrow);
		for (my $i = 0; $i <= $#rowterms; $i++)
		{
			my $termwidth = length($rowterms[$i]);
			if ($termwidth > $colwidths[$i]) {$colwidths[$i] = $termwidth;}
		}
	}
}
close(IN); 

my $format ="| ";
my $tablewidth = 2*(@colwidths + 3) + 3;
foreach my $colwidth (@colwidths)
{
	$format .= "%-".$colwidth."s | ";
	$tablewidth += $colwidth;
}
$format .= "\n";

# print pdgm table file to STDOUT
select STDOUT;
if ($qstring =~ /\w/)
{
	print "\nPARADIGM: \n\n";
	my(@queries) = split(/\+/,$qstring);
	foreach my $query (@queries)
	{ 
		print "\t$query\n";
	}
	print "\n";
}
#print "Format= $format\n";
#print "Tablewidth= $tablewidth\n\n";
print "-" x $tablewidth;
print "\n";
printf $format, @header;
print "=" x $tablewidth;
print "\n";
foreach my $pdgmrow (@pdgmrows)
 {
	my @rowterms = split('\t', $pdgmrow);
	printf $format, @rowterms;
}
print "-" x $tablewidth;
print "\n";

# print pdgm tsv data and header to tab-delimited txt file
open(OUT, ">$textfile") || die "cannot open $textfile for output"; 
select(OUT);
print "$header\n";
print "$pdgmrows\n";
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
foreach my $heading (@header)
{
	print "                        <th align=\"left\">$heading</th>\n";
}
print "                    </tr>\n";
print "                </thead>\n";
print "                <tbody>\n";
foreach my $pdgmrow (@pdgmrows)
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
