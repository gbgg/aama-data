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
my ($qstring, $queryfile) = @ARGV;
#print "Query string = $qstring\n";
#print "Query file = $queryfile\n";

my ($propsfile) = "sparql/pdgms/pdgm-non-finite-prop-list.txt";
my $selection = "";
my ($lang, $langname, $Langname, $specifiedprops);
my (@langs, @Langs, @graphs);
my @queryproplist;
my %specifiedprops;
my (@queries) = split(/\+/, $qstring);
foreach my $query (@queries)
{
	#print "query = $query\n";
	($langname, $specifiedprops) = split(/:/, $query);
	#print "langname = $langname\n";
	#print "specifiedprops = $specifiedprops\n";
	#my $queryfile = "sparql/pdgms/output/$langname";

	my @specifiedprops = split(/,/, $specifiedprops);
	foreach my $specifiedprop (@specifiedprops)
	{
		my ($prop, $value) = split(/=/, $specifiedprop);
		$specifiedprops{$prop} = $value;
		#$queryfile .= "-".$value;
	}
	#foreach my $sprop (sort keys %specifiedprops)
	#{
		#print "$sprop => $specifiedprops{$sprop}\n";
	#}
	#$queryfile .= "-query.rq";
	#print "Query = $queryfile\n";
	undef $/;
	my $queryprops;
	open(IN, $propsfile) || die "cannot open $propsfile for reading";
	while (<IN>)
	{ 
		my $pdgmprops = $_;
		my ($first, $props) = split("$langname : \"", $pdgmprops);
		($queryprops, my $last) = split(/"\n/, $props, 2);
		print "$langname Queryprops = $queryprops\n\n";
	}
	close IN;
	($lang, my $qprops) = split(/,\s*/, $queryprops, 2);
	print "$lang qprops = $qprops\n";
	$Langname = ucfirst($langname);
	my @select = split(/,\s* /, $qprops);
	foreach my $queryprop (@select)
	 {  
		#if ($specifiedprops !~ /$queryprop.":"/)
		if ( $specifiedprops{$queryprop} !~ /\w/)
		{
			if ($selection !~ $queryprop)
			{
				$selection .= "?".$queryprop." "; 
			}
			push( @queryproplist, $queryprop );
		}
	}
	#foreach my $queryp (@queryproplist)
	#{
		#print "Queryp = $queryp\n";
	#}
}	
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
print "SELECT $selection ?token\n";
print "WHERE\n{\n";
print "\t{\n";
print "\t\tGRAPH aamag:$langname\n\t\t{\n";
print "\t\t\t?s\t$lang:pos\t$lang:Verb . \n";
print "\t\t\tNOT EXISTS {?s $lang:person ?person } .\n";
print "\t\t\t?s\taamas:lang\taama:$Langname .\n";
print "\t\t\t?s\taamas:lang\t?lang .\n";
print "\t\t\t?lang\trdfs:label\t?langLabel . \n";
foreach my $specifiedprop (sort keys %specifiedprops)
{
	print "\t\t\t?s\t$lang:$specifiedprop\t$lang:$specifiedprops{$specifiedprop} . \n";
}
foreach my $queryprop (@queryproplist) 
{
	print "\t\t\tOPTIONAL { ?s\t$lang:$queryprop\t?Q$queryprop . \n";
	print " \t\t\t?Q$queryprop\trdfs:label\t?$queryprop . }\n";
}
print "\t\t\t?s\t$lang:token\t?token . \n";
print "\t\t}\n";
print "\t}\n";
print "}\n";
# Iterate through @select if want all values in table
print "ORDER BY   $selection  \n";
close(OUT); 
#copy($queryfile, "query-temp.rq") or die "Can't copy $queryfile to 'query-temp.rq': $!";