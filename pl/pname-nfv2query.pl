#!/usr/local/bin/perl

# rev 11/26/13 adapted from qstring2query.pl
# The script is invoked by bin/pname-display.sh.  
# Script receives list of finite verb props and vals, and produces list of occurring combinations of these values in finite verb paradigms


use File::Copy;
my ($proplistfile, $langname, $labbrev, $queryfile) = @ARGV;
#print "Query string = $qstring\n";
print "Query file = $queryfile\n";

my $selection = "";
my @queryproplist;
my ($Langname);
#my (@langs, @Langs, @graphs);
#my (@queries) = split(/\+/, $qstring);

#print "langname = $langname\n";

undef $/;
open(IN, $proplistfile) || die "cannot open $propsfile for reading";
while (<IN>)
{ 
	my $pdgmproplist = $_;
	$pdgmproplist =~ s/^\?.*?\n//;
	$pdgmproplist =~ s/"//g;
	$pdgmproplist =~ s/token-.*?\n//g;
	(@queryproplist) = split(/\n/, $pdgmproplist);
}

my $Labbrev = ucfirst($labbrev);
my $Langname = ucfirst($langname);
foreach my $queryprop (@queryproplist)
{  
 			$selection .= "?".$queryprop." "; 
}
	
#print "selection = $selection\n";


open(OUT, ">$queryfile") || die "cannot open $queryfile for output"; 
select(OUT);
print "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>\n";
print "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n";
print "PREFIX aama: <http://id.oi.uchicago.edu/aama/2013/>\n";
print "PREFIX aamas:	 <http://id.oi.uchicago.edu/aama/2013/schema/>\n";
print "PREFIX aamag:	 <http://oi.uchicago.edu/aama/2013/graph/>\n";
print "PREFIX $labbrev:   <http://id.oi.uchicago.edu/aama/2013/$langname/>\n";
print "\n";
# Iterate through @select if want all values in table
print "SELECT DISTINCT ?langLabel $selection \n";
print "WHERE\n{\n";
print "\t{\n";
print "\t\tGRAPH aamag:$langname\n\t\t{\n";
print "\t\t\t?s $labbrev:pos $labbrev:Verb . \n";
print "\t\t\tNOT EXISTS {?s bar:person ?person }\n";
print "\t\t\t?s aamas:lang aama:$Langname .\n";
print "\t\t\t?s aamas:lang ?lang .\n";
print "\t\t\t?lang rdfs:label ?langLabel . \n";
# Iterate through @select if want all values in table
foreach my $queryprop (@queryproplist) 
{
	print "\t\t\tOPTIONAL { ?s $labbrev:$queryprop ?Q$queryprop . \n";
	print " \t\t\t?Q$queryprop rdfs:label ?$queryprop . }\n";
}
#print "\t\t\t?s\taamas:lexeme\t?lexeme . \n";
print "\t\t}\n";
print "\t}\n}\n";

# Iterate through @select if want all values in table
print "ORDER BY ?langLabel  $selection \n";
close(OUT); 
#copy($queryfile, "query-temp.rq") or die "Can't copy $queryfile to 'query-temp.rq': $!";