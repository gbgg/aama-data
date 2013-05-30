    fuquery.sh - generates a language-specific sparql query from
    <aama>/sparql/templates/*.template, then runs it.  E.g.:

        <aama>/tools/fuquery.sh data/afar sparql/templates/exponents.template

	Generates and runs <aama>/sparql/exponents.afar.rq

    qry*.sh - run specific hardcoded queries, e.g. qrylangs.sh lists all languages.
Revision/expansion by gbgg 05.27.13:

Original (greynolds) templates are: properties.template and exponents.template, which give properties.lang.rq and exponents.lang.rq when fuquery.sh dir query is run.

Other templates are to be run by fuquery-pref.sh, and presuppose use of [lang]:/[Lang]: prefixes.