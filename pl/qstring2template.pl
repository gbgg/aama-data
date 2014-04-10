#!/usr/local/bin/perl

# rev 11/11/13 adapted from qstring2query.pl, to be run by 
# display-langspropval.sh. It takes as arguments a file name for
# its template output and a qstring with one or more prop=val
# equations, separated by a comma:
#     prop1=val1,prop2=val2, . . .
# Indicating that the query template should return all terms from each
# queried language satisfying the propN=valN equations.
# It can also contain either one or more prop=?val equations:
#     prop1=?val1, prop2=?val2, . . .
# indicating that the query should return the values from the 
# props in question.
# Alternatively, if the qstring includes a ?propN=valN equation, 
# the query should return all the (relevant) (props and?) vals 
# from each term. [Q: how handle this in printout?] 

# Sample $qstring:
# person=Person2,gender=Fem,pos=?pos,number=?number
# I.e., "Is there a 2f in this lang, and if so, in what pos and what num?"
# Alternate $qstring:
# person=Person2,gender=Fem,?prop=prop
# I.e., "Give all the terms in this lang which are 2f."

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
	elsif ($value =~ /^\?/) { push(@selectionprops, $prop); }
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
# Iterate through @selectprops if want all values in table
print "SELECT DISTINCT  ?language ";
foreach my $selectionprop (@selectionprops)
{
	print "?".$selectionprop."Label ";
}
print "\nWHERE \n{\n";
print "GRAPH <http://oi.uchicago.edu/aama/2013/graph/%lang%> {\n";
print "\t?s ?p ?o \;\n";
foreach my $specprop (sort keys %specifiedprops)
{ 
	print "\t<http://id.oi.uchicago.edu/aama/2013/%lang%/$specprop> ";
	print "<http://id.oi.uchicago.edu/aama/2013/%lang%/$specifiedprops{$specprop}> \;\n";
}
foreach my $selectionprop (@selectionprops)
{
	print "\t<http://id.oi.uchicago.edu/aama/2013/%lang%/$selectionprop> ?$selectionprop \;\n";
}
print "\taamas:lang ?lng \.\n";
print "\t?lng rdfs:label ?language \.\n";
foreach my $selectionprop (@selectionprops)
{
	print "\t?$selectionprop rdfs:label ?".$selectionprop."Label.\n";
}
print "\t}\n}\n";
print "ORDER BY ?language ";
foreach my $selectionprop (@selectionprops)
{
	print "?".$selectionprop."Label ";
}
print "\n";
close(OUT); 
#copy($queryfile, "query-temp.rq") or die "Can't copy $queryfile to 'query-temp.rq': $!";
