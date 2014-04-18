#!/bin/bash
# usage:  display-paradigms.sh data/<lang> qlabel, display-paradigms.sh "data/<lang> data/<lang> . . ." qlabel, display-paradigms.sh "data/*" qlabel

# 04/16/14

# Script to choose, provide arguments for, and run aama-data/bin/ command-line 
# query and display scripts.
# Script first provides series of menus covering classes of scripts, 
# at final choice reads in argument variables and runs selected script.

# Cf. bin/README.md

# example:
#    <aama> $ bin/finite-prop-val-lang.sh data/beja-arteiga 

#echo " 'Non-finite verb' is operationally defined as any form of  a verb that" 
#echo " is marked for a value of tam, and is marked also at least for" 
#echo " person  (optionally also for gender and number). "
#echo
echo " The following are the current categories of query and display scripts:"
echo
echo "     1. Property-Value displays"
echo "     2. Paradigm displays"
echo "     3. List Generation"
echo
echo "Choose a category number  or Ctrl-C to exit"
echo
read -e -p Number: qdnumber
echo

case "$qdnumber" in 
        1)
	echo " Choose among the following prop-val displays:"



	echo "    1. vals-for-prop"
	echo "    2. langs-for-val"
	echo "    3. langs-prop-val"
	echo "    4. terms-with-prop-val"
	echo " "
	echo "Choose a prop-val type number or Ctrl-C to exit"
	echo
	read -e -p Prop-val-number: pvnumber
	echo
	case "$pvnumber" in 
	    1)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		echo "Enter property name"
		read -e -p Property: property
		bin/display-valsforprop.sh $langdomain $property
		;;
	    2)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		echo "Enter value name"
		read -e -p Value: value
		bin/display-langsforval.sh $langdomain $value
		;;
	    3)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		echo "Enter qstring: prop=Val,...prop=?prop,..."
		read -e -p Qstring: qstring
		echo "Enter query label:"
		read -e -p Qlabel: qlabel
		bin/display-langspropval.sh $langdomain $qstring $qlabel
		;;
	    4)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		echo "Enter qstring: prop=Val,...prop=?prop,..."
		read -e -p Qstring: qstring
		echo "Enter query label:"
		read -e -p Qlabel: qlabel
		bin/display-langspropval.sh $langdomain $qstring $qlabel
		prop=""
		echo "Enter \"yes\" if property-name to be displayed with each value "
		read -e -p Prop?[yes/no]: prop
		bin/display-valsforprop.sh $langdomain $qstring $qlabel $prop
		;;
	esac
	;;
    2)
	echo "Display Paradigm for:    "
	echo "    1. Finite Verb"
	echo "    2. Non-finite Verb"
	echo "    3. Pronoun"
	echo "    4. Noun"
	echo " "
	echo "Choose a prop-val type number or Ctrl-C to exit"
	echo
	read -e -p Pdgm-number: pdgmnumber
	echo
	case "$pdgmnumber" in 
	    1)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		echo "Choose Prompt:"
		echo "    \"1\" = Property-Value Table"
		echo "    \"2\" = Paradigm Name"
		read -e -p Prompt= prompt
		if [ "$prompt" = "1" ] ; then
		    bin/display-pdgms-fv-pv.sh $langdomain
		else
		    bin/display-pdgms-fv-pnames.sh $langdomain
		fi
		;;
	    2)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		echo "Choose Prompt:"
		echo "    \"1\" = Property-Value Table"
		echo "    \"2\" = Paradigm Name"
		read -e -p Prompt= prompt
		if [ "$prompt" = "1" ] ; then
		    bin/display-pdgms-nfv-pv.sh $langdomain
		else
		    bin/display-pdgms-nfv-pnames.sh $langdomain
		fi
		;;
	    3)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		echo "Only prompt currently available for pronominal paradigms is:"
		echo "    \"2\" = Paradigm Name"
		read -e -p "Press \"Return\" to continue:" continue
		bin/display-pdgms-pro-pnames.sh $langdomain
		;;
	    4)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		echo "Only prompt currently available for nominal paradigms is:"
		echo "    \"2\" = Paradigm Name"
		read -e -p "Press \"Return\" to continue:" continue
		bin/display-pdgms-noun-pnames.sh $langdomain
		;;
	esac
	;;
    3)
	echo "Generate list of:    "
               echo "1.  Finite-verb properties: pdgm-finite-prop-list.txt for all languages in the triple store."
               echo "2.  Non-finite-verb properties: pdgm-non-finite-prop-list.txt for all languages in the triple store."
               echo "3.  Pronoun properties: pdgm-pro-prop-list.txt for all languages in the triple store."
               echo "4.  Noun properties: pdgm-noun-prop-list.txt for all languages in the triple store."
               echo "5.  Finite-verb property-value combinations pname-vf-list-$language.txt for the argument language."
               echo "6.  Non-finite-verb property-value combinations pname-nvf-list-$language.txt for the argument language."
               echo "7.  Pronoun property-value combinations pname-pro-list-$language.txt for the argument language."
               echo "8.  Noun property-value combinations pname-pro-list-$language.txt for the argument language."
               echo "9.  Four tables (html/tsv) of all lang-prop-val co-occurrences in \<dir>\ with entries: "
               echo "  (1) lang prop: val, val, val, ...   (all the values for each prop in each language)"
               echo "	(2) prop val: lang, lang, lang, ... (all the languages in which a given prop has a given val)"
               echo "	(3) val	prop: lang, lang, lang, ... (all the languages in which a given val is associated with a given prop)"
               echo "	(4) prop lang: val, val, val, ...   (all the values associated with a given prop in a given language)"
	echo " "
	echo "Choose a list type number or Ctrl-C to exit"
	echo
	read -e -p List-type-number: ltnumber
	echo
	case "$ltnumber" in 
	    1)
                bin/generate-prop-list-fv.sh ;;
	    2)
		bin/generate-prop-list-nfv.sh ;;
	    3)
		bin/generate-prop-list-pro.sh ;;
	    4)
		bin/generate-prop-list-noun.sh ;;
	    5)
		echo "Define language domain"
		read -e -p lang-domain: $langdomain
		bin/generate-pnames-fv.sh $langdomain ;;
	    6)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		bin/generate-pnames-nfv.sh $langdomain ;;
	    7)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		bin/generate-pnames-pro.sh $langdomain ;;
	    8)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		bin/generate-pnames-noun.sh $langdomain ;;
	    9)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		bin/generate-lang-prop-val-lists.sh $langdomain ;;
	esac
esac

