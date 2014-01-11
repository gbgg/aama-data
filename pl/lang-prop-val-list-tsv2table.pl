#!/usr/local/bin/perl

# 01/03/14: adapted from verb-propvalstsv2table.pl, 
# Invoked by generate-lang-prop-val-lists.sh

# Makes 4 hashes from input tsv: %lpv, %pvl, %vpl, %plv 
# and prints them to files:
#		lang	prop: v, v, v, ...
#		prop val: l, l, l, ...
#		val	prop: l, l, l, ...
#		prop	lang: v, v, v, ...
# to be used in development of nomenclature/ontology

# response=tmp/prop-val/lang-prop-val-list.tsv
my ($propvalfile) = @ARGV;
my $textfilelpv = "tmp/prop-val/lang-prop-val-list.txt";
my $textfilepvl = "tmp/prop-val/prop-val-lang-list.txt";
my $textfilevpl = "tmp/prop-val/val-prop-lang-list.txt";
my $textfileplv = "tmp/prop-val/prop-lang-val-list.txt";

#undef $/;
# Will eventually make 4 formats for permutations of l, p, v
my ($ll, $lp, $lv,  $lenp, $lenv, $lenl);
my (%lpv, %pvl, %vpl, %plv);

open(IN, $propvalfile) or die "cannot open $propvalfile for reading";
while (<IN>)
{ 
	my $data = $_ ;
	$data =~ s/"//g;
	$data =~ s/⊤/ /g;
	$data =~ s/\n//g;
	unless ($data =~ /^\?/)
	{
		my ($lang, $prop, $val)  = split(/\t/, $data);
		# record %lp, %pv, %vp, %pl for table rowspan
		if ($lp{$lang} !~ /$prop/)
		{
			$lp{$lang} .= $prop." ";
			$lpcount{$lang} += 1;
		}
		my($langprop) = $lang."+".$prop;
		my($propval) = $prop."+".$val;
		my($valprop) = $val."+".$prop;
		my($proplang) = $prop."+".$lang;
		$lpv{$langprop} .= $val." ";
		$pvl{$propval} .= $lang." ";
		$vpl{$valprop} .= $lang." ";
		$plv{$proplang} .= $val." ";
	}
}
close(IN); 

# Make format and print to lpv table [HERE 1/4-6]
open(OUT, ">$textfilelpv") or die "cannot open $textfilelpv for output"; 
select(OUT);
print "LANGUAGE\tPROPERTY\tVALUES\n";
my $currlang = ' ';
foreach my $langprop (sort keys %lpv)
{
	my($lang, $prop) = split(/\+/, $langprop);
	$vals = $lpv{$langprop};
	if ($lang ne $currlang)
	{
		$currlang = $lang;
		print "$lang\t$prop\t$vals\n";
	}else{
		print " \t$prop\t$vals\n";
	}
}
print "\n";
close(OUT);

# Make format and print to pvl table [HERE 1/4-6]
open(OUT, ">$textfilepvl") or die "cannot open $textfilepvl for output"; 
select(OUT);
print "PROPERTY\tVALUE\tLANGUAGES\n";
my $currprop = ' ';
foreach my $propval (sort keys %pvl)
{
	($prop, $val) = split(/\+/, $propval);
	$langs = $pvl{$propval};
	if ($prop ne $currprop)
	{
		$currprop = $prop;
		print "$prop\t$val\t$langs\n";
	}else{
		print " \t$val\t$langs\n";
	}
}
print "\n";
close(OUT);

# Make format and print to vpl table [HERE 1/4-6]
open(OUT, ">$textfilevpl") or die "cannot open $textfilevpl for output"; 
select(OUT);
print "VALUE\tPROPERTY\tLANGUAGES\n";
my $currval = ' ';
foreach my $valprop (sort keys %vpl)
{
	my($val, $prop) = split(/\+/, $valprop);
	$langs = $vpl{$valprop};
	if ($val ne $currval)
	{
		$currval = $val;
		print "$val\t$prop\t$langs\n";
	}else{
		print " \t$prop\t$langs\n";
	}
}
print "\n";
close(OUT);

# Make format and print to plv table [HERE 1/4-6]
open(OUT, ">$textfileplv") or die "cannot open $textfileplv for output"; 
select(OUT);
print "PROPERTY\tLANGUAGE\tVALUES\n";
my $currlang = ' ';
foreach my $proplang (sort keys %plv)
{
	my($prop, $lang) = split(/\+/, $proplang);
	$vals = $plv{$proplang};
	if ($prop ne $currprop)
	{
		$currprop = $prop;
		print "$prop\t$lang\t$vals\n";
	}else{
		print " \t$lang\t$vals\n";
	}
}
print "\n";
close(OUT);
