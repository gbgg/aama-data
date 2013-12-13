#!/usr/local/bin/perl

# 11/29/13, called by display-pdgms-fv-pnames.sh

use File::Copy;
my ($valsfile,  $queryfile, $pnumber, $lang) = @ARGV;

my ($langname, $Langname, $Lang);

undef $/;
my ($queryvals, $qprops, $multilex, $lname);
my ($before, $middle, $after);
my @queryvallist;
open(IN, $valsfile) || die "cannot open $valsfile for reading";
while (<IN>)
{ 
	($before, $middle) = split(/$pnumber\. /, $_, 2);
	($queryvals, $after) = split(/\n/, $middle, 2);
}
close(IN);
print "PARADIGM: $queryvals\n";
($Langname, $qvals) = split(/,/, $queryvals, 2);
$Lang = ucfirst($lang);
$langname = lc($Langname);
#print "qvals = $qvals\n";
@queryvallist = split(/,/, $qvals);

open(OUT, ">$queryfile") || die "cannot open $queryfile for output"; 
select(OUT);
print "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>\n";
print "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n";
print "PREFIX aama: <http://id.oi.uchicago.edu/aama/2013/>\n";
print "PREFIX aamas: <http://id.oi.uchicago.edu/aama/2013/schema/>\n";
print "PREFIX aamag:	 <http://oi.uchicago.edu/aama/2013/graph/>\n";
print "PREFIX $lang:   <http://id.oi.uchicago.edu/aama/2013/$langname/>\n";

print "\n";
# Iterate through @select if want all values in table
print "SELECT ?num ?pers ?gen ?token \n";
print "WHERE\n{\n";
print "\t{\n";
print "\t\tGRAPH aamag:$langname\n\t\t{\n";
print "\t\t\t?s\t$lang:pos\t$lang:Verb . \n";
print "\t\t\t?s\taamas:lang\taama:$Langname .\n";
print "\t\t\t?s\taamas:lang\t?lang .\n";
print "\t\t\t?lang\trdfs:label\t?langLabel . \n";
# Iterate through @select if want all values in table
foreach my $queryval (@queryvallist) 
{
	my $qqueryval = $queryval;
	$qqueryprop =~ s/-//;
	print "\t\t\t?s\t?Q$qqueryval \t$lang:$queryval. \n";
	print " \t\t\t?Q$qqueryval\trdfs:label\t?$qqueryval . \n";
}
print "\t\t\tOPTIONAL { ?s\t$lang:number\t?number . \n";
print "\t\t\t?number\trdfs:label\t?num . }\n";
print "\t\t\t?s\t$lang:person\t?person . \n";
print "\t\t\t?person\trdfs:label\t?pers . \n";
print "\t\t\tOPTIONAL { ?s\t$lang:gender\t?gender . \n";
print "\t\t\t?gender\trdfs:label\t?gen . }\n";
print "\t\t\t?s\t$lang:token\t?token . \n";
print "\t\t}\n";
print "\t}\n";
print "}\n";
# Iterate through @select if want all values in table
print "ORDER BY DESC(?num) ?pers DESC(?gen)\n";
close(OUT); 
#copy($queryfile, "query-temp.rq") or die "Can't copy $queryfile to 'query-temp.rq': $!";