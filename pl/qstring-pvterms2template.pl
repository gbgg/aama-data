#!/usr/local/bin/perl

# rev 11/12/13 adapted from qstring2template.pl, to be run by 
# display-langspropval.sh. It takes as arguments a file name for
# its template output and a qstring with one or more prop=val
# equations, separated by a comma:
#     prop1=val1,prop2=val2, . . .
# Indicating that the query template should return the token and values for all terms from each queried language satisfying the propN=valN equations.
# Alternatively, if the qstring includes a ?propN=valN equation, 
# the query should return all the (relevant) (props and?) vals 
# from each term. [Q: how handle this in printout?] 

# Sample $qstring:
# person=Person2,gender=Fem
# I.e., "Give all the terms, with their values, which are 2f."
# [Alternate $qstring:
# person=Person2,gender=Fem,?prop=prop
# I.e., "Give all the terms in this lang which are 2f."]

use File::Copy;
my ($qstring, $templatefile) = @ARGV;
#print "Query string = $qstring\n";
#print "Template file = $templatefile\n";

my $selection = "";
my ($langname, $Langname, $specifiedprops);
my %specifiedprops;
my @selectionprops;
my $allprops = 0;
my @specifiedprops = split(/,/, $qstring);
foreach my $specifiedprop (@specifiedprops)
{
	my ($prop, $value) = split(/=/, $specifiedprop);
	if ($prop =~ /^\?/) {$allprops = 1;}
	else { $specifiedprops{$prop} = $value; }
} 

#print "selection = $selection\n";

open(OUT, ">$templatefile") || die "cannot open $templatefile for output"; 
select(OUT);
print "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>\n";
print "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n";
print "PREFIX aama: <http://id.oi.uchicago.edu/aama/2013/>\n";
print "PREFIX aamas:	 <http://id.oi.uchicago.edu/aama/2013/schema/>\n";
print "PREFIX aamag:	 <http://oi.uchicago.edu/aama/2013/graph/>\n";

print "\n";
print "SELECT DISTINCT  ?language ?token ?pLabel ?oLabel";
print "\nWHERE \n{\n";
print "GRAPH <http://oi.uchicago.edu/aama/2013/graph/%lang%> {\n";
print "\t?s ?p ?o \;\n";
foreach my $specprop (sort keys %specifiedprops)
{ 
	print "\t<http://id.oi.uchicago.edu/aama/2013/%lang%/$specprop> ";
	print "<http://id.oi.uchicago.edu/aama/2013/%lang%/$specifiedprops{$specprop}> \;\n";
}
print	"<http://id.oi.uchicago.edu/aama/2013/%lang%/token> ?token \;\n";
print "\taamas:lang ?lng \.\n";
print "\t ?lng rdfs:label ?language \.\n";
print "\t?p rdfs:label ?pLabel \.\n";
print "\t?o rdfs:label ?oLabel \.\n";
print "FILTER (?p NOT IN (\n";
my @propkeys = keys %specifiedprops;
for (my $i = 0; $i <= $#propkeys; $i++) 
{ 
	print "\t\t<http://id.oi.uchicago.edu/aama/2013/%lang%/$propkeys[$i]> ";
	if ($i < $#propkeys)
	{
		print ", \n";
	}
}
print "\t\t))\n";
print "\t}\n}\n";
print "ORDER BY ?language ?token ?pLabel ?oLabel \n";
close(OUT); 
#copy($queryfile, "query-temp.rq") or die "Can't copy $queryfile to 'query-temp.rq': $!";
