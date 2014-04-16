# SHELL SCRIPTS

The scripts in bin/ are designed to be run from the aama-data home dir, in my case, ~/aama-data, so: $ ~/aama-data/bin/\<SCRIPT.sh>\. An [Apache Jena fuseki datastore](http://jena.apache.org/documentation/serving_data/) is assumed for query purposes. The scripts in the bin/ directory represent many different stages of project development. The following outline describes the currently (4/1/14) relevant ones under the following headings: 

1. Data Processing Procedures.

2. General Query Procedures.

3. Data Revision Routine.

4. Command-line Query and Display Utilities.


- NB: **constants.sh** is called by many scripts for location of fuseki, saxon, eyeball, etc. **lname-pref.txt** contains the abbreviations for languages used in graph NS prefixes.

============================================

## Data Processing Procedures: (i.e., current SOP, 4/1/14)



1. The normative/persistant data format is [edn: Extensible Data Notation](https://github.com/edn-format/edn). As each LANG-pdgms.edn file is updated, it should be copied to its aama/LANG repo (use aama-cp2lngrepo.sh for larger-scale updates) and pushed to github (can use aama/tools/git-commit-push.sh; for updating local LANG repos after work done on another machine, use aama/tools/git-pull.sh ).

2. **aama-edn2ttl.sh** uses aama-edn2ttl.jar, produced by lein uberjar from edn2ttl clojure project (~/leiningen/edn2ttl2), to make ttl file. As side effect, this passes edn through edn/read-string, which can filter out a certain number of edn format errors.
    - **usage**: bin/aama-edn2ttl.sh data/LANG

3. **aama-ttl2rdf.sh**: Make rdf file. Uses rdf2rdf.jar, which picks up ttl problems from edn2ttl.
   - **usage**: bin/aama-ttl2rdf.sh data/LANG

4. **aama-rdf2fuseki.sh**: Upload to fuseki using s-post. As check, script runs fuqueries.sh, which counts triples and lists graphs on fuseki server after upload.
   - **usage**: bin/aama-rdf2fuseki.sh data/LANG

============================================

## General Query Procedure

Here and in the following sections, interaction with the fuseki datastore is handled by the Jena fuseki SOH (SPARQL Over HTTP) library, a set of ruby scripts incorporated here into the following bash scripts. (The parenthesized scripts are not actually called by current sh scripts.)

	* fupost.sh: 	  s-post
	* (fuput.sh: 	  s-put)
	* (fuget.sh: 	  s-get)
	* fuquery-gen: 	  s-query
	* fudelete.sh: 	  s-delete [delete named graph]
	* (fuclear.sh: 	  s-update "CLEAR DEFAULT" )
	* (fudrop.sh: 	  s-update "DROP ALL")

1. **fuseki.sh**: Launch fuseki with parameters of aamaconfig.ttl. (A variant script, **fuseki-default.sh**, launches fuseki with default parameters.)
    - **usage**: bin/fuseki.sh

2. **fuquery-gen.sh**: A script for running any well-formed SPARQL query file, QUERY.rq, against the fuseki triplestore. 
     - **usage**: bin/fuquery-gen.sh QUERYFILE.rq

3. **fuqueries.sh**: A script which uses fuquery-gen.sh to run sparql/rq-ru/count-triples.rq (yields number of triples currently in the triplestore) and sparql/rq-ru/list-graphs.rq (lists the sub-graphs, i.e. the languages, currently contained in the triplestore); useful as a test after a delete-revise-regenerate-post operation.
    - **usage**: bin/fuqueries.sh 

============================================

##  Data Revision Routine in fuseki Context

Working with data in a query-delete-revise-upload cycle typically involves the following steps:

1. **fuqueries.sh**: See what data is in datastore.

2. **fudelete.sh data/LANG**: Take out the LANG graph.

3. **fuqueries.sh**: Make sure it's gone.

4. [edit data/LANG/LANG.edn (and copy to aama/LANG), regenerate data/LANG/LANG.ttl/rdf]

5. **fupost.sh data/LANG.rdf**: Insert a revised LANG graph.

6. **fuqueries.sh**: Make sure it's back in the datastore.

============================================

## Command-line Query and Display Utilities

Pending the development of a GUI, the following scripts permit an ad-hoc querying and display of the aama data which has been loaded into a fuseki datastore. In various ways each of these scripts performs the following tasks:
* **Identify language domain** -- usually explicitly as the initial  command-line argument, where  \<dir\>, is the directory where the data occurs (data/[LANG] for one language; "data/[LANG] data/[LANG] . . ." [with quotations marks!] for more than one language; "data/*" to search all languages; a few scripts are for queries over the whole data store).
* **Build query string**: In some cases  property and/or value identifiers are given directly as command-line arguments; in others the script first displays by way of prompt a table of relevant properties/values or "paradigm identifiers" (see below, "pnames"), out of which the user makes a selection. The tables are either formatted directly by perl/sed commands in the script, or are print-outs of stored lists generated ahead of time by the list-generation scripts mentioned below.
* **Transform  query string into SPARQL query**. For some simple queries this can be done by direct substitution of language-, property-, and value-identifiers into a query template; in others a distinct query needs to be generated (usually by a perl sub-script).
* **Format response**. Currently almost all fuseki s-query scripts are set for output in tsv format. This is transformed into appropriate tablular (STDOUT/txt/html) display either directly in the shell script itself, or by a perl sub-script.
On inspection it will be obvious that there is considerable overlap among these exploratory scripts, and that many of these could be unified into a single script (with extra arguments, subroutines, etc.) if that turned out to be useful. For now the principal role of these scripts is to serve something of a rough model/prototype for eventual GUI operations with drop-down lists, etc.

* The scripts are named (pending unification) in accordance with the following conventions:
    1. **pos** properties: 
        * *fv* (finite verb). These are terms with 'pos=Verb', and which are marked for the property 'person'. 
        * *nfv* (non-finite verb). All other 'pos=Verb' forms, including participles, stems, etc.
        * *pro* 
        * *noun*
    2. **prompt-display** properties: 
        * *pv*: (the prompt is a table of the property-value pairs which can or must be represented in a paradigm for the language and pos in question; out of these, at the prompt, the user supplies a comma-separated list of form 'prop=val,prop=val,...'). 
        * *pnames*: (the prompt is a numbered list of comma-separated value combinations which occur with the pos in question, exclusive of png values -- effectively a paradigm-name; out of these, at the prompt, the user enters one number). 

The following enumeration  provides for each script a general description, a usage template, an example, and a brief characterization of the processes involved in query-string formation, query formatting, and response formatting.

**Property-Value Displays**

1. **display-valsforprop.sh**: Gives all values for a given property in the specified languages.
    - **usage**: bin/display-valsforprop.sh \<dir\> prop
    - **example**: bin/display-valsforprop.sh "data/beja-arteiga data/beja-atmaan" tam *"Display the values of the property tam for beja-arteiga and beja-atmaa"*
    - **procedures**: 
            1. *q-string*: cl.
        
	    2. *query-generation*: sparql/templates/valsforprop.template.
	
	    3. *response-format*: pl/valforproptsv2table.pl.


2. **display-langsforval.sh**: Displays all languages which have a given value, and the property of which it is a value. [Recall that in this datastore, all property names begin with lower case and all value names with upper case!]
    - **usage**: bin/display-langsforval.sh \<dir\> val
    - **example**: bin/display-langsforval.sh "data/\*" Aorist *"What languages have a value 'Aorist', and for what property?"*
    - **procedures**: 

        	- *q-string*: cl
        
		- *query-generation*: sparql/templates/langsforval.template
	
		- *response-format*: pl/langsforvaltsv2table.pl

3. **display-langspropval.sh**: Lists languages in which a set of one or more *prop=val* equivalences (co)-occur, specified in comma-separated *prop=val* *qstring*; *qlabel* is used to identify the query-file and output-tsv file. *qstring* can also contain one or more *prop=?val* equations (prop1=?val1, prop2=?val2, . . .) indicating that the query should return the values from the 
props in question, 
    - **usage**: bin/display-langspropval.sh \<dir\> qstring qlabel
    - **example**: display-langspropval.sh "data/\*"  person=Person2,gender=Fem,pos=?pos,number=?number langs-pvtrial
 *"What languages have 2f , and if so, in what pos and what num?"*
    - **procedures**: 
        * *q-string*: cl
	* *query-generation*: pl/qstring2template.pl (to form query template)
	* *response-format*: pl/langspvtsv2table.pl

4. **display-langvterms.sh**: Displays for each language all terms having the comma-separated *prop=val* combination specified in the command line; *qlabel* is used to identify the query-file and output-tsv file; optional "prop" argument specifies that property-name will be given with each value (otherwise, only value-names are given)
    - **usage**: bin/display-langvterms.sh \<dir\> qstring qlabel prop
    - **example**: bin/display-langvterms.sh "data/beja-arteiga/ data/beja-atmaan/" person=Person2,gender=Fem langpvterms-trial prop *"Give all the terms in beja-arteiga and beja-atmaan with 2f"*
    - **procedures**: 
        * *q-string*: cl
	* *query-generation*: pl/qstring-vterms2template.pl or pl/qstring-pvterms2template.pl (with or without property names)
	* *response-format*: pl/langs-vtermstsv2table.pl or pl/langs-pvtermstsv2table.pl  (with or without property names).
      

**PDGM Displays**

1. **display-pdgms-fv-pv.sh**: Displays finite verb png forms in one or more languages which meet *prop=val* constraints entered at the prompt.
    - **usage**: bin/display-paradigms.sh \<dir\> 
    - **example**: Two langs: bin/display-paradigms.sh "data/beja-arteiga data/oromo" At prompt "beja-arteiga:" enter  "conjClass=Suffix,polarity=Affirmative,tam=Present". At prompt "oromo:" enter  "clauseType=Main,derivedStem=Base,polarity=Affirmative,tam=Present" [For one lang, single prompt, single display.]
    - **procedures**: 
        * *q-string*: pl/verb-propvaltsv2table.pl (displays table prompt)
	* *query-generation*:  pl/qstring2query.pl  (formulates a unified SPARQL query, not a query-template)
	* *response-format*: pl/pdgmtsv2table.pl 

2. **display-pdgms-fv-pnames.sh**: Displays finite verb png forms with morphosyntactic values contained in "pname".
    - **usage**: bin/display-pdgms-fv-pnames.sh \<dir\> 
    - **example**: at prompt "beja-arteiga;", "10" shows png forms for Prefix-Affirmative-CCY-Aorist.
    - **procedures**: 
        * *q-string*: pl/pnames-print.pl (prints pnames table prompt: file sparql/pdgms/pname-fv-list-$lang.txt, generated by bin/generate-pnames-fv.sh)
	* *query-generation*: pl/qstring-fv-pname2query.pl 
	* *response-format*:  pl/pdgm-fv-tsv2table.pl.

3. **display-pdgms-nfv-pv.sh**: Displays non-finite verb forms in one or more languages which meet *prop=val* constraints entered at the prompt.
    - **usage**: bin/display-paradigms.sh \<dir\> 
    - **example**: At prompt, "derivedStem=B" gives all nfv forms in base stem.
    - **procedures**: 
        * *q-string*: sparql/templates/pdgm-nfv-props.template gives tsv list of forms; pl/verb-propvaltsv2table.pl formats to table prompt
	* *query-generation*: pl/qstring-nfv2query.pl
	* *response-format*: pl/pdgmtsv2table.pl         

4. **display-pdgms-nfv-pnames.sh**: Displays non-finite  forms of verb with morphosyntactic values contained in "pname".
    - **usage**: bin/display-pdgms-nfv-pnames.sh \<dir\> 
    - **example**: at prompt "beja-arteiga;", "2" shows stems for all conjClass, derivedStem, rootClass, and tam verb forms.
    - **procedures**: 
        * *q-string*: pl/pnames-print.pl (prints pnames-list prompt file sparql/pdgms/pname-nfv-list-$lang.txt, generated by bin/generate-pnames-nfv.sh)
	* *query-generation*: pl/qstring-nfv-pname2query.pl
	* *response-format*: pl/pdgm-fv-tsv2table.pl

5. **display-pdgms-pro-pnames.sh**: Displays pronominal  forms with morphosyntactic values contained in "pname". A ". . . -pv.sh" script  is in principle possible, but doesn't seem to yield anything more interesting that the pnames script.
    - **usage**: bin/display-pdgms-pro-pnames.sh \<dir\> 
    - **example**: at prompt "beja-arteiga;", "3" shows all independent pronominal forms.
    - **procedures**: 
        * *q-string*: pl/pnames-print.pl (prints pnames prompt file sparql/pdgms/pname-pro-list-$lang.txt, generated by bin/generate-pnames-pro.sh)
	* *query-generation*: pl/qstring-pro-pname2query.pl
	* *response-format*: pl/pdgm-tsv2table.pl

6. **display-pdgms-noun-pnames.sh**: For the moment, nominal paradigms are only incidentally included in aama, but for the few which exist, this script displays nominal  forms with morphosyntactic values contained in "pname".  A ". . . -pv.sh" script  is in principle possible, but doesn't seem to yield anything more interesting that the pnames script.
    - **usage**: bin/display-pdgms-noun-pnames.sh \<dir\> 
    - **example**: at prompt "beja-arteiga;", "1" shows the noun plural classes. 
    - **procedures**: 
        * *q-string*: pl/pnames-print.pl (prints pnames prompt file sparql/pdgms/pname-noun-list-$lang.txt, generated by generate-pnames-noun.sh)
	* *query-generation*: pl/qstring-noun-pname2query.pl
	* *response-format*: pl/pdgm-tsv2table.pl

**List Generation**

1. **generate-prop-list-fv.sh**: Generates the finite-verb property list sparql/pdgms/pdgm-finite-prop-list.txt for all languages in the triple store.
    - **usage**: bin/generate-prop-list-fv.sh
    - **procedures**: 
        * *q-string*: (fv props in all languages)
	* *query-generation*: sparql/templates/pdgm-finite-prop-list.template
	* *response-format*: pl/pdgm-proplist2txt.pl

2. **generate-prop-list-nfv.sh**: Generates the non-finite-verb property list sparql/pdgms/pdgm-non-finite-prop-list.txt for all languages in the triple store.
    - **usage**: bin/generate-prop-list-nfv.sh
    - **procedures**: 
        * *q-string*: (nfv props in all languages)
	* *query-generation*: sparql/templates/pdgm-non-finite-prop-list.template
	* *response-format*: pl/pdgm-proplist2txt.pl

3. **generate-prop-list-pro.sh**: Generates the pronoun property list sparql/pdgms/pdgm-pro-prop-list.txt for all languages in the triple store.
    - **usage**: bin/generate-prop-list-pro.sh
    - **procedures**: 
        * *q-string*: (pro props in all languages)
	* *query-generation*: sparql/templates/pdgm-pro-prop-list.template
	* *response-format*: pl/pdgm-proplist2txt.pl

4. **generate-prop-list-noun.sh**: Generates the noun property list sparql/pdgms/pdgm-noun-prop-list.txt for all languages in the triple store.
    - **usage**: bin/generate-prop-list-noun.sh
    - **procedures**: 
        * *q-string*: (noun props in all languages)
	* *query-generation*: sparql/templates/pdgm-noun-prop-list.template
	* *response-format*: pl/pdgm-proplist2txt.pl

5. **generate-pnames-fv.sh**: Generates a list of finite-verb property-value combinations sparql/pdgms/pname-vf-list-$language.txt for the argument language.
    - **usage**: bin/generate-pnames-list-fv.sh \<dir\> 
    - **procedures**: 
        * *q-string*: (fv pnames in designated languages)
	* *query-generation*: sparql/templates/pdgm-finite-prop-list.template (yields a property-value tsv file; assembled into a co-occurrence query by:) pl/pname2query.pl
	* *response-format*: pl/pname-fv-list2txt.pl.

6. **generate-pnames-nfv.sh**: Generates a list of non-finite-verb property-value combinations sparql/pdgms/pname-nvf-list-$language.txt for the argument language.
    - **usage**: bin/generate-pnames-list-nfv.sh \<dir\> 
    - **procedures**: 
        * *q-string*: (nfv pnames in designated languages)
	* *query-generation*: sparql/templates/pdgm-non-finite-pnames.template
	* *response-format*: pl/pname-nfv-list2txt.pl

7. **generate-pnames-pro.sh**: Generates a list of pronoun property-value combinations sparql/pdgms/pname-pro-list-$language.txt for the argument language.
    - **usage**: bin/generate-pnames-pro.sh \<dir\> 
    - **procedures**: 
        * *q-string*: (pro pnames in designated languages)
	* *query-generation*: sparql/templates/pdgm-pro-pnames.template
	* *response-format*: pl/pname-np-list2txt.pl

8. **generate-pnames-noun.sh**: Generates a list of noun property-value combinations sparql/pdgms/pname-pro-list-$language.txt for the argument language.
    - **usage**: bin/generate-pnames-noun.sh \<dir\> 
    - **procedures**: 
        * *q-string*: (noun pnames in designated languages)
	* *query-generation*: sparql/pdgm-noun-pnames.template
	* *response-format*: pl/pname-np-list2txt.pl

9. **generate-lang-prop-val-lists.sh**: Generates a tsv file of all lang-prop-val co-occurrences in \<dir>\, and then makes 4 tables (in html form, or tsv for dropping onto a spreadsheet or Word table) with entries: 
(1) *lang	prop: val, val, val, ...* (all the values for each prop in each language), (2) *prop val: lang, lang, lang, ...* (all the languages in which a given prop has a given val), (3) *val	prop: lang, lang, lang, ...* (all the languages in which a given val is associated with a given prop), (4) *prop	lang: val, val, val, ...* (all the values associated with a given prop in a given language)
    - **usage**: bin/generate-lang-prop-val-lists.sh \<dir\> file-tag
    - **example**: *generate-lang-prop-val-lists.sh "data/beja-arteiga data/beja-atmaan data/beja-beniamer data/beja-bishari data/beja-hadendowa" bejaTest* will generate the tables of permutations of lang-prop-val for all the beja languages and put the files in tmp/prop-val/ . . . -bejaTest.html/txt.
    - **procedures**: 
        * *q-string*: (cl)
	* *query-generation*: sparql/templates/lang-prop-val-list.template
	* *response-format*:  pl/lang-prop-val-list-tsv2table.pl $response $filetag

10. **generate-lex-lists.sh**: [TO BE REVISED: Current version calls xml2html-lexlist.xsl to generate from the LANG-pdgms.xml file an html file, tmp/lexlists/$lang-lexlist.html, of all lexemes and muterms in \<dir>\; need version for edn2html to be used for updating and standardizing lexical information in edn file.]
    - **usage**: bin/generate-lang-prop-val-lists.sh \<dir\> 
    - **example**: *generate-lex-lists.sh "data/beja-arteiga data/beja-atmaan data/beja-beniamer data/beja-bishari data/beja-hadendowa" .
    - **procedures**: 
        * *q-string*:
	* *query-generation*:
	* *response-format*:          

11. **generate-pdgms.sh**: [TO BE REVISED: Current version calls xml2html-pdgms.xsl to generate from the LANG-pdgms.xml file an html file, LANG-pdgms.html, of all pdgms in \<dir>\; need version for edn2html to be used for updating and standardizing lexical information in edn file.]
    - **usage**: bin/generate-pdgms-html.sh \<dir\> 
    - **example**: *generate-pdgms-html.sh "data/beja-arteiga data/beja-atmaan data/beja-beniamer data/beja-bishari data/beja-hadendowa" .
    - **procedures**: 
        * *q-string*:
	* *query-generation*:
	* *response-format*:          



