# SHELL SCRIPTS

The scripts in bin/ are designed to be run from the aama-data home dir, in my case, ~/aama-data, so: $ ~/aama-data/bin/\<SCRIPT.sh>\. An [Apache Jena fuseki datastore](http://jena.apache.org/documentation/serving_data/) is assumed for query purposes. The scripts in the bin/ directory represent many different stages of project development. The following outline describes the currently (4/1/14) relevant ones under the following headings: 

1. Data Processing Procedures.

2. General Query Procedures.

3. Data Revision Routine.
 
4. Query and Display Routines
    - "Paradigm Names" (query-produced string which uniquely identifies major coherent clusters of terms, i.e. paradigms, in current datastore)
    - The Query and Display Demo
    - Command-line Query and Display Utilities.


- NB: **constants.sh** is called by many scripts for location of fuseki, saxon, eyeball, etc. **lname-pref.txt** contains the abbreviations for languages used in graph NS prefixes.

============================================

## Data Processing Procedures: (i.e., current SOP, 4/1/14)



1. The normative/persistant data format is [edn: Extensible Data Notation](https://github.com/edn-format/edn). As each LANG-pdgms.edn file is updated, it should be copied to its aama/LANG repo (use aama-cp2lngrepo.sh for larger-scale updates) and pushed to github (can use aama/tools/git-commit-push.sh; for updating local LANG repos after work done on another machine, use aama/tools/git-pull.sh ).

2. **aama-edn2ttl.sh** uses aama-edn2ttl.jar, produced by lein uberjar from edn2ttl clojure project (~/leiningen/edn2ttl2; current version is stored in sparql/clojure, and should be copied to user's JAR directory), to make ttl file. As side effect, this passes edn through edn/read-string, which can filter out a certain number of edn format errors.
    - **usage**: bin/aama-edn2ttl.sh data/LANG

3. **aama-ttl2rdf.sh**: Make rdf file. Uses rdf2rdf.jar, which picks up ttl problems from edn2ttl. [INCLUDES aama-edn2ttl.jar, for use once eventual edn/read-string problems have been debugged.]
   - **usage**: bin/aama-ttl2rdf.sh data/LANG

4. **aama-rdf2fuseki.sh**: Upload to fuseki using s-post. As check, script runs fuqueries.sh, which counts triples and lists graphs on fuseki server after upload.
   - **usage**: bin/aama-rdf2fuseki.sh data/LANG

============================================

## General Query Procedure

Here and in the following sections, it is presumed that interaction with the datastore is handled by the Jena fuseki SOH (SPARQL Over HTTP) library, a set of ruby scripts incorporated here into the following bash scripts. (The parenthesized scripts are not actually called by the scripts described in this section.)

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

Working with data in a query-delete-revise-upload cycle typically involves periodic invocation of aama-datastore-setup.sh  after a data/LANG/LANG-pdgms.edn has been edited:
    - **usage**: bin/aama-datastore-setup.sh data/LANG (for a single language); bin/aama-datastore-setup.sh "data/*" (to [re-]initiate the whole datastore)

This script invokes the following tasks:

1. **fudelete.sh data/LANG**: Take out the current LANG graph.

2. **fuqueries.sh**: Make sure it's gone.

3. **aama-edn2rdf.sh data/LANG**: Transform LANG-pdgms.edn to LANG-pdgms.ttl to LANG-pdgms.rdf.

4. **aama-rdf2fuseki.sh data/LANG**: Upload the current LANG-pdgms.rdf to the datastore.

5. **fuqueries.sh**: Make sure it's back.

6. **generate-pnames-fv~nfv~pro~noun.sh**: Generate the "paradigm name" files needed for the display of standard form configurations.

============================================

## The Query/Display Routines

### The Notion "Paradigm Name" (*pname*)

One the datastore is set up, it can of course be searched for any arbitrary configuration of morphological properties and values using an appropriate  well-formed SPARQL query (with fuquery-gen.sh, as indicated above). 

However inflectional systems are typically organized (in the descriptive and pedagogical literature, certainly, and perhaps also in the underlying system) in certain standard configurations -- e.g., the standard finite verb conjugation table showing the person-number(-gender) subject-agreement forms  for a given set of tense, aspect, mode, form-class, etc. properties. 

To facilitate the discovery and display of these configuratons, for each language and for each major part-of-speech, we have generated a list of "paradigm names" - query-produced strings which uniquely identified major coherent clusters of terms, i.e. paradigms, in the current datastore. The criteria for identifying these clusters differ according to the part-of-speech distinctions used in this context: 

1. **Finite Verbs** (fv): For the purposes of this datastore, a finite verb is taken to be any verb-form inflected for person agreement (frequently accompanied by number and/or gender agreement). For any given language, the output of the script **generate-pnames-fv.sh**  is  a text file, sparql/pdgms/pname-fv-list-LANG.txt with a list of comma-separated value combinations. E.g., from pname-fv-list-beja-arteiga.txt, number 12 is "Beja-arteiga,Prefix,Affirmative,CCY,Optative". This indicates that a set of png-inflected forms exist in Beja-arteiga for the Optative, Affirmative, Prefix-conjugated, CCY-root-class verb. These pname lists are then used in certain paradigm-display scripts, which present the user with a list of png paradigms which can be chosen for display. The important point here is that the  pname does not come from the data-source, nor is it in the datastore, but is dynamically generated from the datastore as forms are added to (or subtracted from) it.

2. **Non-finite Verbs** (nfv): At this point we are operationally defining "non-finite" verb as simply the complement of "finite verb", i.e., any term with ps=verb and no value for the property "person". This categorization throws together for the moment "paradigms" of terms which are partial forms of the verb, e.g., tense stems or derived stems, with paradigms of terms which are simply non-finite adjectival or nominal forms of the verb. This may be corrected later when the nature and distribution of Cushitic and Omotic non-finite verb forms is clearer, and it makes sense to set up an across-the-board property such as "non-finite-form". At present, in order to make useful lists, this means that every verb form not marked for "person" must be marked for what we are for the moment calling "morphClass" (which, in a sense is there to answer the question, "Why is this form in the datastore?"), which, for the time being, we will write in  upper-case letters, i.e., TENSESTEM, NONFINITEFORM. In a manner similar to that described for fv, a script **generate-pnames-nfv.sh** produces for each LANG a pname-nfv-list-LANG.txt whose entries consist formally of a morphClass, followed by a ":", followed by a comma-separated list of properties (MORPHCLASS:property,property, . . .). For example, from pname-nfv-list-beja-arteiga.txt, item 3,"VERBALPARTICIPLES:conjClass,derivedStem,nonFiniteForm,participle" indicates that there is a set of Beja-arteiga forms, belonging to the morphClass VERBALPARTICIPLES whose members are distinguished by different values of the properties conjClass, derivedStem, nonFiniteForm, and participle.

3. **Pronoun** (pro): These are, straightforwardly, terms with pos=Pronoun; and each pronominal form is marked with a proClass. So, as for nfv, a script **generate-pnames-pro.sh** produces for each LANG a pname-nfv-list-LANG.txt whose entries consist formally of a proClass, followed by a ":", followed by a comma-separated list of properties (proClass:property,property, . . .). For example, from pname-pro-list-beja-arteiga.txt, item 3, "Independent:case,gender,number,person", indicates that there is a set of Beja-arteiga forms belonging to the proClass Independent whose members are distinguished by different values of the properties case, gender, number, and person.

4. **Noun** (noun): Since AAMA is at present an archive of verbal and pronominal paradigms, there are only a very few nominal paradigms in the archive. Nominal inflection  works somewhat differently from, and involves fewer categories than, verbal and pronominal inflection in Cushitic-Omotic, and would not present in any case the same rich variety of paradigms. Nevertheless in the process of collecting data, some nominal material was collected. To permit an overview and inspection of this material a script **generate-pnames-noun.sh**, calqued generally on the nfv script, produces a pname-noun-list-LANG.txt for languages with nominal material in the archive. As for nfv, entries in the list are of the form "MORPHCLASS:property,property, . . .".

==============================================================================

### Query and Display Demo

**bin/aama-query-display-demo.sh** is a provisional menu-driven command-line app for  cycling  through the 'display-' and 'generate-' shell scripts described in the following section. Its purpose is to demonstrate  different kinds of  query strings (user-supplied script arguments), their transformation into SPARQL queries, and a tabular display of the resulting response. 

The demo presupposes that github/gbgg/aama-data has been cloned in the user's computer, that the most recent changes have been pulled (which will include the up-to-date edn data files, and their ttl/rdf versions), and that the user has installed Jena Fuseki.

In order to run the demo the user needs to:

1. Edit bin/constants.sh to reflect the location of fuseki on the user's machine.
2. If the datastore has not been set up, or is not up-to-date, run 'bin/aama-datastore-setup.sh "data/*"' (see above).
3. Launch the fuseki server with bin/fuseki.sh in one terminal window.
4. Run bin/aama-query-display-demo.sh in another terminal window.

A variant of this script, **bin/aama-query-display-test.sh** with argument data/LANG, has been created in which LANG becomes a default argument for all relevant scripts, enabling rapid testing of language data against a wide variety of query types.

==============================================

### Command-line Query and Display Utilities

Pending the development of a GUI, the following scripts permit an ad-hoc querying and display of the aama data which has been loaded into a fuseki datastore. In various ways each of these scripts performs the following tasks:
* **Identify language domain** -- usually explicitly as the initial  command-line argument, where  \<dir\>, is the directory where the data occurs (data/[LANG] for one language; "data/[LANG] data/[LANG] . . ." [with quotations marks!] for more than one language; "data/*" to search all languages; a few scripts are for queries over the whole data store).
* **Build query string**: In some cases  property and/or value identifiers are given directly as command-line arguments; in others the script first displays by way of prompt a table of relevant properties/values or "paradigm identifiers" (see below, "pnames"), out of which the user makes a selection. The tables are either formatted directly by perl/sed commands in the script, or are print-outs of stored lists generated ahead of time by the list-generation scripts mentioned below.
* **Transform  query string into SPARQL query**. For some simple queries this can be done by direct substitution of language-, property-, and value-identifiers into a query template; in others a distinct query needs to be generated (usually by a perl sub-script).
* **Format response**. Currently almost all fuseki s-query scripts are set for output in tsv format. This is transformed into appropriate tablular (STDOUT/txt/html) display either directly in the shell script itself, or by a perl sub-script.


* On inspection it will be obvious that there is considerable overlap among these exploratory scripts, and that many of these could be unified into a single script (with extra arguments, subroutines, etc.) if that turned out to be useful. For now the principal role of these scripts is to serve something of a rough model/prototype for eventual GUI operations with drop-down lists, etc.

* *Script Names.* The scripts are named (pending unification) in accordance with the following conventions:
    1. **pos** properties: 
        * *fv* (finite verb). These are terms with 'pos=Verb', and which are marked for the property 'person'. 
        * *nfv* (non-finite verb). All other 'pos=Verb' forms, including participles, stems, etc.
        * *pro* 
        * *noun*
    2. **prompt-display** properties: 
        * *pv*: (the prompt is a table of the property-value pairs which can or must be represented in a paradigm for the language and pos in question; out of these, at the prompt, the user supplies a comma-separated list of form 'prop=val,prop=val,...'). 
        * *pnames*: (the prompt is a numbered list of comma-separated value combinations which occur with the pos in question, exclusive of png values -- effectively a paradigm-name; out of these, at the prompt, the user enters one number). 

The following enumeration  provides for each script a general description, a usage template, an example, the internally generated query and response files, and a brief characterization of the processes involved in query-string formation, query formatting, and response formatting.

**Property-Value Displays**

1. **display-valsforprop.sh**: Gives all values for a given property in the specified languages.
    - **usage**: bin/display-valsforprop.sh \<dir\> prop
    - **example**: bin/display-valsforprop.sh "data/beja-arteiga data/beja-atmaan" tam *"Display the values of the property tam for beja-arteiga and beja-atmaa"*
    - **files generated**: 
        * *tmp/prop-val/valsforprop.$lang.rq*
        * *tmp/prop-val/valsforprop.$lang-resp.tsv*
    - **procedures**: 
        *    **q-string**: (command line)
	*    **generate-query**: sparql/templates/valsforprop.template
	*    **format-response**: pl/valforproptsv2table.pl

2. **display-langsforval.sh**: Displays all languages which have a given value, and the property of which it is a value. [Recall that in this datastore, all property names begin with lower case and all value names with upper case!]
    - **usage**: bin/display-langsforval.sh \<dir\> val
    - **example**: bin/display-langsforval.sh "data/\*" Aorist *"What languages have a value 'Aorist', and for what property?"*
    - **files generated**: 
        * *tmp/prop-val/langsforval.$val-resp.tsv*
        * *tmp/prop-val/langsforval.$lang.rq*
    - **procedures**: 
        *    **q-string**: (command-line)
	*    **generate-query**: sparql/templates/langsforval.template
	*    **format-response**: pl/langsforvaltsv2table.pl

3. **display-langspropval.sh**: Lists languages in which a set of one or more *prop=val* equivalences (co)-occur, specified in comma-separated *prop=val* *qstring*; *qlabel* is used to identify the query-file and output-tsv file. *qstring* can also contain one or more *prop=?val* equations (prop1=?val1, prop2=?val2, . . .) indicating that the query should return the values from the 
props in question. 
    - **usage**: bin/display-langspropval.sh \<dir\> qstring qlabel
    - **example**: display-langspropval.sh "data/\*"  person=Person2,gender=Fem,pos=?pos,number=?number langs-pvtrial
 *"What languages have 2f , and if so, in what pos and what num?"*
    - **files generated**: 
        * *sparql/templates/$qlabel.template*
        * *tmp/prop-val/$qlabel-resp.tsv*
        * *tmp/prop-val/$qlabel.rq*
    - **procedures**: 
        *    **q-string**: (command-line)
	*    **generate-query**: pl/qstring2template.pl (to form query template)
	*    **format-response**: pl/langspvtsv2table.pl

4. **display-langvterms.sh**: Displays for each language all terms having the comma-separated *prop=val* combination specified in the command line; *qlabel* is used to identify the query-file and output-tsv file; optional"yes" for "prop" argument specifies that property-name will be given with each value (otherwise, only value-names are given)
    - **usage**: bin/display-langvterms.sh \<dir\> qstring qlabel prop
    - **example**: bin/display-langvterms.sh "data/beja-arteiga/ data/beja-atmaan/" person=Person2,gender=Fem langpvterms-trial yes *"Give all the terms in beja-arteiga and beja-atmaan with 2f"*
    - **files generated**: 
        * *sparql/templates/$qlabel.template*
        * *tmp/prop-val/$qlabel-resp.tsv*
        * *tmp/prop-val/$qlabel-$lang.rq*
        * *(tmp/prop-val/$qlabel.txt)*
    - **procedures**: 
        *    **q-string**: (command-line)
	*    **generate-query**: pl/qstring-vterms2template.pl or pl/qstring-pvterms2template.pl (with or without property names)
	*    **format-response**: pl/langs-vtermstsv2table.pl or pl/langs-pvtermstsv2table.pl  (with or without property names).
      

**PDGM Displays**

1. **display-pdgms-fv-pv.sh**: Displays finite verb png forms in one or more languages which meet *prop=val* constraints entered at the prompt.
    - **usage**: bin/display-paradigms.sh \<dir\> 
    - **example**: Two langs: bin/display-paradigms.sh "data/beja-arteiga data/oromo" At prompt "beja-arteiga:" enter  "conjClass=Suffix,polarity=Affirmative,tam=Present". At prompt "oromo:" enter  "clauseType=Main,derivedStem=Base,polarity=Affirmative,tam=Present" [For one lang, single prompt, single display.]
    - **files consulted**
        * *sparql/pdgms/pdgm-finite-prop-list.txt*
    - **files generated**: 
        * *tmp/prop-val/pdgm-fv-props.$lang.rq*
        * *tmp/prop-val/pdgm-fv-props.$lang-resp.tsv*
	* *tmp/prop-val/pdgm-fv-props.$lang.txt*
        * *tmp/pdgm/$qlabel-query.rq*
        * *tmp/pdgm/$qlabel-response.tsv*
        * *tmp/pdgm/$qlabel-response.txt*
        * *tmp/pdgm/$qlabel-response.html*
    - **procedures**: 
        *    **q-string**: pl/verb-propvaltsv2table.pl (displays table prompt)
	*    **generate-query**:  pl/qstring2query.pl  (formulates a unified SPARQL query, not a query-template)
	*    **format-response**: pl/pdgmtsv2table.pl 

2. **display-pdgms-fv-pnames.sh**: Displays finite verb png forms with morphosyntactic values contained in "pname".
    - **usage**: bin/display-pdgms-fv-pnames.sh \<dir\> 
    - **example**: at prompt "beja-arteiga;", "10" shows png forms for Prefix-Affirmative-CCY-Aorist.
    - **files consulted**
        * *sparql/pdgms/pname-fv-list-$lang.txt*
    - **files generated**: 
        * *tmp/pdgm/pname-$lang-fv-$pnumber-query.rq*
        * *tmp/pdgm/pname-$lang-fv-$pnumber-resp.tsv*
        * *tmp/pdgm/pname-$lang-fv-$pnumber-resp.txt*
	* *tmp/pdgm/pname-$lang-fv-$pnumber-resp.html*
    - **procedures**: 
        *    **q-string**: pl/pnames-print.pl (prints pnames table prompt: file sparql/pdgms/pname-fv-list-$lang.txt, generated by bin/generate-pnames-fv.sh)
	*    **generate-query**: pl/qstring-fv-pname2query.pl 
	*    **format-response**:  pl/pdgm-fv-tsv2table.pl.

3. **display-pdgms-nfv-pv.sh**: Displays non-finite verb forms in one or more languages which meet *prop=val* constraints entered at the prompt.
    - **usage**: bin/display-paradigms.sh \<dir\> 
    - **example**: At prompt, "derivedStem=B" gives all nfv forms in base stem.
    - **files consulted**
        * *sparql/pdgms/pdgm-non-finite-prop-list.txt*
    - **files generated**: 
        * *tmp/prop-val/pdgm-nfv-props.$lang.rq*
        * *tmp/prop-val/pdgm-nfv-props.$lang-resp.tsv*
	* *tmp/prop-val/pdgm-nfv-props.$lang.txt*
        * *tmp/pdgm/$qlabel-query.rq*
        * *tmp/pdgm/$qlabel-response.tsv*
        * *tmp/pdgm/$qlabel-response.txt*
        * *tmp/pdgm/$qlabel-response.html*
    - **procedures**: 
        *    **q-string**: sparql/templates/pdgm-nfv-props.template gives tsv list of forms; pl/verb-propvaltsv2table.pl formats to table prompt
	*    **generate-query**: pl/qstring-nfv2query.pl
	*    **format-response**: pl/pdgmtsv2table.pl         

4. **display-pdgms-nfv-pnames.sh**: Displays non-finite  forms of verb with morphosyntactic values contained in "pname".
    - **usage**: bin/display-pdgms-nfv-pnames.sh \<dir\> 
    - **example**: at prompt "beja-arteiga;", "2" shows stems for all conjClass, derivedStem, rootClass, and tam verb forms.
    - **files consulted**
        * *sparql/pdgms/pname-nfv-list-$lang.txt*
    - **files generated**: 
        * *tmp/pdgm/pname-$lang-nfv-$pnumber-query.rq*
        * *tmp/pdgm/pname-$lang-nfv-$pnumber-resp.tsv*
        * *tmp/pdgm/pname-$lang-nfv-$pnumber-resp.txt*
	* *tmp/pdgm/pname-$lang-nfv-$pnumber-resp.html*
    - **procedures**: 
        *    **q-string**: pl/pnames-print.pl (prints pnames-list prompt file sparql/pdgms/pname-nfv-list-$lang.txt, generated by bin/generate-pnames-nfv.sh)
	*    **generate-query**: pl/qstring-nfv-pname2query.pl
	*    **format-response**: pl/pdgm-fv-tsv2table.pl

5. **display-pdgms-pro-pnames.sh**: Displays pronominal  forms with morphosyntactic values contained in "pname". A ". . . -pv.sh" script  is in principle possible, but doesn't seem to yield anything more interesting that the pnames script.
    - **usage**: bin/display-pdgms-pro-pnames.sh \<dir\> 
    - **example**: at prompt "beja-arteiga;", "3" shows all independent pronominal forms.
    - **files consulted**
        * *sparql/pdgms/pname-pro-list-$lang.txt*
    - **files generated**: 
        * *tmp/pdgm/pname-$lang-pro-$pnumber-query.rq*
        * *tmp/pdgm/pname-$lang-pro-$pnumber-resp.tsv*
        * *tmp/pdgm/pname-$lang-pro-$pnumber-resp.txt*
	* *tmp/pdgm/pname-$lang-pro-$pnumber-resp.html*
    - **procedures**: 
        *    **q-string**: pl/pnames-print.pl (prints pnames prompt file sparql/pdgms/pname-pro-list-$lang.txt, generated by bin/generate-pnames-pro.sh)
	*    **generate-query**: pl/qstring-pro-pname2query.pl
	*    **format-response**: pl/pdgm-tsv2table.pl

6. **display-pdgms-noun-pnames.sh**: For the moment, nominal paradigms are only incidentally included in aama, but for the few which exist, this script displays nominal  forms with morphosyntactic values contained in "pname".  A ". . . -pv.sh" script  is in principle possible, but doesn't seem to yield anything more interesting that the pnames script.
    - **usage**: bin/display-pdgms-noun-pnames.sh \<dir\> 
    - **example**: at prompt "beja-arteiga;", "1" shows the noun plural classes. 
    - **files consulted**
        * *sparql/pdgms/pname-noun-list-$lang.txt*
    - **files generated**: 
        * *tmp/pdgm/pname-$lang-noun-$pnumber-query.rq*
        * *tmp/pdgm/pname-$lang-noun-$pnumber-resp.tsv*
        * *tmp/pdgm/pname-$lang-noun-$pnumber-resp.txt*
	* *tmp/pdgm/pname-$lang-noun-$pnumber-resp.html*
    - **procedures**: 
        *    **q-string**: pl/pnames-print.pl (prints pnames prompt file sparql/pdgms/pname-noun-list-$lang.txt, generated by generate-pnames-noun.sh)
	*    **generate-query**: pl/qstring-noun-pname2query.pl
	*    **format-response**: pl/pdgm-tsv2table.pl

**List Generation**

1. **generate-prop-list-fv.sh**: Generates the finite-verb property list sparql/pdgms/pdgm-finite-prop-list.txt for all languages in the triple store.
    - **usage**: bin/generate-prop-list-fv.sh
    - **files generated**: 
        * *tmp/pdgm/pdgm-finite-prop-list.$lang.rq*
        * *sparql/pdgms/pdgm-finite-prop-list.tsv*
	* *sparql/pdgms/pdgm-finite-prop-list.txt*
    - **procedures**: 
        *    **q-string**: (fv props in all languages)
	*    **generate-query**: sparql/templates/pdgm-finite-prop-list.template
	*    **format-response**: pl/pdgm-proplist2txt.pl

2. **generate-prop-list-nfv.sh**: Generates the non-finite-verb property list sparql/pdgms/pdgm-non-finite-prop-list.txt for all languages in the triple store.
    - **usage**: bin/generate-prop-list-nfv.sh
    - **files generated**: 
        * *tmp/pdgm/pdgm-non-finite-prop-list.$lang.rq*
        * *sparql/pdgms/pdgm-non-finite-prop-list.tsv*
        * *sparql/pdgms/pdgm-non-finite-prop-list.txt*
    - **procedures**: 
        *    **q-string**: (nfv props in all languages)
	*    **generate-query**: sparql/templates/pdgm-non-finite-prop-list.template
	*    **format-response**: pl/pdgm-proplist2txt.pl

3. **generate-prop-list-pro.sh**: Generates the pronoun property list sparql/pdgms/pdgm-pro-prop-list.txt for all languages in the triple store.
    - **usage**: bin/generate-prop-list-pro.sh
    - **files generated**: 
        * *tmp/pdgm/pdgm-pro-prop-list.$lang.rq*
        * *sparql/pdgms/pdgm-pro-prop-list.tsv*
        * *sparql/pdgms/pdgm-pro-prop-list.txt*
    - **procedures**: 
        *    **q-string**: (pro props in all languages)
	*    **generate-query**: sparql/templates/pdgm-pro-prop-list.template
	*    **format-response**: pl/pdgm-proplist2txt.pl

4. **generate-prop-list-noun.sh**: Generates the noun property list sparql/pdgms/pdgm-noun-prop-list.txt for all languages in the triple store.
    - **usage**: bin/generate-prop-list-noun.sh
    - **files generated**: 
        * *tmp/pdgm/pdgm-noun-prop-list.$lang.rq*
        * *sparql/pdgms/pdgm-noun-prop-list.tsv*
        * *sparql/pdgms/pdgm-noun-prop-list.txt*
    - **procedures**: 
        *    **q-string**: (noun props in all languages)
	*    **generate-query**: sparql/templates/pdgm-noun-prop-list.template
	*    **format-response**: pl/pdgm-proplist2txt.pl

5. **generate-pnames-fv.sh**: Generates a list of finite-verb property-value combinations sparql/pdgms/pname-vf-list-$language.txt for the argument language.
The script first queries the datastore for all additional inflectional property=value associations co-occurring with terms marked for  pos=Verb and having a value for the property "person". A second query is then generated to determine which of these propp-val associations co-occur in the verb forms of the datastore (e.g., not all tense values which occur in affirmative forms also occur in negative; also a possibly occurring value combination, for example a given tense form of a less common derived stem, might simply not have been noted in the language description which was the source of the data for this datastore). The output of this query is formatted into a text file with a list of comma-separated value combinations: e.g., from sparql/pdgms/pname-fv-list-beja-arteiga.txt, number 12 is "Beja-arteiga,Prefix,Affirmative,CCY,Optative". This indicates that a set of png-inflected forms exist in Beja-arteiga for the Optative, Affirmative, Prefix-conjugated, CCY-root-class verb.
    - **usage**: bin/generate-pnames-list-fv.sh \<dir\> 
    - **files generated**:
        * *tmp/pdgm/pnames-fv-$lang-query.rq*
        * *tmp/pdgm/pnames-fv-$lang-resp.tsv*
        * *tmp/pdgm/pnames-fv-$lang-query2.rq*
        * *tmp/pdgm/pnames-fv-$lang-resp2.tsv*
        * *sparql/pdgms/pname-fv-list-$lang.txt*
    - **procedures**: 
        *    **q-string**: (fv pnames in designated languages)
	*    **generate-query**: sparql/templates/pdgm-finite-prop-list.template (yields a property-value tsv file; assembled into a co-occurrence query by:) pl/pname2query.pl
	*    **format-response**: pl/pname-fv-list2txt.pl.

6. **generate-pnames-nfv.sh**: Generates a list of non-finite-verb property-value combinations sparql/pdgms/pname-nvf-list-$language.txt for the argument language.
    - **usage**: bin/generate-pnames-list-nfv.sh \<dir\> 
    - **files generated**: 
        * *tmp/pdgm/pnames-nfv-$lang-query.rq*
        * *tmp/pdgm/pnames-nfv-$lang-resp.tsv*
        * *sparql/pdgms/pname-nfv-list-$lang.txt*
    - **procedures**: 
        *    **q-string**: (nfv pnames in designated languages)
	*    **generate-query**: sparql/templates/pdgm-non-finite-pnames.template
	*    **format-response**: pl/pname-nfv-list2txt.pl

7. **generate-pnames-pro.sh**: Generates a list of pronoun property-value combinations sparql/pdgms/pname-pro-list-$language.txt for the argument language.
    - **usage**: bin/generate-pnames-pro.sh \<dir\> 
    - **files generated**: 
        * *tmp/pdgm/pnames-pro-$lang-query.rq*
        * *tmp/pdgm/pnames-pro-$lang-resp.tsv*
        * *sparql/pdgms/pname-$pos-list-$lang.txt*
    - **procedures**: 
        *    **q-string**: (pro pnames in designated languages)
	*    **generate-query**: sparql/templates/pdgm-pro-pnames.template
	*    **format-response**: pl/pname-np-list2txt.pl

8. **generate-pnames-noun.sh**: Generates a list of noun property-value combinations sparql/pdgms/pname-pro-list-$language.txt for the argument language.
    - **usage**: bin/generate-pnames-noun.sh \<dir\> 
    - **files generated**: 
        * *tmp/pdgm/pnames-noun-$lang-query.rq*
        * *tmp/pdgm/pnames-noun-$lang-resp.tsv*
        * *sparql/pdgms/pname-$pos-list-$lang.txt*
    - **procedures**: 
        *    **q-string**: (noun pnames in designated languages)
	*    **generate-query**: sparql/pdgm-noun-pnames.template
	*    **format-response**: pl/pname-np-list2txt.pl

9. **generate-lang-prop-val-lists.sh**: Generates a tsv file of all lang-prop-val co-occurrences in \<dir>\, and then makes 4 tables (in html form, or tsv for dropping onto a spreadsheet or Word table) with entries: 
(1) *lang	prop: val, val, val, ...* (all the values for each prop in each language), (2) *prop val: lang, lang, lang, ...* (all the languages in which a given prop has a given val), (3) *val	prop: lang, lang, lang, ...* (all the languages in which a given val is associated with a given prop), (4) *prop	lang: val, val, val, ...* (all the values associated with a given prop in a given language)
    - **usage**: bin/generate-lang-prop-val-lists.sh \<dir\> file-tag
    - **example**: *generate-lang-prop-val-lists.sh "data/beja-arteiga data/beja-atmaan data/beja-beniamer data/beja-bishari data/beja-hadendowa" bejaTest* will generate the tables of permutations of lang-prop-val for all the beja languages and put the files in tmp/prop-val/ . . . -bejaTest.html/txt.
    - **files generated**: 
        * *tmp/prop-val/lang-prop-val-list.$lang.rq*
        * *tmp/prop-val/lang-prop-val-list.tsv*
        * *tmp/prop-val/lang-prop-val-list-$filetag.txt*
        * *tmp/prop-val/prop-val-lang-list-$filetag.txt*
        * *tmp/prop-val/val-prop-lang-list-$filetag.txt*
        * *tmp/prop-val/prop-lang-val-list-$filetag.txt*
        * *tmp/prop-val/lang-prop-val-list-$filetag.html*
        * *tmp/prop-val/prop-val-lang-list-$filetag.html*
        * *tmp/prop-val/val-prop-lang-list-$filetag.html*
        * *tmp/prop-val/prop-lang-val-list-$filetag.html*
    - **procedures**: 
        *    **q-string**: (command-line)
	*    **generate-query**: sparql/templates/lang-prop-val-list.template
	*    **format-response**:  pl/lang-prop-val-list-tsv2table.pl $response $filetag

10. **generate-lex-lists.sh**: [TO BE REVISED: Current version calls xml2html-lexlist.xsl to generate from the LANG-pdgms.xml file an html file, tmp/lexlists/$lang-lexlist.html, of all lexemes and muterms in \<dir>\; need version for edn2html to be used for updating and standardizing lexical information in edn file.]
    - **usage**: bin/generate-lang-prop-val-lists.sh \<dir\> 
    - **example**: *generate-lex-lists.sh "data/beja-arteiga data/beja-atmaan data/beja-beniamer data/beja-bishari data/beja-hadendowa" .
    - **procedures**: 
        *    **q-string**:

	*    **generate-query**:

	*    **format-response**:          

11. **generate-pdgms.sh**: [TO BE REVISED: Current version calls xml2html-pdgms.xsl to generate from the LANG-pdgms.xml file an html file, LANG-pdgms.html, of all pdgms in \<dir>\; need version for edn2html to be used for updating and standardizing lexical information in edn file.]
    - **usage**: bin/generate-pdgms-html.sh \<dir\> 
    - **example**: *generate-pdgms-html.sh "data/beja-arteiga data/beja-atmaan data/beja-beniamer data/beja-bishari data/beja-hadendowa" .
    - **procedures**: 
        *    **q-string**:

	*    **generate-query**:

	*    **format-response**:          



