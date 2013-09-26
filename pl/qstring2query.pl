#!/usr/local/bin/perl

# rev 02/10/13
# rev 05/31/13 adapted to be run by bin/pdgm-display.sh

# This is a version of pdgmtemplate2query.pl,  constructs a SPARQL query 
# from an @ARGV string of format: langName+prop=val:prop=val: . . .
# where langName a language name whose pdgm-defining properties it looks
# up in pdgm-finite-props.txt; and "prop=val:prop=val:..." is a set of
# value specifications for one or more props.
#   
# The script is invoked by bin/pdgm-display.sh.  

# rev 02/22/13
# changed $lang, $langvar to $aamalang
# 05/31/13: adapted to aama/ (branch dev)

use File::Copy;
my ($qstring, $queryfile) = @ARGV;
#print "Query file = $queryfile\n";
#print "Query string = $qstring\n";
my ($langname, $specifiedprops) = split(/\+/, $qstring);
my ($txtfile) = "sparql/pdgms/pdgm-finite-props.txt";
#my $queryfile = "sparql/pdgms/output/$langname";

my %specifiedprops;
my @specifiedprops = split(/:/, $specifiedprops);
foreach my $specifiedprop (@specifiedprops)
{
	my ($prop, $value) = split(/=/, $specifiedprop);
	$specifiedprops{$prop} = $value;
	#$queryfile .= "-".$value;
}
#$queryfile .= "-query.rq";
#print "Query = $queryfile\n";

undef $/;
my $queryprops;
my @queryproplist;
open(IN, $txtfile) || die "cannot open $txtfile for reading";
while (<IN>)
{ 
	my $pdgmprops = $_;
	my ($first, $props) = split("$langname : \"", $pdgmprops);
	($queryprops, my $last) = split(/"\n/, $props, 2);
	#print "Queryprops = $queryprops\n\n";
}

my ($lang, $qprops) = split(/,\s*/, $queryprops, 2);
#print "qprops = $qprops\n";
#my $lang = ucfirst($lang);
my $Langname = ucfirst($langname);
my @select = split(/,\s* /, $qprops);
my $selection = "";
foreach my $queryprop (@select)
 {  
	#if ($specifiedprops !~ /$queryprop.":"/)
	if ( $specifiedprops{$queryprop} !~ /\w/)
	{
		$selection .= "?".$queryprop." "; 
		push( @queryproplist, $queryprop );
	}
}
#print "selection = $selection\n";

open(OUT, ">$queryfile") || die "cannot open $queryfile for output"; 
select(OUT);
print "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>\n";
print "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n";
print "PREFIX aama: <http://id.oi.uchicago.edu/aama/2013/>\n";
print "PREFIX aamas:	 <http://id.oi.uchicago.edu/aama/2013/schema/>\n";
print "PREFIX aamag:	 <http://oi.uchicago.edu/aama/2013/graph/>\n";
print "PREFIX $lang:   <http://id.oi.uchicago.edu/aama/2013/$langname/>\n";

print "\n";
# Iterate through @select if want all values in table
print "SELECT $selection ?num ?pers ?gen ?token\n";
print "WHERE\n{\n";
print "\tGRAPH aamag:$langname\n\t{\n";
print "\t\t?s\t$lang:pos\t$lang:Verb . \n";
print "\t\t?s\taamas:lang\taama:$Langname .\n";
# Iterate through @select if want all values in table
foreach my $specifiedprop (sort keys %specifiedprops)
{
	print "\t\t?s\t$lang:$specifiedprop\t$lang:$specifiedprops{$specifiedprop} . \n";
}
foreach my $queryprop (@queryproplist) 
{
	print "\t\tOPTIONAL { ?s\t$lang:$queryprop\t?Q$queryprop . \n";
	print " \t\t?Q$queryprop\trdfs:label\t?$queryprop . }\n";
}
print "\t\tOPTIONAL { ?s\t$lang:number\t?number . \n";
print "\t\t?number\trdfs:label\t?num . }\n";
print "\t\t?s\t$lang:person\t?person . \n";
print "\t\t?person\trdfs:label\t?pers . \n";
print "\t\tOPTIONAL { ?s\t$lang:gender\t?gender . \n";
print "\t\t?gender\trdfs:label\t?gen . }\n";
print "\t\t?s\t$lang:token\t?token . \n";
print "\t}\n";
print "}\n";
# Iterate through @select if want all values in table
print "ORDER BY $selection  DESC(?num) ?pers DESC(?gen)\n";
close(OUT); 
#copy($queryfile, "query-temp.rq") or die "Can't copy $queryfile to 'query-temp.rq': $!";