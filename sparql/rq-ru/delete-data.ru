# 1. DELETE ALL TRIPLES	

		
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>

DELETE
{
	?s ?p ?o
}
WHERE
{
	?s  ?p ?o 
}

# 2. DELETE TRIPLES & PIDS BELONGING TO A GIVEN LANG

	#2a. First get rid of pids
	
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>

DELETE
{
	?pid ?p ?o 
}
WHERE
{
	?pid ?p ?o .
	?s aama:pid ?pid .
	?s aama:lang aama:beja .
}
	
	#2b. Then get rid of everything else

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>

DELETE
{
	?s ?p ?o 
}
WHERE
{
	?s ?p ?o .
	?s aama:lang aama:beja .
}
	