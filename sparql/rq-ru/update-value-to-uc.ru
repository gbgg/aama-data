1. First test

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>

SELECT DISTINCT ?propertyLabel ?newValue ?newLabel
WHERE 
{
   ?s ?p ?value .
   ?p rdfs:label ?propertyLabel .
   ?value rdfs:label ?valueLabel .
   	BIND (CONCAT(UCASE(SUBSTR(str(?valueLabel),1,1)), SUBSTR(str(?valueLabel), 2, STRLEN(?valueLabel) - 1)) AS ?newValueLabel)
	BIND (CONCAT("<http://oi.uchicago.edu/aama/schema/2010#", ?newValueLabel, ">") AS ?newValue)
	BIND (SUBSTR(str(?newValue),42, STRLEN(?newValue) - 42) AS ?newLabel)
}
		
2. Then update values to uc

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>
PREFIX aamaLang:  <http://oi.uchicago.edu/aama/Language#>

DELETE
{ 	?s ?p ?value . }
INSERT
{ ?s ?p ?newValue }
WHERE
{ 	
   ?s ?p ?value .
   ?p rdfs:label ?property .
   ?value rdfs:label ?valueLabel .
   	BIND (CONCAT(UCASE(SUBSTR(str(?valueLabel),1,1)), SUBSTR(str(?valueLabel), 2, STRLEN(?valueLabel) - 1)) AS ?newValueLabel)
	BIND (CONCAT("<http://oi.uchicago.edu/aama/schema/2010#", ?newValueLabel, ">") AS ?newValue)
}

3. Then insert rdfs:label

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>
PREFIX aamaLang:  <http://oi.uchicago.edu/aama/Language#>

INSERT
{ ?value rdfs:label  ?valueLabel}
WHERE
{ 	
	?s ?p ?value .
	FILTER (regex(?value, "aama/schema/2010#")) .
	BIND (SUBSTR(str(?value),42, STRLEN(?value) - 42) AS ?valueLabel)
}


