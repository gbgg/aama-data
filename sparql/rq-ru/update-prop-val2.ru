PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>

DELETE
{ ?s aama:numeralGloss ?o .
  ?o rdfs:label ?value .  }
INSERT
{ ?s aama:numeralGloss ?value }
WHERE
{ ?s aama:numeralGloss ?o .
  ?o rdfs:label ?value .   }

  
