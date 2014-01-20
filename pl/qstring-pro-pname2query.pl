#!/usr/local/bin/perl

# rev 03/12/13
# The script is invoked by bin/display-pdgms-pro-pnames.sh.  


use File::Copy;
my ($propsfile, $pnumber, $queryfile, $lang) = @ARGV;
#print "Query string = $qstring\n";
#print "Query file = $queryfile\n";
print "pnumber = $pnumber\n";

my $selection = "";
my ($langname, $Langname, $specifiedprops);
#print "query = $query\n";
$langname = $propsfile;
$langname =~ s/sparql\/pdgms\/pname-pro-list-(.*?)\.txt/\1/;
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
my ($proclass, $qprops) = split(/:/, $queryprops, 2);
print "proclass = $proclass\n";
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
print "SELECT  $selection ?token \n";
print "WHERE\n{\n";
print "\t{\n";
print "\t\tGRAPH aamag:$langname\n\t\t{\n";
print "\t\t\t?s\t$lang:pos\t$lang:Pronoun . \n";
print "\t\t\t?s\taamas:lang\taama:$Langname .\n";
print "\t\t\t?s\t$lang:proClass\t$lang:$proclass .\n";
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
print "\t\t\tOPTIONAL { ?s\t$lang:number\t?number . \n";
print "\t\t\t?number\trdfs:label\t?num . }\n";
print "\t\t\tOPTIONAL {?s\t$lang:person\t?person . \n";
print "\t\t\t?person\trdfs:label\t?pers . }\n";
print "\t\t\tOPTIONAL { ?s\t$lang:gender\t?gender . \n";
print "\t\t\t?gender\trdfs:label\t?gen . }\n";

print "\t\t\t?s\t$lang:token\t?token . \n";
print "\t\t}\n";
print "\t}\n";
print "}\n";
# Iterate through @select if want all values in table
print "ORDER BY  $selection  DESC(?num) ?pers DESC(?gen)\n";
close(OUT); 
#copy($queryfile, "query-temp.rq") or die "Can't copy $queryfile to 'query-temp.rq': $!";