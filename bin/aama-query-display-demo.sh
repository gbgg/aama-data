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
echo " through the (currently 19) 'display-' and 'generate-' shell scripts  "
echo " to demonstrate different kinds of query strings, their transformation into  "
echo " SPARQL queries, and a tabular display of the resulting response."
echo 
echo " For a quick walk-through of query-response possibilities, go systematically"
echo " through menu/sub-menu categories, and take default values [ENTER] when offered. "
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
read -e -p "Menu Item: " qdnumber
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
	echo "Choose a prop-val display  type number or Ctrl-C to exit"
	echo
	read -e -p "Prop-val Display: " pvnumber
	echo

	case "$pvnumber" in 
	    1)
		ldomain=\"data/beja-*\"
		echo "Define language domain"
		read -e -p "lang-domain (default $ldomain) : " input
		langdomain=${input:-$ldomain}
		pname=tam
		echo "Enter property name"
		read -e -p "Property (default $pname) : " input
		property=${input:-$pname}
		bin/display-valsforprop.sh $langdomain $property menu
		;;
	    2)
		ldomain=\"data/*\"
		echo "Define language domain"
		read -e -p "lang-domain (default $ldomain) : " input
		langdomain=${input:-$ldomain}
		vname=Aorist
		echo "Enter value name"
		read -e -p "Value (default $vname) : " input
		value=${input:-$vname}
		bin/display-langsforval.sh $langdomain $value menu
		;;
	    3)
		ldomain=\"data/*\"
		echo "Define language domain"
		read -e -p "lang-domain (default $ldomain) : " input
		langdomain=${input:-$ldomain}
		qstr="person=Person2,gender=Fem,pos=?pos,number=?number"
		echo "Enter qstring: prop=Val,...prop=?prop,..."
		read -e -p "Qstring (default $qstr) : " input
		qstring=${input:-$qstr}
		qlbl=langs-pvtrial
		echo "Enter query label"
		read -e -p "Qlabel (default $qlbl) : " input
		qlabel=${input:-$qlbl}
		bin/display-langspropval.sh $langdomain $qstring $qlabel menu
		;;
	    4)
		ldomain=data/beja-arteiga,data/beja-atmaan
		echo "Define language domain"
		read -e -p "lang-domain (default $ldomain) : " input
		langdomain=${input:-$ldomain}
		qstr="person=Person2,gender=Fem"
		echo "Enter qstring: prop=Val,...prop=?prop,..."
		read -e -p "Qstring (default $qstr) : " input
		qstring=${input:-$qstr}
		qlbl=langpvterms-trial
		echo "Enter query label"
		read -e -p "Qlabel (default $qlbl) : " input
		qlabel=${input:-$qlbl}
		prop=yes
		echo "Enter \"yes\" if property-name to be displayed with each value "
		read -e -p "Prop?[yes/no] (default $prop) : " input
		value=${input:-$prop}
		bin/display-langvterms.sh $langdomain $qstring $qlabel $prop menu
		;;
	esac
	;;
    2)
	echo "Display Paradigm for:    "
	echo "    1. Finite Verb: Select pdgm properties from prop-val table"
	echo "    2. Finite Verb: Select pdgm from 'name-list'"
	echo "    3. Non-finite Verb: Select pdgm properties from prop-val table"
	echo "    4. Non-finite Verb: Select pdgm from 'name-list'"
	echo "    5. Pronoun (from 'name-list')"
	echo "    6. Noun (from 'name-list')"
	echo "       [NB: At present, there are no noun paradigms noted for most languages in this archive!]"
	echo " "
	echo "Choose a prop-val type number or Ctrl-C to exit"
	echo
	read -e -p "Display-number: " pdgmnumber
	echo
	case "$pdgmnumber" in 
	    1)
		ldomain=data/beja-arteiga,data/oromo
		echo "Define language domain"
		read -e -p "lang-domain (default $ldomain) : " input
		langdomain=${input:-$ldomain}
		bin/display-pdgms-fv-pv.sh $langdomain menu
		;;
	    2)
		ldomain=data/beja-arteiga
		echo "Define language domain"
		read -e -p "lang-domain (default $ldomain) : " input
		langdomain=${input:-$ldomain}
		bin/display-pdgms-fv-pnames.sh $langdomain menu
		;;
	    3)
		ldomain=data/beja-arteiga
		echo "Define language domain"
		read -e -p "lang-domain (default $ldomain) : " input
		langdomain=${input:-$ldomain}
		bin/display-pdgms-nfv-pv.sh $langdomain menu
		;;
	    4)
		ldomain=data/beja-arteiga
		echo "Define language domain"
		read -e -p "lang-domain (default $ldomain) : " input
		langdomain=${input:-$ldomain}
		bin/display-pdgms-nfv-pnames.sh $langdomain menu
		;;
	    5)
		ldomain=data/beja-arteiga
		echo "Define language domain"
		read -e -p "lang-domain (default $ldomain) : " input
		langdomain=${input:-$ldomain}
		bin/display-pdgms-pro-pnames.sh $langdomain menu
		;;
	    6)
		ldomain=data/beja-arteiga
		echo "Define language domain"
		read -e -p "lang-domain (default $ldomain) : " input
		langdomain=${input:-$ldomain}
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
        echo "5.  Finite-verb 'pdgm names' (i.e. distinctive prop combinations): pname-vf-list-LANG.txt "
	echo "        (for the argument language)"
        echo "6.  Non-finite-verb 'pdgm names': pname-nvf-list-LANG.txt "
	echo "        (for the argument language)"
        echo "7.  Pronoun 'pdgm names': pname-pro-list-LANG.txt "
	echo "        (for the argument language)"
        echo "8.  Noun 'pdgm names': pname-noun-list-LANG.txt "
	echo "        (for the argument language)"
	echo "        [NB: At present, noun paradigms are noted only exceptionally in this archive!]"
        echo "9.  All lang-prop-val co-occurrences in <dir>,"
	echo "    four tables (txt/html) with entries: "
        echo "        (1) lang prop: val, val, val, ...   "
	echo "            (all the vals for each prop in each lang)"
        echo "        (2) prop val: lang, lang, lang, ... "
	echo "            (all the langs in which a given prop has a given val)"
        echo "        (3) val prop: lang, lang, lang, ... "
	echo "            (all the langs in which a given val is associated with a given prop)"
        echo "        (4) prop lang: val, val, val, ...  "
	echo "            (all the vals associated with a given prop in a given lang)"
	echo " "
	echo "Choose a list type number or Ctrl-C to exit"
	echo
	read -e -p "List-type: " ltnumber
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
		ldomain=data/beja-arteiga
		echo "Define language domain"
		read -e -p "lang-domain (default $ldomain) : " input
		langdomain=${input:-$ldomain}
		bin/generate-pnames-fv.sh $langdomain menu ;;
	    6)
		ldomain=data/beja-arteiga
		echo "Define language domain"
		read -e -p "lang-domain (default $ldomain) : " input
		langdomain=${input:-$ldomain}
		bin/generate-pnames-nfv.sh $langdomain menu ;;
	    7)
		ldomain=data/beja-arteiga
		echo "Define language domain"
		read -e -p "lang-domain (default $ldomain) : " input
		langdomain=${input:-$ldomain}
		bin/generate-pnames-pro.sh $langdomain menu ;;
	    8)
		ldomain=data/beja-arteiga
		echo "Define language domain"
		read -e -p "lang-domain (default $ldomain) : " input
		langdomain=${input:-$ldomain}
		bin/generate-pnames-noun.sh $langdomain menu ;;
	    9)
		ldomain=data/beja-arteiga
		echo "Define language domain"
		read -e -p "lang-domain (default $ldomain) : " input
		langdomain=${input:-$ldomain}
		ftag=$langdomain
		echo "Provide File Tag"
		read -e -p "File Tag (default $ftag) : " input
		filetag=${input:-$ftag}
		bin/generate-lang-prop-val-lists.sh $langdomain $filetag menu ;;
	esac
esac

