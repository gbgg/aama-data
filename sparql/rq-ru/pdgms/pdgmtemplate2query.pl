#!/usr/local/bin/perl

# rev 02/10/13

# This is a version of pdgmtemplate2query.pl, and is to be run in the 
# tools/rq-ru/pdgm-def directory. It constructs a SPARQL query 
# from an @ARGV string of format:
#	langName+prop=val:prop=val: . . .
# where langName a language name whose pdgm-defining properties it looks
# up in pdgm-finite-props.txt; and "prop=val:prop=val:..." is a set of
# value specifications for one or more props.
#   
# The script is invoked by rq-make-query-display.sh.  

# rev 02/22/13
# changed $lang, $langvar to $aamalang

use File::Copy;
my ($qstring) = @ARGV;
print "Query String = $qstring\n";
my ($langname, $specifiedprops) = split(/\+/, $qstring);
my ($txtfile) = "pdgm-finite-props.txt";
my $queryfile = $langname;

my %specifiedprops;
my @specifiedprops = split(/:/, $specifiedprops);
foreach my $specifiedprop (@specifiedprops)
{
	my ($prop, $value) = split(/=/, $specifiedprop);
	$specifiedprops{$prop} = $value;
	$queryfile .= "-".$value;
}
$queryfile .= "-query.rq";
print "Query = $queryfile\n";

undef $/;
my $queryprops;
my @queryproplist;
open(IN, $txtfile) || die "cannot open $txtfile for reading";
while (<IN>)
{ 
	my $pdgmprops = $_;
	my ($first, $props) = split("$langname : \"", $pdgmprops);
	($queryprops, my $last) = split(/"\n/, $props, 2);
	print "Queryprops = $queryprops\n\n";
}

my @select = split(/,\s* /, $queryprops);
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
my $aamalang  = "";
$aamalang = $langname;

print "Lang = $aamalang\n";
open(OUT, ">$queryfile") || die "cannot open $queryfile for output"; 
select(OUT);
print "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>\n";
print "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n";
print "PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>\n";
print "\n";
# Iterate through @select if want all values in table
print "SELECT $selection ?num ?pers ?gen ?token\n";
print "WHERE\n{\n";
print "\t?s\taama:pos\taama:verb . \n";
print "\t?s\taama:lang\taama:$aamalang .\n";
# Iterate through @select if want all values in table
foreach my $specifiedprop (sort keys %specifiedprops)
{
	print "\t?s\taama:$specifiedprop\taama:$specifiedprops{$specifiedprop} . \n";
}
foreach my $queryprop (@queryproplist) 
{
	print "\tOPTIONAL { ?s\taama:$queryprop\t?Q$queryprop . \n";
	print " \t\t?Q$queryprop\trdfs:label\t?$queryprop . }\n";
}
print "\t?s\taama:number\t?number . \n";
print "\t?number\trdfs:label\t?num . \n";
print "\t?s\taama:person\t?person . \n";
print "\t?person\trdfs:label\t?pers . \n";
print "\t?s\taama:gender\t?gender . \n";
print "\t?gender\trdfs:label\t?gen . \n";
print "\t?s\taama:token\t?token . \n";
print "}\n";
# Iterate through @select if want all values in table
print "ORDER BY $selection  DESC(?num) ?pers DESC(?gen)\n";
close(OUT); 
copy($queryfile, "query-temp.rq") or die "Can't copy $queryfile to 'query-temp.rq': $!";