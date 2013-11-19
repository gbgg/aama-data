# SHELL SCRIPTS (cf. * script-table.docx)

> Run the scripts from the aama home dir (called <aama> below).  In my case, */aama, so: $ bin/<script.sh>.

* constants.sh. Called by many scripts for location of fuseki, saxon, eyeball, etc.
* convert.sh converts data from */work/aamadata to */aama/data.

## Command-line Query and Display Utilities
> Pending the development of a UI, the following scripts permit an ad-hoc querying and display of the aama data which has been loaded into a fuseki datastore (cf. fuseki SOH tools, below).
> For all of these scripts, the first argument, \<dir\>, is the directory where the data occurs (data/[LANG] for one language; "data/[LANG] data/[LANG] . . ." [with quotations marks!] for more than one language; "data/*" to search all languages). The perl scripts which transform the command-line query string into a SPARQL query or query-template, on the one hand, and those which transform the (here) tsv response into a STDOUT/txt/html display, on the other, overlap considerably and could perhaps be unified into single scripts (with subroutines).


1. **display-valsforprop.sh**: Gives all values for a given property in the specified languages.
-**usage**: display-valsfor prop.sh \<dir\> prop
-**example**: bin/display-valsforprop.sh "data/beja-arteiga data/beja-atmaan" tam *"Display the values of the property tam for beja-arteiga and beja-atmaa"*
-**calls**: pl/valforproptsv2table.pl to format output

2. **display-langsforval.sh**: Displays all languages which have a given value, and the property of which it is a value. [Recall that in this datastore, all property names begin with lower case and all value names with upper case!]
-**usage**: display-langsforval.sh \<dir\> val
-**example**: bin/display-langsforval.sh "data/\*" Aorist *"What languages have a value 'Aorist', and for what property?"*
-**calls**: pl/langsforvaltsv2table.pl to format output

3. **display-langspropval.sh**: Lists languages in which a set of one or more *prop=val* equivalences (co)-occur, specified in comma-separated *prop=val* *qstring*; *qlabel* is used to identify the query-file and output-tsv file. *qstring* can also contain one or more *prop=?val* equations (prop1=?val1, prop2=?val2, . . .) indicating that the query should return the values from the 
props in question, 
-**usage**: display-langspropval.sh \<dir\> qstring qlabel
-**example**: display-langspropval.sh "data/\*"  person=Person2,gender=Fem,pos=?pos,number=?number langs-pvtrial
 *"What languages have 2f , and if so, in what pos and what num?"*
-**calls**: pl/qstring2template.pl (to form query template), pl/langspvtsv2table.pl (to format output)

4. **display-langvterms.sh**: Displays for each language all terms having the comma-separated *prop=val* combination specified in the command line; *qlabel* is used to identify the query-file and output-tsv file; optional "prop" argument specifies that property-name will be given with each value (otherwise, only value-names are given)
-**usage**: display-langvterms.sh \<dir\> qstring qlabel prop
-**example**: bin/display-langvterms.sh "data/beja-arteiga/ data/beja-atmaan/" person=Person2,gender=Fem langpvterms-trial prop *"Give all the terms in beja-arteiga and beja-atmaan with 2f"*
-**calls**: pl/qstring-vterms2template.pl or pl/qstring-pvterms2template.pl to form query template (with or without property names), pl/langs-vtermstsv2table.pl or pl/langs-pvtermstsv2table.pl to format table output (with or without property names).

5. **display-paradigms**: Displays finite verb paradigm(s) in one or more languages which meet *prop=val* constraints which need to be specified independently for each language. For the purposes of this display, a finite verb is taken to be a term whose *pos=Verb*, and which has a value for the properties *tam* and *person*. This query is more complicated, and has two steps:
	1. 
-**usage**: display-paradigms.sh <dir>
-**example**: bin/display-paradigms.sh "data/beja-arteiga data/oromo" *"I want to see finite verb paradigms in these languages which meet the conditions to be specified."*

	2. In addition to png, each language has its own set of additional  properties which can or must be represented in any finite verb  paradigm. An initial display gives the relevant properties and values for each language in succession. After each language *prop=val* display, at the language prompt the querier must submit a comma-separated string of *prop=val* statements.
	-**example of user input**: "beja-arteiga:conjClass=Suffix,polarity=Affirmative,tam=Present", then "oromo:clauseType=Main,derivedStem=Base,p;olarity=Affirmative,tam=Present" [The script then displays the suffixing present (mainClause, Base) tense of the two languages in a single paradigm.]
	-**calls**: pl/finite-propvaltsv2table.pl to display prop-val possibilities for each language; pdgm-display.sh for the paradigm display, which in turn calls pl/qstring2query.pl to formulate a unified SPARQL query (not a query-template) for the languages in question, and pl/pdgmtsv2table.pl to format the tsv response file into table form.



## fuseki SOH tools
	> [NB: for e.g. bulk loading data (s-post) the data must be in RDF/XML]

### Launch fuseki
	* fuseki.sh: launch with parameters of aamaconfig.ttl
		* fuseki-default.sh
		* fuseki-no-graph.sh
### Datastore add/delete
	* fuclear.sh: Drop default graph
	* fudelete.sh: Delete named graph.
	* fudrop.sh
	* fuget.sh
	* fupost.sh
		* fupost-default.sh
	* fuput.sh
		* fuput-data.sh
		* fuput-data-aa.sh
		* fuput-data-schema.sh
		* fuput-schema.sh
### Datastore query
	*fuquery.sh - generates a language-specific sparql query from     <aama>/sparql/templates/*.template, then runs it.  
			-**example:<aama>/tools/fuquery.sh data/afar sparql/templates/exponents.template **Generates and runs <aama>/sparql/exponents.afar.rq"
		* fuquery-gen.sh: runs SOH s-query on specific sparql query file. Cf. query files in sparql/rq-ru/ and sparql/pdgms).
		* fuqueries.sh: runs
			* listgraphs.sh: what named graphs are currently present in datastore?
			* count-triples.sh: how many triples are there in datastore?

============================================

## Data generating procedure, xml=>rdf (Modified: 09/19/2013)  

* eyeball.sh
* lname-pref.txt: contains abbreviations for languages

1. git checkout lang-data-rev [no longer create new branch for each lang]
2. Make html: bin/htmlgen.sh dir. -**calls**: xml2html-pdgms.xsl, xml2html-pdgms-sort.xsl
3. Do first-pass bin/lexcheck-gg.sh dir, make sure every term cluster has a lexlabel, mulabel, or classlabel. -**calls**: lexcheck-gg.xsl. -**performs corrections**: 
		* insert in each mu termcluster: \<prop type="mulabel" val="[mulabel]"/\>
		* insert lexlabels where missing: \<prop type="lexlabel" val="[lexlabel]"/\>
		* insert in each multiLex termcluster: \<prop type="multiLex" val="[label]"/\>
		* identify certain tables as: \<prop type="classification" val="[name]/\>
		* mark each term with: \<prop type="classlabel" val="[classlabel]"/\>
4. Do second-pass bin/lexadd.sh dir. -**calls**: lexadd.xsl. 
		*outputs newlex, mlex, and muterm entries in log file; 
		* checks for valid lexlabel in termclusters, writes out newlex if not valid
		* writes out a dummy multilex lexeme for each multilex termcluster
		* checks for valid lexlabel in terms w/i multilex termcluster, writes out newlex if not valid
		* writes out dummy muterm entry for tennclusters with mulabel
		* [TODO: edit dummy/tentative lexemes and add to xml]
5. Fireup fuseki: bin/fuseki.sh
6. Generate .data.ttl/rdf: -**usage**: bin/datagen-gg.sh dir abbrev. -**calls**: xml2data-gg.sh, which in turn calls  xml2data-gg.xsl, data2rdf.sh. -**variants**: data2rdf-aa.sh, datagen-aa.sh, xml2data-aa.sh, xml2data-aa.xsl
7. Generate .schema.ttl/rdf: -**usage**: bin/schemagen-gg.sh dir abbrev. -**calls**: xml2schema-gg.sh, xml2schema-gg.xsl, uniqschema.sh, schema2rdf.sh, fupost.sh, fuqueries.sh
8. Regenerate bin/htmlgen.sh dir
9. git add/commit until git status is clean
10. close files in notepad++ and oxygen
11. git checkout dev, git merge [lang]
12. git push origin [lang]


============================================

## Miscellaneous

* arroots.sh
* convert.sh. Uses:
	* convert.xsl
* convertcheck.sh
* dump.xsl
* dumpprops.sh. Uses:
	* dumpprops.xsl
* dumpvals.sh. Uses:
	* dumpvals.xsl
* file-changes-ttl.txt
* find-replace-strings.txt
* Makefile
* pdgm-display.sh
* pdgm-display-comp.sh
* postar.sh
* propdump.sh
* ttl2rdf.sh
* ttlcheck.sh
* uniqprops.sh
* uniqvals.sh
* xml-file-changes.txt
* xml-file-lexeme-template.txt
* xslcopy.xsl
* xslcopy-lexemes.xsl
