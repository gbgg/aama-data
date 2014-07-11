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

# response=tmp/prop-val-lists/lang-prop-val-list.tsv
my ($propvalfile, $filetag) = @ARGV;
my @outputfiles;
my $textfilelpv = "tmp/prop-val-lists/lang-prop-val-list-$filetag.txt";
push (@outputfiles, $textfilelpv);
my $textfilepvl = "tmp/prop-val-lists/prop-val-lang-list-$filetag.txt";
push (@outputfiles, $textfilepvl);
my $textfilevpl = "tmp/prop-val-lists/val-prop-lang-list-$filetag.txt";
push (@outputfiles, $textfilevpl);
my $textfileplv = "tmp/prop-val-lists/prop-lang-val-list-$filetag.txt";
push (@outputfiles, $textfilepvl);
my $htmlfilelpv = "tmp/prop-val-lists/lang-prop-val-list-$filetag.html";
push (@outputfiles, $htmlfilelpv);
my $htmlfilepvl = "tmp/prop-val-lists/prop-val-lang-list-$filetag.html";
push (@outputfiles, $htmlfilepvl);
my $htmlfilevpl = "tmp/prop-val-lists/val-prop-lang-list-$filetag.html";
push (@outputfiles, $htmlfilepvl);
my $htmlfileplv = "tmp/prop-val-lists/prop-lang-val-list-$filetag.html";
push (@outputfiles, $htmlfileplv);

#undef $/;
# Will eventually make 4 formats for permutations of l, p, v
my ($ll, $lp, $lv,  $lenp, $lenv, $lenl);
my (%lpv, %pvl, %vpl, %plv);
my (%lp, %pv, %vp, %pl);
my (%langcount, %propvcount, %valcount, %proplcount);
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
		if ($lp{$lang} !~ / $prop /)
		{
			$lp{$lang} .= " ".$prop." ";
			$langcount{$lang} += 1;
		}
		if ($pv{$prop} !~ / $val /)
		{
			$pv{$prop} .= " ".$val." ";
			$propvcount{$prop} += 1;
		}
		if ($vp{$val} !~ / $prop /)
		{
			$vp{$val} .= " ".$prop." ";
			$valcount{$val} += 1;
		}
		if ($pl{$prop} !~ / $lang /)
		{
			$pl{$prop} .= " ".$lang." ";
			$proplcount{$prop} += 1;
		}
		my($langprop) = $lang."+".$prop;
		my($propval) = $prop."+".$val;
		my($valprop) = $val."+".$prop;
		my($proplang) = $prop."+".$lang;
		$lpv{$langprop} .= $val.", ";
		$pvl{$propval} .= $lang.", ";
		$vpl{$valprop} .= $lang.", ";
		$plv{$proplang} .= $val.", ";
	}
}
close(IN); 

# print to lpv tsv file (for spreadsheet/Word-table)
open(OUT, ">$textfilelpv") or die "cannot open $textfilelpv for output"; 
select(OUT);
print "LANGUAGE\tPROPERTY\tVALUES\n";
my $currlang = ' ';
foreach my $langprop (sort keys %lpv)
{
	my($lang, $prop) = split(/\+/, $langprop);
	$vals = $lpv{$langprop};
	$vals =~ s/,\s*$//;
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
# print to html table
open(OUT, ">$htmlfilelpv") || die "cannot open $htmlfilelpv for output"; 
select(OUT);
print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
print "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"\n";
print "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n";
print "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n";
print "    <head>\n";
print "        <title>$htmlfilelpv</title>\n";
print "    </head>\n";
print "    <body>\n";
print "        <h1>$htmlfilelpv</h1>\n";
print "            <table border=\"1\" cellspacing=\"0\" cellpadding=\"3\"\n";
print "                <thead>\n";
print "                    <tr>\n";
print "                        <th align=\"left\">Language</th>\n";
print "                        <th align=\"left\">Property</th>\n";
print "                        <th align=\"left\">Values</th>\n";
print "                    </tr>\n";
print "                </thead>\n";
print "                <tbody>\n";
foreach my $langprop (sort keys %lpv)
{
	print "<tr>\n";
	my($lang, $prop) = split(/\+/, $langprop);
	$vals = $lpv{$langprop};
	$vals =~ s/,\s*$//;
	if ($lang ne $currlang)
	{
		$currlang = $lang;
		print "<td align=\"left\" valign=\"top\" rowspan=\"$langcount{$lang}\">$lang</td>\n";
		print "<td>$prop</td>\n";
		print "<td>$vals</td>\n";
	}else{
		print "<td>$prop</td>\n";
		print "<td>$vals</td>\n";
	}
	print "</tr>\n";
}
print "                </tbody>\n";
print "            </table>\n";
print "    </body>\n";
print "</html>\n";
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
	$langs =~ s/,\s*$//;
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
# print to html table
open(OUT, ">$htmlfilepvl") || die "cannot open $htmlfilepvl for output"; 
select(OUT);
print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
print "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"\n";
print "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n";
print "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n";
print "    <head>\n";
print "        <title>$htmlfilepvl</title>\n";
print "    </head>\n";
print "    <body>\n";
print "        <h1>$htmlfilepvl</h1>\n";
print "            <table border=\"1\" cellspacing=\"0\" cellpadding=\"3\"\n";
print "                <thead>\n";
print "                    <tr>\n";
print "                        <th align=\"left\">Property</th>\n";
print "                        <th align=\"left\">Value</th>\n";
print "                        <th align=\"left\">Languages</th>\n";
print "                    </tr>\n";
print "                </thead>\n";
print "                <tbody>\n";
foreach my $propval (sort keys %pvl)
{
	print "<tr>\n";
	my($prop, $val) = split(/\+/, $propval);
	$langs = $pvl{$propval};
	$langs =~ s/,\s*$//;
	if ($prop ne $currprop)
	{
		$currprop = $prop;
		print "<td align=\"left\" valign=\"top\" rowspan=\"$propvcount{$prop}\">$prop</td>\n";
		print "<td>$val</td>\n";
		print "<td>$langs</td>\n";
	}else{
		print "<td>$val</td>\n";
		print "<td>$langs</td>\n";
	}
	print "</tr>\n";
}
print "                </tbody>\n";
print "            </table>\n";
print "    </body>\n";
print "</html>\n";
close(OUT); 


# Make format and print to vpl table
open(OUT, ">$textfilevpl") or die "cannot open $textfilevpl for output"; 
select(OUT);
print "VALUE\tPROPERTY\tLANGUAGES\n";
my $currval = ' ';
foreach my $valprop (sort keys %vpl)
{
	my($val, $prop) = split(/\+/, $valprop);
	$langs = $vpl{$valprop};
	$langs =~ s/,\s*$//;
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
# print to html table
open(OUT, ">$htmlfilevpl") || die "cannot open $htmlfilevpl for output"; 
select(OUT);
print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
print "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"\n";
print "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n";
print "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n";
print "    <head>\n";
print "        <title>$htmlfilevpl</title>\n";
print "    </head>\n";
print "    <body>\n";
print "        <h1>$htmlfilevpl</h1>\n";
print "            <table border=\"1\" cellspacing=\"0\" cellpadding=\"3\"\n";
print "                <thead>\n";
print "                    <tr>\n";
print "                        <th align=\"left\">Value</th>\n";
print "                        <th align=\"left\">Property</th>\n";
print "                        <th align=\"left\">Languages</th>\n";
print "                    </tr>\n";
print "                </thead>\n";
print "                <tbody>\n";
foreach my $valprop (sort keys %vpl)
{
	print "<tr>\n";
	my($val, $prop) = split(/\+/, $valprop);
	$langs = $vpl{$valprop};
	$langs =~ s/,\s*$//;
	if ($val ne $currval)
	{
		$currval = $val;
		print "<td align=\"left\" valign=\"top\" rowspan=\"$valcount{$val}\">$val</td>\n";
		print "<td>$prop</td>\n";
		print "<td>$langs</td>\n";
	}else{
		print "<td>$prop</td>\n";
		print "<td>$langs</td>\n";
	}
	print "</tr>\n";
}
print "                </tbody>\n";
print "            </table>\n";
print "    </body>\n";
print "</html>\n";
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
	$vals =~ s/,\s*$//;
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
# print to html table
open(OUT, ">$htmlfileplv") || die "cannot open $htmlfileplv for output"; 
select(OUT);
print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
print "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"\n";
print "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n";
print "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n";
print "    <head>\n";
print "        <title>$htmlfileplv</title>\n";
print "    </head>\n";
print "    <body>\n";
print "        <h1>$htmlfileplv</h1>\n";
print "            <table border=\"1\" cellspacing=\"0\" cellpadding=\"3\"\n";
print "                <thead>\n";
print "                    <tr>\n";
print "                        <th align=\"left\">Property</th>\n";
print "                        <th align=\"left\">Language</th>\n";
print "                        <th align=\"left\">Values</th>\n";
print "                    </tr>\n";
print "                </thead>\n";
print "                <tbody>\n";
foreach my $proplang (sort keys %plv)
{
	print "<tr>\n";
	my($prop, $lang) = split(/\+/, $proplang);
	$vals = $plv{$proplang};
	$vals =~ s/,\s*$//;
	if ($prop ne $currprop)
	{
		$currprop = $prop;
		print "<td align=\"left\" valign=\"top\" rowspan=\"$proplcount{$prop}\">$prop</td>\n";
		print "<td>$lang</td>\n";
		print "<td>$vals</td>\n";
	}else{
		print "<td>$lang</td>\n";
		print "<td>$vals</td>\n";
	}
	print "</tr>\n";
}
print "                </tbody>\n";
print "            </table>\n";
print "    </body>\n";
print "</html>\n";
close(OUT); 

select STDOUT;

print "\nThe following output files have been produced:\n";
foreach my $outputfile (@outputfiles)
{
    print "\t$outputfile\n";
}


