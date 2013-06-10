aama
========

Afro-Asiatic Morphological Archive

Dependencies:

    * fuseki http://jena.apache.org/documentation/serving_data/index.html

Current state of the data can be best followed on branch dev-aama. Introductory information about the project will be found in the directory aama/docs/slides, and a DocBook-style overview of the data as it existed in February, 2013, in aama/docs/docbook/AAMADocumentation.html.

Otherwise the data is in the process of progressive revision, and the contents of any subdirectory can change from day to day.

06/10/2013: In a major reinterpretation of aama morpho-syntactic terminology, all morpho-syntactic properties and values will in the first instance be designated with language-specific URIs. Thus, for the tam (tense-aspect-mood) property in Oromo, instead of a URI:
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