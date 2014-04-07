# SHELL SCRIPTS

The scripts in bin/ are designed to be run from the aama-data home dir (called <aama> below).  In my case, */aama-data, so: $ bin/<script.sh>.

The scripts in bin/ represent many different stages of project development. The following outline describes the currently (4/1/14) relevant ones under the following headings: 

1. Data Processing Procedures.
2. General Query Procedures.
3. Data Revision Routine.
4. Command-line Query and Display Utilities.

* NB: constants.sh. is called by many scripts for location of fuseki, saxon, eyeball, etc.

============================================

## Data Processing Procedures: (i.e., current SOP, 4/1/14)


* lname-pref.txt: contains abbreviations for languages

1. As each LANG-pdgms.edn file is updated, it should be copied to its aama/LANG repo (use aama-cp2lngrepo.sh for larger-scale updates) and pushed to github (can use aama/tools/git-commit-push.sh; for updating local LANG repos after work done on another machine, use aama/tools/git-pull.sh ).

2. **aama-edn2ttl.sh** uses aama-edn2ttl.jar, produced by lein uberjar from edn2ttl clojure project (~/leiningen/edn2ttl2), to make ttl file. As side effect, this passes edn through edn/read-string, which can filter out a certain number of edn format errors.
    - **usage**: bin/aama-edn2ttl.sh data/LANG

3. **aama-ttl2rdf.sh**: Make rdf file. Uses rdf2rdf.jar, which picks up ttl problems from edn2ttl.
   - **usage**: bin/aama-ttl2rdf.sh data/LANG

4. **aama-rdf2fuseki.sh**: Upload to fuseki. As check, script runs fuqueries.sh, which counts triples and lists graphs on fuseki server after upload.
   - **usage**: bin/aama-rdf2fuseki.sh data/LANG

============================================

## General Query Procedure

Here and in the following sections, interaction with the fuseki datastore is handled by the fuseki SOH (SPARQL Over HTTP) library, a set of ruby scripts incorporated here, by Gregg Reynolds, into the following bash scripts: 
	* fuclear.sh: Drop default graph
	* fudelete.sh: Delete named graph.
	* fudrop.sh
	* fuget.sh
	* fupost.sh

1. **fuseki.sh**: Launch fuseki with parameters of aamaconfig.ttl. (A variant script, **fuseki-default.sh**, launches fuseki with default parameters.)
    - **usage**: bin/fuseki.sh

2. **fuquery-gen.sh**: A script for running any well-formed SPARQL query file, QUERY.rq, against the fuseki triplestore. 
     - **usage**: bin/fuquery-gen.sh QUERYFILE.rq

3. **fuqueries.sh**: A script which uses fuquery-gen.sh to run sparql/rq-ru/count-triples.rq (yields number of triples currently in the triplestore) and sparql/rq-ru/list-graphs.rq (lists the sub-graphs, i.e. the languages, currently contained in the triplestore);useful as a test after a regenerate-delete-post operation.
    - **usage**: bin/fuqueries.sh 

============================================

##  Data Revision Routine in fuseki Context

Working with data in a query-delete-revise-upload cycle typically involves the following steps:

1. **fuqueries.sh**: See what data is in datastore.

2. **fudelete.sh data/LANG**: Take out the LANG graph.

3. **fuqueries.sh**: Make sure it's gone.

4. [edit data/LANG.edn, regenerate data/LANG.ttl/rdf]

5. **fupost.sh data/LANG.rdf**: Insert a revised LANG graph.

6. **fuqueries.sh**: Make sure it's back in the datastore.

============================================

## Command-line Query and Display Utilities

Pending the development of a GUI, the following scripts permit an ad-hoc querying and display of the aama data which has been loaded into a fuseki datastore (cf. fuseki SOH tools, below). These scripts can hopefully serve as model/prototype for GUI operations with drop-down lists, etc.

For all of these scripts: 
* The first argument, \<dir\>, is the directory where the data occurs (data/[LANG] for one language; "data/[LANG] data/[LANG] . . ." [with quotations marks!] for more than one language; "data/*" to search all languages). 
* In some cases the shell script operates directly on a template. In other cases there are perl scripts which transform a query string into a SPARQL query or query-template. 
* For most shell scripts there are one or more auxiliary perl scripts [some of these may be replaceable by SED] which transform the (here) tsv response into a STDOUT/txt/html display. [NB: For all of these exploratory scripts there is considerable overlap. Obviously many of these can be unified into a single script (with extra arguments, subroutines, etc.) if that turns out to be useful.]
* The script names are distinguished by the following properties:
    1. **pos** properties: 
        * *fv* (finite verb). These are terms with 'pos=Verb', and which are marked for the property 'person'. 
        * *nfv* (non-finite verb). All other 'pos=Verb' forms, including participles, stems, etc.
        * *pro* 
        * *noun*
    2. **prompt-display** properties: 
        * *pv*: (prompt is a table of the property-value pairs which can or must be represented in a paradigm for the language and pos in question; out of these, at the prompt, the user supplies a comma-separated list of form 'prop=val,prop=val,...'). 
        * *pnames*: (prompt a numbered list of comma-separated value combinations which occur with the pos in question, exclusive of png values -- effectively a paradigm-name; out of these, at the prompt, the user enters one number). 
        * The pv tables and pname lists are generated for any current state of the triple store by the "generate-pnames/prop-list- . . ." scripts. Obviously in a gui the prompts will be supplied by drop-down menus, etc. and user-input will be by clicks.

The individual scripts are:

**Property-Value Displays**

1. **display-valsforprop.sh**: Gives all values for a given property in the specified languages.
    - **usage**: bin/display-valsforprop.sh \<dir\> prop
    - **example**: bin/display-valsforprop.sh "data/beja-arteiga data/beja-atmaan" tam *"Display the values of the property tam for beja-arteiga and beja-atmaa"*
    - **aux-script**: pl/valforproptsv2table.pl to format output

2. **display-langsforval.sh**: Displays all languages which have a given value, and the property of which it is a value. [Recall that in this datastore, all property names begin with lower case and all value names with upper case!]
    - **usage**: bin/display-langsforval.sh \<dir\> val
    - **example**: bin/display-langsforval.sh "data/\*" Aorist *"What languages have a value 'Aorist', and for what property?"*
    - **aux-script**: pl/langsforvaltsv2table.pl to format output

3. **display-langspropval.sh**: Lists languages in which a set of one or more *prop=val* equivalences (co)-occur, specified in comma-separated *prop=val* *qstring*; *qlabel* is used to identify the query-file and output-tsv file. *qstring* can also contain one or more *prop=?val* equations (prop1=?val1, prop2=?val2, . . .) indicating that the query should return the values from the 
props in question, 
    - **usage**: bin/display-langspropval.sh \<dir\> qstring qlabel
    - **example**: display-langspropval.sh "data/\*"  person=Person2,gender=Fem,pos=?pos,number=?number langs-pvtrial
 *"What languages have 2f , and if so, in what pos and what num?"*
    - **aux-script**: pl/qstring2template.pl (to form query template), pl/langspvtsv2table.pl (to format output)

4. **display-langvterms.sh**: Displays for each language all terms having the comma-separated *prop=val* combination specified in the command line; *qlabel* is used to identify the query-file and output-tsv file; optional "prop" argument specifies that property-name will be given with each value (otherwise, only value-names are given)
    - **usage**: bin/display-langvterms.sh \<dir\> qstring qlabel prop
    - **example**: bin/display-langvterms.sh "data/beja-arteiga/ data/beja-atmaan/" person=Person2,gender=Fem langpvterms-trial prop *"Give all the terms in beja-arteiga and beja-atmaan with 2f"*
    - **aux-script**: pl/qstring-vterms2template.pl or pl/qstring-pvterms2template.pl to form query template (with or without property names), pl/langs-vtermstsv2table.pl or pl/langs-pvtermstsv2table.pl to format table output (with or without property names).

**PDGM Displays**

1. **display-pdgms-fv-pv.sh**: Displays finite verb png forms in one or more languages which meet *prop=val* constraints entered at the prompt.
    - **usage**: bin/display-paradigms.sh \<dir\> 
    - **example**: Two langs: bin/display-paradigms.sh "data/beja-arteiga data/oromo" At prompt "beja-arteiga:" enter  "conjClass=Suffix,polarity=Affirmative,tam=Present". At prompt "oromo:" enter  "clauseType=Main,derivedStem=Base,polarity=Affirmative,tam=Present" [For one lang, single prompt, single display.]
    - **aux-script**: verb-propvaltsv2table.pl to display table; qstring2query.pl  formulate a unified SPARQL query (not a query-template); pdgmtsv2table.pl to format the tsv response file into table form.

2. **display-pdgms-fv-pnames.sh**: Displays finite verb png forms with morphosyntactic values contained in "pname".
    - **usage**: bin/display-pdgms-fv-pnames.sh \<dir\> 
    - **example**: at prompt "beja-arteiga;", "10" shows png forms for Prefix-Affirmative-CCY-Aorist.
    - **aux-script**: pnames-print.pl prints pnames file sparql/pdgms/pname-fv-list-$lang.txt (generated by generate-pnames-fv.sh); qstring-fv-pname2query.pl generates query to be submitted to fuseki; output formatted by pdgm-fv-tsv2table.pl.

3. **display-pdgms-nfv-pv.sh**: Displays non-finite verb forms in one or more languages which meet *prop=val* constraints entered at the prompt.
    - **usage**: bin/display-paradigms.sh \<dir\> 
    - **example**: At prompt, "derivedStem=B" gives all nfv forms in base stem.
    - **aux-script**: sparql/templates/pdgm-nfv-props.template gives tsv list of forms; verb-propvaltsv2table.pl formats to table; qstring-nfv2query.pl makes query out of response to prompt; pdgmtsv2table.pl formats output. 

4. **display-pdgms-nfv-pnames.sh**: Displays non-finite  forms of verb with morphosyntactic values contained in "pname".
    - **usage**: bin/display-pdgms-nfv-pnames.sh \<dir\> 
    - **example**: at prompt "beja-arteiga;", "2" shows stems for all conjClass, derivedStem, rootClass, and tam verb forms.
    - **aux-script**: pnames-print.pl prints pnames file sparql/pdgms/pname-nfv-list-$lang.txt (generated by generate-pnames-nfv.sh); qstring-nfv-pname2query.pl generates query to be submitted to fuseki; output formatted by pdgm-fv-tsv2table.pl.

5. **display-pdgms-pro-pnames.sh**: Displays pronominal  forms with morphosyntactic values contained in "pname". A ". . . -pv.sh" script  is in principle possible, but doesn't seem to yield anything more interesting that the pnames script.
    - **usage**: bin/display-pdgms-pro-pnames.sh \<dir\> 
    - **example**: at prompt "beja-arteiga;", "3" shows all independent pronominal forms.
    - **aux-script**: pnames-print.pl prints pnames file sparql/pdgms/pname-pro-list-$lang.txt (generated by generate-pnames-pro.sh); qstring-pro-pname2query.pl generates query to be submitted to fuseki; output formatted by pdgm-tsv2table.pl.

6. **display-pdgms-noun-pnames.sh**: For the moment, nominal paradigms are only incidentally included in aama, but for the few which exist, this script displays nominal  forms with morphosyntactic values contained in "pname".  A ". . . -pv.sh" script  is in principle possible, but doesn't seem to yield anything more interesting that the pnames script.
    - **usage**: bin/display-pdgms-noun-pnames.sh \<dir\> 
    - **example**: at prompt "beja-arteiga;", "1" shows the noun plural classes. 
    - **aux-script**: pnames-print.pl prints pnames file sparql/pdgms/pname-noun-list-$lang.txt (generated by generate-pnames-noun.sh); qstring-noun-pname2query.pl generates query to be submitted to fuseki; output formatted by pdgm-tsv2table.pl.

**List Generation**

1. **generate-prop-list-fv.sh**: Generates the finite-verb property list sparql/pdgms/pdgm-finite-prop-list.txt for all languages in the triple store.
    - **usage**: bin/generate-prop-list-fv.sh
    - **aux-script**: pdgm-finite-prop-list.template; formatted by pdgm-proplist2txt.pl.

2. **generate-prop-list-nfv.sh**: Generates the non-finite-verb property list sparql/pdgms/pdgm-non-finite-prop-list.txt for all languages in the triple store.
    - **usage**: bin/generate-prop-list-nfv.sh
    - **aux-script**: pdgm-non-finite-prop-list.template; formatted by pdgm-proplist2txt.pl.

3. **generate-prop-list-pro.sh**: Generates the pronoun property list sparql/pdgms/pdgm-pro-prop-list.txt for all languages in the triple store.
    - **usage**: bin/generate-prop-list-pro.sh
    - **aux-script**: pdgm-pro-prop-list.template; formatted by pdgm-proplist2txt.pl.

4. **generate-prop-list-noun.sh**: Generates the noun property list sparql/pdgms/pdgm-noun-prop-list.txt for all languages in the triple store.
    - **usage**: bin/generate-prop-list-noun.sh
    - **aux-script**: pdgm-noun-prop-list.template; formatted by pdgm-proplist2txt.pl.

5. **generate-pnames-fv.sh**: Generates a list of finite-verb property-value combinations sparql/pdgms/pname-vf-list-$language.txt for the argument language.
    - **usage**: bin/generate-pnames-list-fv.sh \<dir\> 
    - **aux-script**: pdgm-finite-prop-list.template yields a property-value tsv file; assembled into a co-occurrence query by pname2query.pl; formatted into a pname list  by pname-fv-list2txt.pl.

6. **generate-pnames-nfv.sh**: Generates a list of non-finite-verb property-value combinations sparql/pdgms/pname-nvf-list-$language.txt for the argument language.
    - **usage**: bin/generate-pnames-list-nfv.sh \<dir\> 
    - **aux-script**: pdgm-non-finite-pnames.template; formatted into a pname list by pname-nfv-list2txt.pl

7. **generate-pnames-pro.sh**: Generates a list of pronoun property-value combinations sparql/pdgms/pname-pro-list-$language.txt for the argument language.
    - **usage**: bin/generate-pnames-pro.sh \<dir\> 
    - **aux-script**: pdgm-pro-pnames.template; formatted into a pname list by pname-np-list2txt.pl

8. **generate-pnames-noun.sh**: Generates a list of noun property-value combinations sparql/pdgms/pname-pro-list-$language.txt for the argument language.
    - **usage**: bin/generate-pnames-noun.sh \<dir\> 
    - **aux-script**: pdgm-noun-pnames.template; formatted into a pname list by pname-np-list2txt.pl

9. **generate-lang-prop-val-lists.sh**: Generates a tsv file of all lang-prop-val co-occurrences in \<dir>\, and then makes 4 tables (in html form, or tsv for dropping onto a spreadsheet or Word table) with entries: 
(1) *lang	prop: val, val, val, ...* (all the values for each prop in each language), (2) *prop val: lang, lang, lang, ...* (all the languages in which a given prop has a given val), (3) *val	prop: lang, lang, lang, ...* (all the languages in which a given val is associated with a given prop), (4) *prop	lang: val, val, val, ...* (all the values associated with a given prop in a given language)
    - **usage**: bin/generate-lang-prop-val-lists.sh \<dir\> file-tag
    - **example**: *generate-lang-prop-val-lists.sh "data/beja-arteiga data/beja-atmaan data/beja-beniamer data/beja-bishari data/beja-hadendowa" bejaTest* will generate the tables of permutations of lang-prop-val for all the beja languages and put the files in tmp/prop-val/ . . . -bejaTest.html/txt.

10. **generate-lex-lists.sh**: Calls xml2html-lexlist.xsl to generate from the LANG-pdgms.xml file an html file of all lexemes and muterms in \<dir>\, to be used for updating and standardizing lexical information in xml file.
    - **usage**: bin/generate-lang-prop-val-lists.sh \<dir\> 
    - **example**: *generate-lex-lists.sh "data/beja-arteiga data/beja-atmaan data/beja-beniamer data/beja-bishari data/beja-hadendowa" .

11. **generate-pdgms.sh**: Calls xml2html-pdgms.xsl to generate from the LANG-pdgms.xml file an html file of all pdgms in \<dir>\, to be used for updating and standardizing, and comparing datastore pdgm info with pdgm information in xml file.
    - **usage**: bin/generate-pdgms-html.sh \<dir\> 
    - **example**: *generate-pdgms-html.sh "data/beja-arteiga data/beja-atmaan data/beja-beniamer data/beja-bishari data/beja-hadendowa" .

12. **generate-edn.sh**: Calls xml2edn.xsl to generate LANG-pdgms.edn from LANG-pdgms.xml.
    - **usage**: bin/generate-edn.sh \<dir\> 
    - **example**: *generate-edn.sh "data/beja-arteiga data/beja-atmaan data/beja-beniamer data/beja-bishari data/beja-hadendowa" .



