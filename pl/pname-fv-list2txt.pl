#!/usr/local/bin/perl

#10/14/13: adapted from pdgmtsv2table.pl 
# This program takes output from applications of pdgm-finite-prop-list.template invoked by finite-prop-list-gen.sh and formats it into the text pdgm-prop-list.txt, which gives for each language the categories occurring in finite verb paradigms. The text is used by pdgm-display.sh for command-line display of pdgm(s) from a given language.

my ($pnamefile, $lang) = @ARGV;
my $textfile = "sparql/pdgms/pname-fv-list-$lang.txt";
#print "input file = $pnamefile\n";
print "textfile = $textfile\n";

undef $/;
my $listdata;
open(IN, $pnamefile) or die "cannot open $pnamefile for reading";
while (<IN>)
{ 
        $listdata = $_;
	$listdata =~ s/^\?.*?\n//g;
	$listdata =~ s/\t//g;
	$listdata =~ s/""/,/g;
	$listdata =~ s/"//g;
}
#print $listdata;
my @listdata = split(/\n/, $listdata);

my $currproplist;
my $index = 1;
my $pdgmlen = 1;
foreach my $proplist (sort @listdata)
{
    #print "proplist = $proplist\ncurrproplist = $currproplist\n";
    
    if ($proplist eq $currproplist)
    {
	$pdgmlen++;
    }
    else
    {
	print $index.". ".$proplist." (".$pdgmlen.")\n";
	$index++;
	$currproplist = $proplist;
	$pdgmlen = 1;
    }
}
print $index.". ".$currproplist." (".$pdgmlen.")\n";

# print pdgm tsv data and header to tab-delimited tsv file
#unlink $tsvfile;
open(OUT, ">$textfile") or die "cannot open $textfile for output"; 
select(OUT);
my $index = 1;
my $pdgmlen = 1;
foreach my $proplist (sort @listdata)
{
    #print "proplist = $proplist\ncurrproplist = $currproplist\n";
    
    if ($proplist eq $currproplist)
    {
	$pdgmlen++;
    }
    else
    {
	print $index.". ".$currproplist." (".$pdgmlen.")\n";
	$index++;
	$currproplist = $proplist;
	$pdgmlen = 1;
    }
}
print $index.". ".$currproplist." (".$pdgmlen.")\n";
print "\n\n";
close(OUT);

	
