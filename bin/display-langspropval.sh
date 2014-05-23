#!/bin/sh

# usage: display-langspropval.sh <dir> qstring qlabel
# rev 11/08/13

# The script is designed to list languages in which a set of one or more prop=val equivalences (co)-occur. Here only the language names where set occurs will be displayed. The more detailed output of display-langvterms.sh displays in addition all the terms in each language where the set occurs. 

# The script first uses qlabel to name the response (tsv) and template files, and calls qstring2template.pl to form the query template from a qstring with one or more prop=val
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
# The template is then applied to each language in the data/[LANG] set, and the response added to the response file.
# The final response file is formatted into  a display by propvaltsv2table.pl.

# example:
# bin/display-langspropval.sh "data/*" person=Person2,gender=Fem,pos=?pos,number=?number langs-pvtrial

                                                                                      . bin/constants.sh
ldomain=${1//,/ }
ldomain=${ldomain//\"/}

# After starting the server with fuseki.sh, first copy the query files;
qstring=$2
qlabel=$3
template=sparql/templates/$qlabel.template
response=tmp/prop-val/$qlabel-resp.tsv
localqry=tmp/prop-val/$qlabel.rq

echo "Query String = $qstring"
echo "Template = $template"
echo "Response = $response"
#echo " "
#echo "Title = $title"

perl pl/qstring2template.pl $qstring $template

fs=`find $1 -name *edn`
for f in $fs
do
	#echo "f is $f"
	lang=`basename ${f%-pdgms\.edn}`;
	abb=`grep $lang bin/lname-pref.txt`
    Lang="${lang[@]^}"
    localqry="tmp/prop-val/${qlabel}.$lang.rq"
    #echo "Localqry = $localqry"
    sed -e "s/%lang%/${lang}/g" -e "s/%Lang%/${Lang}/g" $template > $localqry
    ${FUSEKIDIR}/s-query --output=tsv --service http://localhost:3030/aama/query --query=$localqry >> $response
done
perl pl/langspvtsv2table.pl $response
echo " "
echo " "
echo " "

if [ "$4" = "menu" ] ; then
    read -e -p "[ENTER] to continue" input
    bin/aama-query-display-demo.sh
else
    read -e -p "[ENTER] to continue" input
    bin/aama-query-display-test.sh $4
fi

