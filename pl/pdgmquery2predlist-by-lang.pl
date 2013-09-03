#!/usr/local/bin/perl

# this version of pdgmquery2predlist.pl: is to be run in the documentation 
# aa directory. It is invoked by doc-prop-val-queries-by-lang.sh. It takes  
# each GROUP-query-pvl/vpl/lpv/lp* file (i.e., each SPARQL query tsv 
# output file  of format  pred1 \t pred2 \t pred3 \t pred4) and transforms it  into 
# a txt file in which all instances of the third pred which occur with the first 
# two are gathered into a tab-separated list,  list, of format 
# pred1 \t pred2 \t pred3list. The envisaged values for the preds are: 
# prop \t val \t lang \t langVar, val \t prop \t lang \t langVar, lang \t langVar \t prop \t val,
# and prop \t \t  lang \t langVar (for simple prop list, including token*),
# where lang \t langVar are first combined into a single pred lang-langVar.

# rev 02/22/13
# changed $lang, $langvar to $aamalang

my @queryfiles = <*-query*.tsv>;
my ($group, $txtfile);
foreach my $qfile (@queryfiles)
{
	select STDOUT;
	print "qfile = $qfile\n";
	$group = $qfile;
	$group =~ s/(.*?-).*/\1/;
	print "group=$group\n";
	undef $/;
	my $curpred1pred2;
	my %pred1pred2list;
	open(IN, $qfile) || die "cannot open $qfile for reading";
	while (<IN>)
	{ 
		my $preds = $_;
		$preds =~ s/"//g;
		# $format has the header line of query output, $preds123 has all the data.
		# $txtfile identifies the output file; $langVar identifies the position of the 
		# aama:langVar value
		my ($format, $preds123) = split(/\n/, $preds, 2);
		print "Format= $format\n";
		if ($format =~ /^\?property/)
		{
			$txtfile = $group."-prop-val-langs.txt";
			$lang = "end";
		}elsif ($format =~ /^\?value/)
		{
			$txtfile = $group."val-prop-langs.txt";
			$lang = "end";
		}elsif ($format =~ /^\?lang/)
		{
			$txtfile = $group."lang-prop-vals.txt";
			$lang = "start";
		}elsif ($format =~ /^\?proplabel/)
		{
			$txtfile = $group."prop-langs.txt";
			$lang = "pred2";
		}else
		{
			print "Unexpected file format; examine query files!\n";
			exit;
		}
		print "OUT file = $txtfile\n";
		
# OLD =		
#	?property	?value	?lang	?langVar
#	?proplabel	?lang	?langVar
#	?lang	?langVar	?property	?value
#	?value	?property	?lang	?langVar
# NEW =
#	?property	?value	?lang?langVar
#	?proplabel	?lang?langVar
#	?lang?langVar	?property	?value
#	?value	?property	?lang?langVar

		print "First make associative list:\n";
		# split up the data lines and assign 
		my @preds = split( /\n/, $preds123);
		foreach my $pred (@preds)
		{
			my ($preda, $predb, $predc) = split(/\t/, $pred);
			#print "preda,b,c,b= $preda, $predb, $predc, $predd\n";
			#print "pred1,2,3 = $pred1, $pred2, $pred3\n";
			#print "LANG=&$pred3&\n";
			my ($pred1, $pred2, $pred3);
			my $pred1pred2;
			if ($lang eq "pred2")
			{
				$pred1pred2 = $preda."&";
				$pred3 = $predb;
			}else{
				$pred1pred2 = $preda."&".$predb;
				$pred3 = $predc;
			}
			#print "curprop=$curprop\tprop=$pred1\tval=$pred2\n";
			if ($pred1pred2 eq $curpred1pred2)
			{
					$pred1pred2list{$curpred1pred2} .= $pred3.", ";
					#print "curpred{$curpred1pred2} .= $pred3\n";
			}
			else
			{
				$pred1pred2list{$pred1pred2} .= $pred3.", ";
				#print "pred1pred2{$pred1pred2} .= $pred3\n";
				$curpred1pred2 = $pred1pred2;
			}
		}	
		#exit;
		
		print "Then write it to $txtfile:\n";
		print "Starting output.\n\n";
		open(OUT, ">$txtfile") || die "cannot open $txtfile for output"; 
		select(OUT);
		#my $curprop;
		foreach my $pred1pred2 (sort keys %pred1pred2list)
		{
			my ($pred1, $pred2) = split(/&/, $pred1pred2);
			my $pred3list = $pred1pred2list{$pred1pred2};
			$pred3list =~ s/, $//;
			print $pred1."\t".$pred2."\t".$pred3list."\n";
			#exit;
		}
		#exit;
		close(OUT); 
		
		#exit;
		close(IN); 
	}
}

print "END!\n";