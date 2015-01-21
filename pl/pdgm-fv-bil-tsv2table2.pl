#!/usr/local/bin/perl

#06/03/13: adapted to bin/pdgm-display.sh
# The purpose of this version of pdgmtsv2table.pl is to 
# transform a query.tsv file, output of a paradigm-formation query,
# into a table-formatted text output for display on STDOUT or in 
# text file. It is invoked by pdgm-display.sh

my ($pdgmfile, $plists, $numvals, $persvals, $genvals) = @ARGV;
my $filename = $pdgmfile;
$filename =~ s/\.tsv//;
my $textfile = $filename.".txt";
my $htmlfile = $filename.".html";
#print "Text file = $textfile\n";
#print "HTML file = $htmlfile\n\n";
#print "qstring=$qstring\n";

# Make @pngs, array of all possible row png values
# Val arrays should be eventually passed into script as arg

my @pngs; # an array of png combos
my @numvals = split(/,/, $numvals);
my @persvals = split(/,/, $persvals);
my @genvals = split(/,/, $genvals);
foreach my $number (@numvals)
{
    foreach my $person (@persvals)
    {
	foreach my $gender (@genvals)
	{
	    my $png =$number."\t".$person."\t".$gender;
	    push(@pngs, $png)
	}
    }
}
#print "plists = $plists\n";
# List "pdgm names"
my @plists = split(/\+/, $plists);
undef $/;
print "\n";
my $pdgmno = 0;
my (@pdgmnames, @tokencol);
my ($before, $middle, $after, $queryvals);
foreach my $plist (@plists)
{
    #print "plist = $plist\n";
    $plist =~ s/,//;
    $pdgmno++;
    my $token = "P-$pdgmno";
    push(@tokencol, $token);
    my ($valsfile, $pnumber) = split(/=/, $plist);
    open(IN, $valsfile) || die "cannot open $valsfile for reading";
    while (<IN>)
    { 
	($before, $middle) = split(/$pnumber\. /, $_, 2);
	($queryvals, $after) = split(/\n/, $middle, 2);
    }
    close(IN);
    push(@pdgmnames, "$token: $queryvals");
}
print "\n";


my ($header, $pdgmrows, $prows);
my ($format_png, $format_token, $format_header);
my (@header, @colwidths, @pdgmrows, @rowterms, @prows);



# If input is bil with parallel token cols, have to make new pdgmfile

# Make combined 2-token array
# Make format strings
# Split data into array of constituent pdgms


my @pdgms; # an array of refs to %pdgm (npg=form) structures
my ($header, $tablewidth, $tokenwidth);
open(IN, $pdgmfile) || die "cannot open $pdgmfile for reading";
while (<IN>)
{ 
    my $data = $_;
    # mark off token from rest with &
    $data =~ s/(.*?\t.*?\t.*?\t.*?)\t(.*?\n)/\1&\2/g;
#   $data =~ s/\t/,/g;
    $data =~ s/["?]//g;
    $data =~ s/pdgm\t//g;
    $data =~ s/\nP-\d*?\t/\n/g;
    ($header, $pdgmrows) = split(/\n/, $data, 2);
    $header =~ s/&.*?$//;
    @header = split(/\t/, $header);
    #print "header = $header\n";
    #print "pdgmrows = \n$pdgmrows\n";

    # Recalculate colwidths and format strings
    my $colwidths = $header;
    @colwidths = split( '\t', $colwidths);
    foreach my $colwidth (@colwidths)
    {
	$colwidth = length($colwidth);
    }
    my $termid = "";
    @pdgmrows = split '\n', $pdgmrows;
    foreach my $pdgmrow (@pdgmrows)
    {
	$pdgmrow =~ s/&/\t/;
	@rowterms = split('\t', $pdgmrow);
	# Take care of lex ($rowterms[0])
	for (my $i = 0; $i <= $#rowterms; $i++)
	{
		my $termwidth = length($rowterms[$i]);
		if ($termwidth > $colwidths[$i]) {$colwidths[$i] = $termwidth;}
	}
    }
    $format_png = "| ";
    $tablewidth = 2*(@colwidths + 3) + 3;
    $tokenwidth = $colwidths[$#colwidths];
    for (my $i = 0; $i < $#colwidths; $i++)
    {
    	$format_png .= "%-".$colwidths[$i]."s | ";
    	$tablewidth += $colwidths[$i];
    }
    #print "format_png = $format_png\n";
    $format_token .= "%-".$tokenwidth."s | ";
    #print "format_token = $format_token\n";
    $format_header = $format_png;
    foreach my $tokenhead (@tokencol) 
    {
	push(@header, $tokenhead);
	$format_header .= $format_token;
	$tablewidth += $tokenwidth;
    }
    #print "tablewidth = $tablewidth\n";
    #print "tablewidth = $tablewidth\n";
    #print "tokenwidth = $tokenwidth\n";
    #print "length of colwidths array = $#colwidths+1\n";
    #print "length of pdgms array = $#plists+1\n";
    

    # Form array of pdgms
    my @pdgmdata = split(/$header/, $pdgmrows);
    foreach my $pdgmdata (@pdgmdata)
    {
	#print "Sub-pdgm data now is:\n$pdgmdata\n";
	my %pdgm;
	@prows = split(/\n/, $pdgmdata);
	foreach my $prow(@prows)
	{
	    my ($png, $token) = split(/&/, $prow);
	    $pdgm{$png} = $token;
	}
	my $pdgmref = \%pdgm;
	push (@pdgms, $pdgmref);
    }
}

select STDOUT;
&PrintCompPdgm;

# print pdgm tsv data and header to tab-delimited txt file
open(OUT, ">$textfile") || die "cannot open $textfile for output"; 
select(OUT);
#&PrintPdgm;
close(OUT);


sub PrintCompPdgm {

# print pdgm titles
foreach my $pdgmname (@pdgmnames) {print "$pdgmname\n";}

# print pdgm tsv data and header to tab-delimited txt file
print "-" x $tablewidth;
print "\n";
printf $format_header, @header;
print "\n";
print "=" x $tablewidth;
print "\n";

# Make new data table of occurring strings in pdgms
# A png will not get printed if it is in neither pdgm
foreach my $png (@pngs)
{
     #print "png = $png\n";
     my $pngprint = 0;
     my $pdgmno = 0;
     foreach my $pdgmref (@pdgms)
     {
         #print "\npdgmref->png = $pdgmref->{$png}\n";
	 $pdgmno++;
	 if ($pdgmref->{$png})
	 {
             # If the png is present in the sub-pdgm
	     if ($pngprint == 0)
	     {
		 #If it hasn't been printed yet, print the png
		 my @png = split(/\t/, $png);
		 printf $format_png, @png;
		 $pngprint = 1;
		 for (my $i = 1; $i < $pdgmno;$i++)
		 {
		     #Print blank tokens if this is not the 1st sub-pdgm
		     printf $format_token, "  ";
		 }
		 # Then print the token
		 printf $format_token, $pdgmref->{$png};
	     }else
	     {
		 #Print the token if the png has already been printed
		 printf $format_token, $pdgmref->{$png};
	     }
	 }else
	 {
	     # If the png is not in this sub-pdgm, but is in a previous pdgm
	     if ($pngprint == 1)
	     {
		 #Print a blank token
		 printf $format_token, "  ";
	     }
	 }
     }
     if ($pngprint == 1){ print "\n";}
}
print "-" x $tablewidth;
print "\n\n\n";
}

sub PrintHTML {
# print pdgm to html table: cf.pl/pdgm-fv-tsv2eable.pl

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
	if ($rowterms[0] =~ /http:/) {$rowterms[0] =~ s/.*-(.*?)>/\1/;	}
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
}
