# aama #

Afro-Asiatic Morphological Archive
--------------------------------------------------------
08/10/13
Afro-Asiatic Morphological Archive:

You are currently looking at aama-data, which will be the temporary repository for revised language data while questions of format are being formalized. The  current best data for each language is kept in the github/aama organization, where each language has its own repository. The reference file-format is edn (LANG-pdgms.edn).

In the absence of a UI (but cf. aama-capp in https://github.com/sibawayhi/aama-capp), command-line scripts for querying the archive will be found in aama/bin -- see bin/README.md. 	

In the current revised data-set, note:
	1. For each language single lc, 3-character ns prefix is used for the URI of language-specific morphosyntactic properties and values. List of proposed prefixes will be found in bin/lname-pref.txt.
	2. URIs of archive-wide morphosyntactic properties (e.g., "lang", "gloss", "lemma" . . .) are assigned the ns prefix "aamas:".
	3. Other URIs, in particular entity IDs, have ns prefix "aama:"
	4. Inference procedures and notations are being developed and incorporated to associate language-specific properties and values, e.g. "orm:Present", with general morphosyntactic properties and values, e.g. "aamas:Present".
	5. Among the important entity-types are:
			a. Terms
			b. Lexemes (or "l-terms"): e.g. "ktb 'write'".
			c. Muterms ("m-terms",  "µ-terms"): e.g. "PRO".
	6. Every Term is associated with either a Lexeme or a Muterm. In exceptional cases a term involved in a "paradigm" which is not a term-cluster but rather a cross-classification table is associated instead with a "classLabel". (cf. Arbore, "Sentence Focus Types")
	7. Lexemes are registered in the archive in a conventional "short form", with summary lemma, gloss, and other relevant morphosyntactic information.
	8. In the present state of the archive, where the data-source does not provide an easily usable lexeme, a provisional "dummy" lexeme is generated (by bin/lexadd.sh). As data-revision and language research goes on, these "dummy" lexemes will be gradually replaced by conventional ones.
	9. Muterms are registered in an experimental format calqued on that used for lexemes.



---------------------------------------------------------------------------------

# Data #

See http://jena.apache.org/documentation/tools/eyeball-getting-started.html

# Fuseki Administration #

    * fuseki http://jena.apache.org/documentation/serving_data/index.html

Current state of the data can be best followed on branch lang-data-rev. Introductory information about the project will be found in the directory aama/docs/slides, and a DocBook-style overview of the data as it existed in February, 2013, in aama/docs/docbook/AAMADocumentation.html.

Otherwise the data is in the process of progressive revision, and the contents of any subdirectory can change from day to day.

06/10/2013: In a major reinterpretation of aama morpho-syntactic terminology, all morpho-syntactic properties and values will in the first instance be designated with language-specific URIs. Thus, for the tam (tense-aspect-mood) property in Oromo, instead of a URI:
	<http://id.oi.uchicago.edu/aama/2013/tam>
abbreviated:
	aama:tam
there will be systematically a URI:
	<http://id.oi.uchicago.edu/aama/2013/oromo/tam>
abbreviated:
	orm:tam
Similarly for the tam value "Present"  instead of:
	<http://id.oi.uchicago.edu/aama/2013/Present>
abbreviated:
	aama:Present
We will have:
	<http://id.oi.uchicago.edu/aama/2013/oromo/Present>
abbreviated:
	orm:Present
with prefixes defined as follows:
	@prefix aama:	 <http://id.oi.uchicago.edu/aama/2013/> .
	@prefix orm:   <http://id.oi.uchicago.edu/aama/2013/oromo/> .

As the archive develops, some language-specific URIs may be supplemented or replaced by archive wide (i.e., aama:-prefixed) URIs, especially for morphosyntactic properties which are essentially identical across the archive (e.g. aama:tam), even if values (e.g., Beja "Aorist) may remain language-specific).

For the moment a list of language-specific prefixes can be found in docs/lname-pref.txt . (This list is also incorporated into the language-specific paradigm information text, sparql/pdgms/pdgm-finite-props.txt, used by the script pl/qstring2query.pl which is invoked by bin/pdgm-display.sh to make a pdgm-disply query out of a command-line lang+prop+val. . . string).

For inference and query purposes the lack of an archive-wide, e.g., aama:tam, can be compensated for by use of the rdfs:subPropertyOf predicate, as explained in 
docs/subproperties-in-named-graphs.txt.
