# SHELL SCRIPTS (cf. * script-table.docx)

> Run the scripts from the aama home dir (called <aama> below).  In my case, */aama, so: $ bin/<script.sh>.

* constants.sh. Called by many scripts for location of fuseki, saxon, eyeball, etc.
* convert.sh converts data from */work/aamadata to */aama/data.

## Command-line Query and Display Utilities

> Pending the development of a UI, the following scripts permit an ad-hoc querying and display of the aama data which has been loaded into a fuseki datastore (cf. fuseki SOH tools, below).

> For all of these scripts, the first argument, \<dir\>, is the directory where the data occurs (data/[LANG] for one language; "data/[LANG] data/[LANG] . . ." [with quotations marks!] for more than one language; "data/*" to search all languages). In some cases the shell script operates directly on a template. In other cases there are perl scripts which transform a query string into a SPARQL query or query-template. For most shell scripts there is a final perl script [some of these may be replaceable by SED] which transforms the (here) tsv response into a STDOUT/txt/html display. [NB: For all of these exploratory scripts there is considerable overlap. Obviously many of these can be unified into a single script (with extra arguments, subroutines, etc.) if that turns out to be useful.]

>The "display-pdgms- . . ." (and the "generate-pnames/prop-list- . . .") scripts are distinguished by 

1. *pos*: **fv** (finite verb: terms with 'pos=Verb' and marked for the property 'person'), **nfv** (non-finite verb: all other 'pos=Verb' forms, including participles, stems, etc.), **pro**, **noun**.

2. *input-display*: **pv** (script displays a table of the property-value pairs which can or must be represented in a paradigm for the language and pos in question; out of these, at the prompt, the user supplies a comma-separated list of form 'prop=val,prop=val,...'), **pnames** (script displays a numbered list of comma-separated value combinations which occur with the pos in question, exclusive of png values -- effectively a paradigm-name; out of these, at the prompt, the user enters one number). The pv tables and pname lists are generated for any current state of the triple store by the "generate-pnames/prop-list- . . ." scripts.

Obviously in a gui the prompts will be supplied by drop-down menus, etc. and user-input will be by clicks.

The individual scripts are:

1. **display-valsforprop.sh**: Gives all values for a given property in the specified languages.
-**usage**: bin/display-valsfor prop.sh \<dir\> prop
-**example**: bin/display-valsforprop.sh "data/beja-arteiga data/beja-atmaan" tam *"Display the values of the property tam for beja-arteiga and beja-atmaa"*
-**query**: pl/valforproptsv2table.pl to format output

2. **display-langsforval.sh**: Displays all languages which have a given value, and the property of which it is a value. [Recall that in this datastore, all property names begin with lower case and all value names with upper case!]
-**usage**: bin/display-langsforval.sh \<dir\> v
-**example**: bin/display-langsforval.sh "data/\*" Aorist *"What languages have a value 'Aorist', and for what property?"*
-**query**: pl/langsforvaltsv2table.pl to format output

3. **display-langspropval.sh**: Lists languages in which a set of one or more *prop=val* equivalences (co)-occur, specified in comma-separated *prop=val* *qstring*; *qlabel* is used to identify the query-file and output-tsv file. *qstring* can also contain one or more *prop=?val* equations (prop1=?val1, prop2=?val2, . . .) indicating that the query should return the values from the 
props in question, 
-**usage**: bin/display-langspropval.sh \<dir\> qstring qlabel
-**example**: display-langspropval.sh "data/\*"  person=Person2,gender=Fem,pos=?pos,number=?number langs-pvtrial
 *"What languages have 2f , and if so, in what pos and what num?"*
-**query**: pl/qstring2template.pl (to form query template), pl/langspvtsv2table.pl (to format output)

4. **display-langvterms.sh**: Displays for each language all terms having the comma-separated *prop=val* combination specified in the command line; *qlabel* is used to identify the query-file and output-tsv file; optional "prop" argument specifies that property-name will be given with each value (otherwise, only value-names are given)
-**usage**: bin/display-langvterms.sh \<dir\> qstring qlabel prop
-**example**: bin/display-langvterms.sh "data/beja-arteiga/ data/beja-atmaan/" person=Person2,gender=Fem langpvterms-trial prop *"Give all the terms in beja-arteiga and beja-atmaan with 2f"*
-**query**: pl/qstring-vterms2template.pl or pl/qstring-pvterms2template.pl to form query template (with or without property names), pl/langs-vtermstsv2table.pl or pl/langs-pvtermstsv2table.pl to format table output (with or without property names).

5. **display-pdgms-fv-pv.sh**: Displays finite verb png forms in one or more languages which meet *prop=val* constraints entered at the prompt.
-**usage**: bin/display-paradigms.sh <dir>
-**example**: Two langs: bin/display-paradigms.sh "data/beja-arteiga data/oromo" At prompt "beja-arteiga:" enter  "conjClass=Suffix,polarity=Affirmative,tam=Present". At prompt "oromo:" enter  "clauseType=Main,derivedStem=Base,polarity=Affirmative,tam=Present" [For one lang, single prompt, single display.]
-**query**: verb-propvaltsv2table.pl to display table; qstring2query.pl  formulate a unified SPARQL query (not a query-template); pdgmtsv2table.pl to format the tsv response file into table form.

6. **display-pdgms-fv-pnames.sh**: Displays finite verb png forms with morphosyntactic values contained in "pname".
-**usage**: bin/display-pdgms-fv-pnames.sh <dir>
-**example**: at prompt "beja-arteiga;", "10" shows png forms for Prefix-Affirmative-CCY-Aorist.
-**query**: pnames-print.pl prints pnames file sparql/pdgms/pname-fv-list-$lang.txt (generated by generate-pnames-fv.sh); qstring-fv-pname2query.pl generates query to be submitted to fuseki; output formatted by pdgm-fv-tsv2table.pl.

7. **display-pdgms-nfv-pv.sh**: Displays non-finite verb forms in one or more languages which meet *prop=val* constraints entered at the prompt.
-**usage**: bin/display-paradigms.sh <dir>
-**example**: At prompt, "derivedStem=B" gives all nfv forms in base stem.
-**query**: sparql/templates/pdgm-nfv-props.template gives tsv list of forms; verb-propvaltsv2table.pl formats to table; qstring-nfv2query.pl makes query out of response to prompt; pdgmtsv2table.pl formats output. 

8. **display-pdgms-nfv-pnames.sh**: Displays non-finite  forms of verb with morphosyntactic values contained in "pname".
-**usage**: bin/display-pdgms-nfv-pnames.sh <dir>
-**example**: at prompt "beja-arteiga;", "2" shows stems for all conjClass, derivedStem, rootClass, and tam verb forms.
-**query**: pnames-print.pl prints pnames file sparql/pdgms/pname-nfv-list-$lang.txt (generated by generate-pnames-nfv.sh); qstring-nfv-pname2query.pl generates query to be submitted to fuseki; output formatted by pdgm-fv-tsv2table.pl.

9. **display-pdgms-pro-pnames.sh**: Displays pronominal  forms with morphosyntactic values contained in "pname". A ". . . -pv.sh" script  is in principle possible, but doesn't seem to yield anything more interesting that the pnames script.
-**usage**: bin/display-pdgms-pro-pnames.sh <dir>
-**example**: at prompt "beja-arteiga;", "3" shows all independent pronominal forms.
-**query**: pnames-print.pl prints pnames file sparql/pdgms/pname-pro-list-$lang.txt (generated by generate-pnames-pro.sh); qstring-pro-pname2query.pl generates query to be submitted to fuseki; output formatted by pdgm-tsv2table.pl.

10. **display-pdgms-noun-pnames.sh**: For the moment, nominal paradigms are only incidentally included in aama, but for the few which exist, this script displays nominal  forms with morphosyntactic values contained in "pname".  A ". . . -pv.sh" script  is in principle possible, but doesn't seem to yield anything more interesting that the pnames script.
-**usage**: bin/display-pdgms-noun-pnames.sh <dir>
-**example**: at prompt "beja-arteiga;", "1" shows the noun plural classes. 
-**query**: pnames-print.pl prints pnames file sparql/pdgms/pname-noun-list-$lang.txt (generated by generate-pnames-noun.sh); qstring-noun-pname2query.pl generates query to be submitted to fuseki; output formatted by pdgm-tsv2table.pl.

11. **generate-prop-list-fv.sh**: Generates the finite-verb property list sparql/pdgms/pdgm-finite-prop-list.txt for all languages in the triple store.
-**usage**: bin/generate-prop-list-fv.sh
-**query**: pdgm-finite-prop-list.template; formatted by pdgm-proplist2txt.pl.

12. **generate-prop-list-nfv.sh**: Generates the non-finite-verb property list sparql/pdgms/pdgm-non-finite-prop-list.txt for all languages in the triple store.
-**usage**: bin/generate-prop-list-nfv.sh
-**query**: pdgm-non-finite-prop-list.template; formatted by pdgm-proplist2txt.pl.

13. **generate-prop-list-pro.sh**: Generates the pronoun property list sparql/pdgms/pdgm-pro-prop-list.txt for all languages in the triple store.
-**usage**: bin/generate-prop-list-pro.sh
-**query**: pdgm-pro-prop-list.template; formatted by pdgm-proplist2txt.pl.

14. **generate-prop-list-noun.sh**: Generates the noun property list sparql/pdgms/pdgm-noun-prop-list.txt for all languages in the triple store.
-**usage**: bin/generate-prop-list-noun.sh
-**query**: pdgm-noun-prop-list.template; formatted by pdgm-proplist2txt.pl.

15. **generate-pnames-fv.sh**: Generates a list of finite-verb property-value combinations sparql/pdgms/pname-vf-list-$language.txt for the argument language.
-**usage**: bin/generate-pnames-list-fv.sh <dir>
-**query**: pdgm-finite-prop-list.template yields a property-value tsv file; assembled into a co-occurrence query by pname2query.pl; formatted into a pname list  by pname-fv-list2txt.pl.

16. **generate-pnames-nfv.sh**: Generates a list of non-finite-verb property-value combinations sparql/pdgms/pname-nvf-list-$language.txt for the argument language.
-**usage**: bin/generate-pnames-list-nfv.sh <dir>
-**query**: pdgm-non-finite-pnames.template; formatted into a pname list by pname-nfv-list2txt.pl

17. **generate-pnames-pro.sh**: Generates a list of pronoun property-value combinations sparql/pdgms/pname-pro-list-$language.txt for the argument language.
-**usage**: bin/generate-pnames-pro.sh <dir>
-**query**: pdgm-pro-pnames.template; formatted into a pname list by pname-np-list2txt.pl

18. **generate-pnames-noun.sh**: Generates a list of noun property-value combinations sparql/pdgms/pname-pro-list-$language.txt for the argument language.
-**usage**: bin/generate-pnames-noun.sh <dir>
-**query**: pdgm-noun-pnames.template; formatted into a pname list by pname-np-list2txt.pl

19. **generate-ttl-rdf.sh**: After modification of a data file (at present xml, later edn), this script regenerates new ttl/rdf from xml(edn) for <dir>, deletes old LANG sub-graph, posts new sub-graph, and applies fuqueries.sh as test to count current number of triples in graph, and list sub-graphs.
-**usage**: bin/generate-ttl-rdf.sh <dir>
-**example**: generate-ttl-rdf.sh data/beja-arteiga
-**query**: 

20. **fuquery-gen.sh**: A script for running any well-formed SPARQL query file, QUERY.rq, against the fuseki triplestore. The directory bin/ also contains the script fuqueries.sh, which uses fuquery-gen.sh to run sparql/rq-ru/count-triples.rq (yields number of triples in triplestore) and sparql/rq-ru/list-graphs.rq (lists the sub-graphs, i.e. the languages, contained in the triplestore); these are run by generate-ttl-rdf.sh as a test after a regenerate-delete-post operation.
-**usage**: bin/fuquery-gen.sh QUERYFILE.rq


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
2. Make html: bin/htmlgen.sh dir. -**query**: xml2html-pdgms.xsl, xml2html-pdgms-sort.xsl
3. Do first-pass bin/lexcheck-gg.sh dir, make sure every term cluster has a lexlabel, mulabel, or classlabel. -**query**: lexcheck-gg.xsl. -**performs corrections**: 
		* insert in each mu termcluster: \<prop type="mulabel" val="[mulabel]"/\>
		* insert lexlabels where missing: \<prop type="lexlabel" val="[lexlabel]"/\>
		* insert in each multiLex termcluster: \<prop type="multiLex" val="[label]"/\>
		* identify certain tables as: \<prop type="classification" val="[name]/\>
		* mark each term with: \<prop type="classlabel" val="[classlabel]"/\>
4. Do second-pass bin/lexadd.sh dir. -**query**: lexadd.xsl. 
		*outputs newlex, mlex, and muterm entries in log file; 
		* checks for valid lexlabel in termclusters, writes out newlex if not valid
		* writes out a dummy multilex lexeme for each multilex termcluster
		* checks for valid lexlabel in terms w/i multilex termcluster, writes out newlex if not valid
		* writes out dummy muterm entry for termclusters with mulabel
		* [TODO: edit dummy/tentative lexemes and add to xml]
5. Fireup fuseki: bin/fuseki.sh
6. Generate .data.ttl/rdf: -**usage**: bin/bin/datagen-gg.sh dir abbrev. -**query**: xml2data-gg.sh, which in turn calls  xml2data-gg.xsl, data2rdf.sh. -**variants**: data2rdf-aa.sh, datagen-aa.sh, xml2data-aa.sh, xml2data-aa.xsl
7. Generate .schema.ttl/rdf: -**usage**: bin/bin/schemagen-gg.sh dir abbrev. -**query**: xml2schema-gg.sh, xml2schema-gg.xsl, uniqschema.sh, schema2rdf.sh, fupost.sh, fuqueries.sh
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
