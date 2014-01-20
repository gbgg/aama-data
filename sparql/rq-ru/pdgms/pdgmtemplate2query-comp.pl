#!/usr/local/bin/perl

# rev 02/10/13

# This is a version of pdgmtemplate2query.pl, and is to be run in the 
# tools/rq-ru/pdgm-def directory. It constructs a SPARQL query 
# based on a bi-partite argumet string joined by "^", ARG1^ARG2.
# each ARG has the structure (cf. pod below): 
# 1) a language name whose pdgm-defining properties it looks up in 
# pdgm-finite-props.txt;
# 2) a value specification for one or more props in a string of the form 
#  "prop=val:prop=val:..." 
# The script is invoked by rq-make-query-display.sh.  

# rev 02/22/13
# changed $lang, $langvar to $aamalang

=begin comment
#  Asking for two tenses from two languages -- first try (beja aorist with oromo past)
# display-pdgm-compare-1.rq

SELECT ?langName ?langVariety ?tense ?pol ?num ?pers ?gen ?token
WHERE
{
   ?s aama:lang ?lang .
   ?lang rdfs:label ?langName .
   ?s aama:tam ?tam .
   ?tam rdfs:label ?tense .
   ?s aama:polarity ?polarity .
   ?polarity rdfs:label ?pol .
   ?s aama:number ?number .
   ?number rdfs:label ?num .
	?s aama:person ?person .
	?person rdfs:label ?pers .
	?s aama:gender ?gender .
	?gender rdfs:label ?gen .
	?s aama:token ?token .

	{
	   ?s aama:tam aama:aorist .
	   ?s aama:lang aama:beja .
	   ?s aama:langVar aama:arteiga .
		?s aama:langVar ?langVar .
		?langVar rdfs:label ?langVariety .
		?s aama:polarity aama:affirmative .
		?s aama:conjClass aama:prefix .
		?s aama:rootClass aama:CCC .
	}
	
	UNION
	
	{
	   ?s aama:tam aama:past .
	   ?s aama:lang aama:oromo .
       ?s aama:polarity aama:affirmative .
		?s aama:dervStem aama:base .
	}
	
}
ORDER BY  ?langName   DESC(?num) ?pers DESC(?gen)

beja-arteiga+conjClass=prefix:tam=aorist:polarity=affirmative:rootClass=CCC^
oromo+dervStem=base:tam=past:polarity=affirmative

=end comment
=cut
use File::Copy;

#my ($langname, $specifiedprops) = @ARGV;
my ($txtfile) = "pdgm-finite-props.txt";
my $queryfile = "";
# Going with maximum @queryproplist for the moment, perhaps only
# necessary if prop is in language queryprops, and in selection list, but 
# not specified in language's spedifiedprops.
my @queryproplist;

my ($qstring) = @ARGV;
my ($qlang1, $qlang2) = split(/\^/, $qstring);
print "QStrings = $qlang1, $qlang2\n";
my (%specifiedprops1, %specifiedprops2);

# Language 1
my ($langname, $specifiedprops) = split(/\+/, $qlang1);
$queryfile .= $langname;
my $aamalang  = "";
$aamalang = $langname;
$specifiedprops1{"lang"} = $aamalang;

print "Lang1 = $aamalang\n";
my @specifiedprops1 = split(/:/, $specifiedprops);
foreach my $specifiedprop (@specifiedprops1)
{
	my ($prop, $value) = split(/=/, $specifiedprop);
	$specifiedprops1{$prop} = $value;
	#$queryfile .= "-".$value;
}

undef $/;
my $queryprops;
open(IN, $txtfile) || die "cannot open $txtfile for reading";
while (<IN>)
{ 
	my $pdgmprops = $_;
	my ($first, $props) = split("$langname : \"", $pdgmprops);
	($queryprops, my $last) = split(/"\n/, $props, 2);
	print "Queryprops1 = $queryprops\n";
}

my @select = split(/,\s* /, $queryprops);
my $selection1 = "";
foreach my $queryprop (@select)
 {  
	#if ($specifiedprops !~ /$queryprop.":"/)
	if ( $specifiedprops{$queryprop} !~ /\w/)
	{
		$selection1 .= $queryprop." "; 
		push( @queryproplist, $queryprop );
	}
}

# Language 2
my ($langname, $specifiedprops) = split(/\+/, $qlang2);
$queryfile .= "-".$langname;
my $aamalang  = "";
$aamalang = $langname;
$specifiedprops2{"lang"} = $aamalang;

print "Lang2 = $aamalang=\n";
my @specifiedprops2 = split(/:/, $specifiedprops);
foreach my $specifiedprop (@specifiedprops2)
{
	my ($prop, $value) = split(/=/, $specifiedprop);
	$specifiedprops2{$prop} = $value;
	#$queryfile .= "-".$value;
}
undef $/;
my $queryprops;
open(IN, $txtfile) || die "cannot open $txtfile for reading";
while (<IN>)
{ 
	my $pdgmprops = $_;
	my ($first, $props) = split("$langname : \"", $pdgmprops);
	($queryprops, my $last) = split(/"\n/, $props, 2);
	print "Queryprops2 = $queryprops\n\n";
}
my @select = split(/,\s* /, $queryprops);
my $selection2 = "";
foreach my $queryprop (@select)
 {  
	#if ($specifiedprops !~ /$queryprop.":"/)
	if ( $specifiedprops{$queryprop} !~ /\w/)
	{
		$selection2 .= $queryprop." ";
		unless ($queryprop ~~ @queryproplist)
		{
			push( @queryproplist, $queryprop );
		}
	}
}

$queryfile .= "-query.rq";
print "Query File = $queryfile\n";

# Derive $selection string by intersecting $selection1 and $selection2;
# For maximum $selection string, combine strings.
print "Selection1 =$selection1\n";
print "Selection2 =$selection2\n";
my $selection = "";
my @selection = split(/ /, $selection1);
foreach my $sel (@selection)
{
	if ($selection2 =~ /$sel/) { $selection .= "?".$sel." ";}
}
print "Selection = $selection\n";

print "Specifiedprops1 =\n";
foreach my $specifiedprop (sort keys %specifiedprops1)
{
	print "\t$specifiedprop\t$specifiedprops1{$specifiedprop} . \n";
}
print "Specifiedprops2 =\n";
foreach my $specifiedprop (sort keys %specifiedprops2)
{
	print "\t$specifiedprop\t$specifiedprops2{$specifiedprop} . \n";
}

print "Queryprops =\n";
foreach my $queryprop (@queryproplist) 
{
	print "\t$queryprop";
}
print "\n";

open(OUT, ">$queryfile") || die "cannot open $queryfile for output"; 
select(OUT);
print "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>\n";
print "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n";
print "PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>\n";
print "\n";
# Iterate through @select if want all values in table
print "SELECT ?langName  $selection ?num ?pers ?gen ?token\n";
print "WHERE\n{\n";
print "\t?s\taama:pos\taama:verb . \n";
print "\t?s\taama:lang\t?lang .\n";
print "\t?lang rdfs:label ?langName . \n";
# Iterate through @select if want all values in table
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
print "\t{\n";
foreach my $specifiedprop (sort keys %specifiedprops1)
{
	print "\t\t?s\taama:$specifiedprop\taama:$specifiedprops1{$specifiedprop} . \n";
}
print "\t}\n";
print "\tUNION\n";
print "\t{\n";
foreach my $specifiedprop (sort keys %specifiedprops2)
{
	print "\t\t?s\taama:$specifiedprop\taama:$specifiedprops2{$specifiedprop} . \n";
}
print "\t}\n";
print "}\n";

# Iterate through @select if want all values in table
print "ORDER BY ?langName $selection  DESC(?num) ?pers DESC(?gen)\n";
close(OUT); 
copy($queryfile, "query-temp.rq") or die "Can't copy $queryfile to 'query-temp.rq': $!";