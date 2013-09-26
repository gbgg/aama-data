# Shell scripts (cf. * script-table.docx)

> Run the scripts from the aama home dir (called <aama> below).  In my case, ~/aama, so: $ bin/<script.sh>.

* constants.sh. Called by many scripts for location of fuseki, saxon, eyeball, etc.
* convert.sh converts data from ~/work/aamadata to ~/aama/data.

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
	*fuquery.sh - generates a language-specific sparql query from     <aama>/sparql/templates/*.template, then runs it.  E.g.:
			> <aama>/tools/fuquery.sh data/afar sparql/templates/exponents.template
			> Generates and runs <aama>/sparql/exponents.afar.rq
		* fuquery-default.sh
		* fuquery-gen.sh: runs SOH s-query on specific sparql query file. Cf. query files in sparql/rq-ru/ and sparql/pdgms).
		* fuquery-prop-val.sh: fuquery.sh with template specialized for list of props and vals in a language
		* fuquery-trial1.sh
		* fuquery-valsforprop.sh
		* fuqueries.sh: runs
			* listgraphs.sh: what named graphs are currently present in datastore?
			* count-triples.sh: how many triples are there in datastore?
		* pdgm-display.sh: cmd-line version, for a given lang, takes arg string [lang]+[property]=[value]:[property]=[value]:[property]=[value]: . . . Uses:
			* pl/qstring2query.pl: transforms input string to sparql query, which pdgm-display.sh submits to s-query
			* pl/pdgmtsv2table.pl: formats tsv response as table
		* pdgm-display-comp.sh: generalizes pdgm-display.sh to more than one language

============================================

## Data generating procedure, xml=>rdf (Modified: 09/19/2013)  

* eyeball.sh
* lname-pref.txt: contains abbreviations for languages

1. git checkout lang-data-rev [no longer create new branch for each lang]
2. Make html: bin/htmlgen.sh dir. Uses 
	* xml2html-pdgms.xsl
	* xml2html-pdgms-sort.xsl
3. Do first-pas bin/lexcheck-gg.sh dir, make sure every term cluster has a lexlabel, mulabel, or classlabel. Uses:
	* lexcheck-gg.xsl
	* Corrections:
		a. insert in each mu termcluster: <prop type="mulabel" val="[mulabel]"/>
		b. insert lexlabels where missing: <prop type="lexlabel" val="[lexlabel]"/>
		c. insert in each multiLex termcluster: <prop type="multiLex" val="[label]"/>
		d. identify certain tables as: <prop type="classification" val="[name]/>
		mark each terms with: <prop type="classlabel" val="[classlabel]"/>
4. Do second-pass bin/lexadd.sh dir. Uses:
		* lexadd.xsl
			* Program outputs newlex, mlex, and muterm entries in log file
				1. checks for valid lexlabel in termclusters, writes out newlex if not valid
				2. writes out a dummy multilex lexeme for each multilex termcluster
				3. checks for valid lexlabel in terms w/i multilex termduster, writes out newlex if not valid
				4. writes out dummy muterm entry for tennclusters with mulabel
		* edit dummy/tentative lexemes and add to xml
5. Fireup fuseki: bin/fuseki.sh
6. Generate .data.ttl/rdf: bin/datagen-gg.sh dir abbrev. Calls:
		* xml2data-gg.sh. Uses
				* xml2data-gg.xsl
		* data2rdf.sh
			* Variants:
				* data2rdf-aa.sh
				* datagen-aa.sh
				* xml2data-aa.sh
				* xml2data-aa.xsl
7. Generate .schema.ttl/rdf: bin/schemagen-gg.sh dir abbrev (includes fupost & fuquery). Calls:
	* xml2schema-gg.sh. Uses:
		* xml2schema-gg.xsl
	* uniqschema.sh
	* schema2rdf.sh 
	* fupost.sh
	* fuquery-gen.sh sparql/rq-ru/count-triples.rq
	* fuquery-gen.sh sparql/rq-ru/list-graphs.rq
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
