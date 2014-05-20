#!/usr/local/bin/perl

# rev 02/10/13
# rev 06/04/13 adapted to be run by bin/pdgm-display-comp.sh

# As opposed to the earlier version of pdgm-display which works 
# in all languages exclusively with common
# aama: props and vals, it is in practice (depends on
# computational capacities of Fuseki?) impossible to isolate common
# properties in WHERE clause preceding UNION clause in the
# datastore version which has language-specific properties and 
# values (orm:tam, orm:Present). Therefore the comp query 
# developed here will be simply a union of two
# (or more) simple queries.

# This version of pdgmtemplate2query.pl receives one or more args, a
# prop=val string and a query file name. The program constructs 
# a SPARQL query out of the first argument, a possibly multi-partite
# string joined by "+" (ARG1+ARG2+...), where
# each ARG has the structure (cf. at end of comment below): 
#   1) a language name whose pdgm-defining properties it looks up in 
# 		pdgm-finite-props.txt;
# 	2) a string consisting of a series of value specifications for one or
#      more props:  "prop=val:prop=val:..." 
# It then writes the query out to the file-name given in the second
# argument.
# The script is invoked by bin/pdgm-display.sh.  

# Sample $qstring:
# beja-arteiga:tam=Aorist,polarity=Affirmative,conjClass=Prefix,rootClass=CCC+oromo:tam=Past,polarity=Affirmative,derivedStem=Base

use File::Copy;
my ($propsfile, $pnumber, $queryfile, $lang) = @ARGV;
#print "Query string = $qstring\n";
#print "Query file = $queryfile\n";
print "pnumber = $pnumber\n";

my $selection = "";
my ($langname, $Langname, $specifiedprops);
#print "query = $query\n";
$langname = $propsfile;
$langname =~ s/sparql\/pdgms\/pname-nfv-list-(.*?)\.txt/\1/;
#print "langname = $langname\n";
#print "specifiedprops = $specifiedprops\n";
#my $queryfile = "sparql/pdgms/output/$langname";

undef $/;
my $queryprops;
my @queryproplist;
open(IN, $propsfile) || die "cannot open $propsfile for reading";
while (<IN>)
{ 
	my ($before, $middle, $after);
	($before, $middle) = split(/$pnumber\. /, $_, 2);
	($queryprops, $after) = split(/\n/, $middle, 2);
	#print "Queryprops = $queryprops\n";
}
my ($multilex, $qprops) = split(/:/, $queryprops, 2);
print "multilex = $multilex\n";
print "qprops = $qprops\n";
my $Lang = ucfirst($lang);
my $Langname = ucfirst($langname);
@queryproplist = split(/,/, $qprops);
foreach my $queryprop (@queryproplist)
{  
	$qqueryprop = $queryprop; 
	$qqueryprop =~ s/-//;
	$selection .= "?".$qqueryprop." "; 
}
$selection .= "?token";
#foreach my $queryp (@queryproplist)
#{
	#print "Queryp = $queryp\n";
#}
	
print "selection = $selection\n";


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
print "SELECT  $selection \n";
print "WHERE\n{\n";
print "\t{\n";
print "\t\tGRAPH aamag:$langname\n\t\t{\n";
print "\t\t\t?s\t$lang:pos\t$lang:Verb . \n";
print "\t\t\tNOT EXISTS {?s $lang:person ?person } .\n";
print "\t\t\t?s\taamas:lang\taama:$Langname .\n";
print "\t\t\t?s\t$lang:multiLex\t$lang:$multilex .\n";
print "\t\t\t?s\t$lang:token\t?token .\n";
print "\t\t\t?s\taamas:lang\t?lang .\n";
print "\t\t\t?lang\trdfs:label\t?langLabel . \n";
# Iterate through @select if want all values in table
foreach my $queryprop (@queryproplist) 
{
	my $qqueryprop = $queryprop;
	$qqueryprop =~ s/-//;
	if ($queryprop =~ /token/)
	{
		print "\t\t\tOPTIONAL { ?s\t$lang:$queryprop\t?$qqueryprop . }\n";
	}else{
		print "\t\t\tOPTIONAL { ?s\t$lang:$queryprop\t?Q$qqueryprop . \n";
		print " \t\t\t?Q$qqueryprop\trdfs:label\t?$qqueryprop . }\n";
	}
}
#print "\t\t\t?s\t$lang:token\t?token . \n";
print "\t\t}\n";
print "\t}\n";
print "}\n";
# Iterate through @select if want all values in table
print "ORDER BY  $selection  \n";
close(OUT); 
#copy($queryfile, "query-temp.rq") or die "Can't copy $queryfile to 'query-temp.rq': $!";
