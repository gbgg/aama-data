Generating data:

Run the scripts from the aama home dir (called <aama> below).  In my case, ~/aama, so: $
tools/<script.sh>.

    convert.sh converts data from ~/work/aamadata to ~/aama/data.

    datagen.sh generates ttl from <aama>/data/<lang>/<lang>-pdgms.xml
    to <aama>/data/<lang>/<lang>.data.ttl

    schemagen.sh generates language-specific schema data from
    <aama>/data/<lang>/<lang>-pdgms.xml to
    <aama>/data/<lang>/<lang>.schema.ttl and then loads it into the
    database.  This script runs four others.

    fupost.sh, fudelete,sh, etc. - scripts controlling fuseki SOH

    fuquery.sh - generates a language-specific sparql query from
    <aama>/sparql/templates/*.template, then runs it.  E.g.:

        <aama>/tools/fuquery.sh data/afar sparql/templates/exponents.template

	Generates and runs <aama>/sparql/exponents.afar.rq

    qry*.sh - run specific hardcoded queries, e.g. qrylangs.sh lists all languages.

To use the fuseki SOH tools for e.g. bulk loading data (s-post) the
data must be in RDF/XML.  Use tools/n3tordf.sh to convert the n3 files
to rdf/xml.  Then use rdf2fuseki.sh to load.

Use fuclear to drop the default graph.

============================================

05/10/2013: Modified data generating procedure:

1.	git checkout (-b) [lang]; git merge dev
2.	Make html: bin/htmlgen.sh dir
3.	Do first-pass  bin/lexcheck.sh dir, make sure every term has a lexlabel or mulabel. Corrections:
	a.	create muterms/muterm section, insert muterms with mulabel LABEL and id _[LANG]LABEL
	b.	insert  missing lexlabels :
		i.	each lexical termcluster: <prop type="lexlabel" val="[lexlabel]"/>
		ii.	multiLex termclusters 
			1.	Mark termclusters with <prop type="multiLex" val=[name]>
			2.	mark each term with <prop type="lexlabel" val="[lexlabel]"/>
4.	Do second-pass bin/lexadd.sh dir; 
	a.	make sure every lexlabel is associated with a lexeme
	b.	create dummy/tentative lexemes in log file, edit and add to xml
5.	Fireup fuseki: bin/fuseki.sh
6.	Generate .data.ttl/rdf: bin/datagen.sh dir abbrev
7.	Generate .schema.ttl/rdf: bin/schemagen.sh dir abbrev
8.	(bin/fuput-all.sh or manual upload)
9.	Regenerate bin/htmlgen.sh dir
10.	git add/commit until git status is clean
11.	close files in notepad++ and oxygen
12.	git checkout dev,  git merge [lang]
13.	git push origin [lang]
