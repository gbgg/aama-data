# Insert values into a datastore

PREFIX rdf:	 <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs:	 <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama:	 <http://id.oi.uchicago.edu/aama/2013/>
PREFIX aamas:	 <http://id.oi.uchicago.edu/aama/2013/schema/>
PREFIX aamag:	 <http://id.oi.uchicago.edu/aama/2013/graph/>
PREFIX orm:   <http://id.oi.uchicago.edu/aama/2013/oromo/>
PREFIX bar:   <http://id.oi.uchicago.edu/aama/2013/beja-arteiga/>

INSERT DATA 
{ 
  # oromo
  GRAPH aamag:oromo
  {
		aamag:oromo rdfs:label "oromo-g" .
  }

  # beja-arteiga
  GRAPH aamag:beja-arteiga
  {
		aamag:beja-arteiga rdfs:label "beja-arteiga-g" .
  }

}
