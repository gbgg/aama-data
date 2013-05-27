0. First test
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>
PREFIX aamaLang:  <http://oi.uchicago.edu/aama/Language#>

SELECT DISTINCT ?language  ?aamaLang ?aamaLangLabel
WHERE
{ 	
	?s aama:lang ?lang .
	?lang rdfs:label ?language .
	BIND (CONCAT(UCASE(SUBSTR(str(?language),1,1)), SUBSTR(str(?language), 2, STRLEN(?language) - 1)) AS ?langName)
	BIND (CONCAT("<http://oi.uchicago.edu/aama/Language#", ?langName, ">") AS ?aamaLang)
	BIND (SUBSTR(str(?aamaLang),39, STRLEN(?aamaLang) - 39) AS ?aamaLangLabel)
}
ORDER BY ?aamaLang

1. First handle langs with langVar
  
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>
PREFIX aamaLang:  <http://oi.uchicago.edu/aama/Language#>

DELETE
{ 	?s aama:lang ?lang .
	?s aama:langVar  ?langVar . }
INSERT
{ ?s aama:termSet ?aamaLang }
WHERE
{ 	
	?s aama:lang ?lang .
	?lang rdfs:label ?language .
	?s aama:langVar  ?langVar .
	?langVar rdfs:label ?languageVar .
	BIND (CONCAT(UCASE(SUBSTR(str(?language),1,1)), SUBSTR(str(?language), 2, STRLEN(?language) - 1)) AS ?langName)
	BIND (CONCAT("<http://oi.uchicago.edu/aama/Language#", ?langName, "-", ?languageVar, ">") AS ?aamaLang)
}

2. Then langs w/o langVar

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>
PREFIX aamaLang:  <http://oi.uchicago.edu/aama/Language#>

DELETE
{ 	?s aama:lang ?lang .}
INSERT
{ ?s aama:termSet ?aamaLang }
WHERE
{ 	
	?s aama:lang ?lang .
	?lang rdfs:label ?language .
	BIND (CONCAT(UCASE(SUBSTR(str(?language),1,1)), SUBSTR(str(?language), 2, STRLEN(?language) - 1)) AS ?langName)
	BIND (CONCAT("<http://oi.uchicago.edu/aama/Language#", ?langName, ">") AS ?aamaLang)
}

3. Then do aamaLang rdfs:label (the SUBSTR function cuts off the initial prefix and the final ">")

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>
PREFIX aamaLang:  <http://oi.uchicago.edu/aama/Language#>

INSERT
{ ?aamaLang rdfs:label  ?aamaLangLabel}
WHERE
{ 	
	?s aama:termSet ?aamaLang .
	BIND (SUBSTR(str(?aamaLang),39, STRLEN(?aamaLang) - 39) AS ?aamaLangLabel)
}
