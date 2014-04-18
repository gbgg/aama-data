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
