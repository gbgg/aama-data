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
