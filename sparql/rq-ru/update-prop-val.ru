# 1. REPLACE ALL INSTANCES OF PROPERTY

		
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>

DELETE
{ ?s aama:formClass ?o }
INSERT
{ ?s aama:nonFiniteForm ?o }
WHERE
{ ?s aama:formClass ?o }


# 2. REPLACE ALL INSTANCES OF PROPERTY WITH GIVEN VALUE

		
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>

DELETE
{ ?s aama:dialect aama:Amar?ar }
INSERT
{ ?s aama:langVar aama:Amar?ar }
WHERE
{ ?s aama:dialect aama:Amar?ar }



# 3. REPLACE BOTH PROPERTY AND VALUE

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>

DELETE
{ ?s aama:conj aama:suff }
INSERT
{ ?s aama:conjClass aama:suffix }
WHERE
{ ?s aama:conj aama:suff }


# 4. REPLACE VALUE FOR GIVEN PROPERTY

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>

DELETE
{ ?s aama:dervStem aama:passive }
INSERT
{ ?s aama:dervStem aama:M }
WHERE
{ ?s aama:dervStem aama:passive }


# 5. REPLACE ALL INSTANCES OF VALUE 

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>

DELETE
{ ?s aama:dervStem aama:passive }
INSERT
{ ?s aama:dervStem aama:M }
WHERE
{ ?s aama:dervStem aama:passive }

#6. REPLACE FAULTY PREFIX (http:-/oi.uchicago.edu/aama/schema/2010#
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>

DELETE
	{ ?s ?p ?o . }
INSERT
	{ ?s ?pterm ?o . }
WHERE
{ 
	  ?s ?p ?o .
	   FILTER (regex(str(?p), "-/oi.uchicago.edu")) .
	   BIND ( CONCAT("<http://oi.uchicago.edu/aama/schema/2010#", SUBSTR(str(?p), 41)) AS ?pterm)
}

