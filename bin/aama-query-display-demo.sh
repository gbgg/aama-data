#!/bin/bash
# usage:  display-paradigms.sh data/<lang> qlabel, display-paradigms.sh "data/<lang> data/<lang> . . ." qlabel, display-paradigms.sh "data/*" qlabel

# 04/16/14

# Script to choose, provide arguments for, and run aama-data/bin/ command-line 
# query and display scripts.
# Script first provides series of menus covering classes of scripts, 
# at final choice reads in argument variables and runs selected script.

# Cf. bin/README.md

echo
echo "========================================================================"
echo "QUERY AND DISPLAY DEMO "
echo "========================================================================"
echo " This is a provisional menu-driven command-line app for  cycling"
echo " through the 'display-' and 'generate-' shell scripts to demonstrate "
echo " different kinds of  query strings, their transformation into SPARQL  "
echo " queries, and a tabular display of the resulting response."
echo 
echo " For a general overview and instructions see bin/README.md,"
echo " and the documentation of the individual scripts."
echo " NB1: Script presupposes that fuseki has been launched by bin/fuseki.sh. "
echo " NB2: In response to the 'Define language domain' prompt:"
echo "     (1) data/LANG will yield the relevant information for LANG; "
echo "     (2) data/LANG1,data/LANG2,data/LANG3, . . . [comma-separated!] "
echo "         the info for the set of languages LANG1, LANG2, LANG3 . . .; "
echo "     (3) \"data/*\" [in quotes!] the info for all languages in the datastore. "
echo "======================================================================="
echo
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
	echo
	echo "    1. Display all values for a given property in a language "
        echo "       or set of languages"
	echo "    2. Display all languages which have a given value, and "
	echo "       the property of which it is a value"
	echo "    3. List languages in which a set of one or more prop=val "
	echo "       equivalences (co)-occur, specified in a comma-separated "
	echo "       prop=val 'qstring'; 'qlabel' is used to identify the "
	echo "       query-file and output-tsv file. ['qstring' can also contain"
	echo "       one or more prop=?val equations, indicating that the query "
	echo "       should return the values from the props in question]"
	echo "    4. Display for each language all terms having the comma-separated"
	echo "       prop=val combination specified in the command line; qlabel "
	echo "       is used to identify the query-file and output-tsv file; "
	echo "       optional'yes' for 'prop' argument specifies that the "
	echo "       property-name will be given with each value (otherwise, "
	echo "       only value-names are given). "
	echo "       [NB: Script can generate very large output!]"
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
		bin/display-valsforprop.sh $langdomain $property menu
		;;
	    2)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		echo "Enter value name"
		read -e -p Value: value
		bin/display-langsforval.sh $langdomain $value menu
		;;
	    3)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		echo "Enter qstring: prop=Val,...prop=?prop,..."
		read -e -p Qstring: qstring
		echo "Enter query label:"
		read -e -p Qlabel: qlabel
		bin/display-langspropval.sh $langdomain $qstring $qlabel menu
		;;
	    4)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		echo "Enter qstring: prop=Val,...prop=?prop,..."
		read -e -p Qstring: qstring
		echo "Enter query label:"
		read -e -p Qlabel: qlabel
		bin/display-langspropval.sh $langdomain $qstring $qlabel menu
		prop=""
		echo "Enter \"yes\" if property-name to be displayed with each value "
		read -e -p Prop?[yes/no]: prop
		bin/display-valsforprop.sh $langdomain $qstring $qlabel $prop menu
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
		    bin/display-pdgms-fv-pv.sh $langdomain menu
		else
		    bin/display-pdgms-fv-pnames.sh $langdomain menu
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
		    bin/display-pdgms-nfv-pv.sh $langdomain menu
		else
		    bin/display-pdgms-nfv-pnames.sh $langdomain menu
		fi
		;;
	    3)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		echo "Only prompt currently available for pronominal paradigms is:"
		echo "    \"2\" = Paradigm Name"
		read -e -p "Press \"Return\" to continue:" continue
		bin/display-pdgms-pro-pnames.sh $langdomain menu
		;;
	    4)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		echo "Only prompt currently available for nominal paradigms is:"
		echo "    \"2\" = Paradigm Name"
		read -e -p "Press \"Return\" to continue:" continue
		bin/display-pdgms-noun-pnames.sh $langdomain menu
		;;
	esac
	;;
    3)
	echo "Generate list of:    "
        echo "1.  Finite-verb properties: pdgm-finite-prop-list.txt "
	echo "        (for all languages in the triple store)"
        echo "2.  Non-finite-verb properties: pdgm-non-finite-prop-list.txt"
	echo "        (for all languages in the triple store)"
        echo "3.  Pronoun properties: pdgm-pro-prop-list.txt "
	echo "        (for all languages in the triple store)"
        echo "4.  Noun properties: pdgm-noun-prop-list.txt "
	echo "        (for all languages in the triple store)"
        echo "5.  Finite-verb 'pdgm names' (i.e. distinctive prop combinations): pname-vf-list-$language.txt "
	echo "        (for the argument language)"
        echo "6.  Non-finite-verb 'pdgm names': pname-nvf-list-$language.txt "
	echo "        (for the argument language)"
        echo "7.  Pronoun 'pdgm names': pname-pro-list-$language.txt "
	echo "        (for the argument language)"
        echo "8.  Noun 'pdgm names': pname-pro-list-$language.txt "
	echo "        (for the argument language)"
        echo "9.  All lang-prop-val co-occurrences in \<dir>\,"
	echo "    four tables (html/tsv) of with entries: "
        echo "    (1) lang prop: val, val, val, ...   "
	echo "        (all the vals for each prop in each lang)"
        echo "	  (2) prop val: lang, lang, lang, ... "
	echo "        (all the langs in which a given prop has a given val)"
        echo "	  (3) val prop: lang, lang, lang, ... "
	echo "        (all the langs in which a given val is associated with a given prop)"
        echo "	  (4) prop lang: val, val, val, ...  "
	echo "        (all the vals associated with a given prop in a given lang)"
	echo " "
	echo "Choose a list type number or Ctrl-C to exit"
	echo
	read -e -p List-type-number: ltnumber
	echo
	case "$ltnumber" in 
	    1)
                bin/generate-prop-list-fv.sh menu ;;
	    2)
		bin/generate-prop-list-nfv.sh menu ;;
	    3)
		bin/generate-prop-list-pro.sh menu ;;
	    4)
		bin/generate-prop-list-noun.sh menu ;;
	    5)
		echo "Define language domain"
		read -e -p lang-domain: $langdomain
		bin/generate-pnames-fv.sh $langdomain ;;
	    6)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		bin/generate-pnames-nfv.sh $langdomain menu ;;
	    7)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		bin/generate-pnames-pro.sh $langdomain menu ;;
	    8)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		bin/generate-pnames-noun.sh $langdomain menu ;;
	    9)
		echo "Define language domain"
		read -e -p lang-domain: langdomain
		bin/generate-lang-prop-val-lists.sh $langdomain menu ;;
	esac
esac

