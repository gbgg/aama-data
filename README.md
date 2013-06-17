# aama #

Afro-Asiatic Morphological Archive

# Data #

See http://jena.apache.org/documentation/tools/eyeball-getting-started.html

# Fuseki Administration #

    * fuseki http://jena.apache.org/documentation/serving_data/index.html

A sample fuseki config file is in etc/aamaconfig.ttl.  To use it, copy
it to the fuseki dir, edit, and run

    $ fuseki-server --config aamaconfig.ttl

## Fuseki data administration ##

Use fuseki's [SOH (Sparql Over HTTP) tools](http://jena.apache.org/documentation/serving_data/soh.html "SOH").  The bin subdirectory contains some shell scripts  (prefixed with "fu") to make this easier.

A useful development pattern is to run cycles of

1. fuclear.sh - delete data
2. fupost.sh  - load data
3. fulangs.sh, fugraphs.sh - confirm data was uploaded
4. ... queries ...  - run your queries

### Loading data ###

* fupost.sh uploads data using HTTP POST.  Note that result code "204
  No Content" means success; "no content" means no content is returned
  with the result code, not that no content was uploaded.  **NB**
  *Each language has its own graph uri.  Ex. Oromo data is in the
  graph named by http://oi.uchicago.edu/aama/oromo.

* fuput.sh uses HTTP PUT instead of POST.

### Deleting data ###

See http://www.w3.org/TR/sparql11-update/#clear

* fuclear.sh "clears" (i.e. deletes) triples.

** fuclear.sh DEFAULT clears the default graph.
** fuclear.sh NAMED clears all named graphs.
** fuclear.sh <IRIref> clears the graph associated with the IRIref.
** fuclear.sh ALL is the nuclear option; it clears everything.

## Querying the triplestore ##

* qrylangs.sh returns a list of all languages represented in the store. It runs sparql/langs.rq, which selects everything whose rdf:type is aamas:Language.

# Current State of the Archive #

Current state of the data can be best followed on branch dev-aama. Introductory information about the project will be found in the directory aama/docs/slides, and a DocBook-style overview of the data as it existed in February, 2013, in aama/docs/docbook/AAMADocumentation.html.

Otherwise the data is in the process of progressive revision, and the contents of any subdirectory can change from day to day.

# Morpho-syntactic Property-Value URIs #

06/10/2013: In a major reinterpretation of aama morpho-syntactic terminology, all morpho-syntactic properties and values will in the first instance be designated with language-specific URIs. 

Thus, for the tam (tense-aspect-mood) property in Oromo, instead of a URI:
	<http://id.oi.uchicago.edu/aama/2013/tam>
abbreviated:
	aama:tam
there will be systematically a URI:
	<http://id.oi.uchicago.edu/aama/2013/oromo/tam>
abbreviated:
	orm:tam
Similarly for the tam value "Present" (note systematic use of capitalized terms for properties, as opposed to all lc terms vor values), instead of:
	<http://id.oi.uchicago.edu/aama/2013/Present>
abbreviated:
	aama:Present
We will have:
	<http://id.oi.uchicago.edu/aama/2013/Oromo/Present>
abbreviated:
	Orm:Present
with prefixes definted as follows:
	@prefix aama:	 <http://id.oi.uchicago.edu/aama/2013/> .
	@prefix orm:   <http://id.oi.uchicago.edu/aama/2013/oromo/> .
	@prefix Orm:   <http://id.oi.uchicago.edu/aama/2013/Oromo/> .

As the archive develops, some language-specific URIs may be supplemented or replaced by archive wide (i.e., aama:-prefixed) URIs, especially for morphosyntactic properties which are essentially identical across the archive (e.g. aama:tam), even if values (e.g., Beja "Aorist) may remain language-specific).

For the moment a list of language-specific prefixes can be found in docs/lname-pref.txt . (This list is also incorporated into the language-specific paradigm information text, sparql/pdgms/pdgm-finite-props.txt, used by the script pl/qstring2query.pl which is invoked by bin/pdgm-display.sh to make a pdgm-disply query out of a command-line lang+prop+val. . . string).

For inference and query purposes the lack of an archive-wide, e.g., aama:tam, can be compensated for by use of the rdfs:subPropertyOf predicate, as explained in 
       docs/subproperties-in-named-graphs.txt.