# Templates

Templates are skeleton sparql queries designed to run on one or more (or all) named graphs in the aama datastore. They are run by the shell script fuquery.sh which takes as first argument one or more data/LANG directories (or all -- data/*) and as second argument a template file name. fuquery.sh - generates a language-specific sparql query from   <aama>/sparql/templates/*.template, then runs it.  E.g.:

> <aama>/tools/fuquery.sh data/afar sparql/templates/exponents.template
> 	Generates and runs <aama>/sparql/exponents.afar.rq

For more complicated templates, or where special output formatting is required, a specialized fuqery(- . . .).sh has been developed: e.g., fuquery-prop-val.sh, which runs the propval.template. 

The script fuquery-gen.sh runs a specific query (.rq file) directly without passing through a template. fuqueries.sh runs a set of hard-coded rq files for test purposes (for the moment count-triples.rq, to see the number of triples in the archive, and list-graphs.rq, for the list of named graphs currently in the archive).

## Current Templates 
1. properties.template (gr): gives properties.LANG.rq 

2. exponents.template (gr): gives exponents.LANG.rq
 
3. propval.template: run by fuquery-prop-val.sh. Output to tmp/prop-val. Generates propval.LANG.rq, which gives propval.LANG-resp.tsv, formatted by a perl script into propval.LANG.txt, a table of the properties and values attested in the requested graphs.

4. class.template

5. classUsed.template

6. lexeme.template: lexeme list for requested lang graphs.

7. lexlemma.template

8. propertiesUsed.template

9. subproperties.template

