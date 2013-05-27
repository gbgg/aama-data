#1. Get all preds for inspection
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>

SELECT DISTINCT ?p 
WHERE 
{
   ?s ?p ?o .
   #?pred rdfs:label ?label .
   #BIND((SUBSTR(str(?s),41)) AS ?pred) .
   }
ORDER BY ?p 

#2. See what result of change would be

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX aama: <http://oi.uchicago.edu/aama/schema/2010#>

SELECT DISTINCT ?p ?pterm
WHERE
{ 
	  ?s ?p ?o .
	   FILTER (regex(str(?p), "-/oi")) .
	   BIND ( CONCAT("<http://oi.uchicago.edu/aama/schema/2010#", SUBSTR(str(?p), 41)) AS ?pterm)
}
ORDER BY ?p ?pterm 

SELECT DISTINCT ?p ?pterm
WHERE
{ 
	  ?s ?p ?o .
	   FILTER (regex(str(?p), '\"oi')) .
	   BIND ( CONCAT("<http://oi.uchicago.edu/aama/schema/2010#", SUBSTR(str(?p), 40)) AS ?pterm)
}
ORDER BY ?p ?pterm 

#3. Make change (?p here, same for ?o ?oterm)

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
	   FILTER (regex(str(?p), '\"oi.uchicago.edu')) .
	   BIND ( CONCAT("<http://oi.uchicago.edu/aama/schema/2010#", SUBSTR(str(?p), 40)) AS ?pterm)
}

-----------------------------------------------------------------------
| p                                                                   |
=======================================================================
| <http:\"oi.uchicago.edu/aama/schema/2010#case>                      |
| <http:\"oi.uchicago.edu/aama/schema/2010#dervStem>                  |
| <http:\"oi.uchicago.edu/aama/schema/2010#gen>                       |
| <http:\"oi.uchicago.edu/aama/schema/2010#gentoken>                  |
| <http:\"oi.uchicago.edu/aama/schema/2010#gentoken-negAux>           |
| <http:\"oi.uchicago.edu/aama/schema/2010#gloss>                     |
| <http:\"oi.uchicago.edu/aama/schema/2010#lang>                      |
| <http:\"oi.uchicago.edu/aama/schema/2010#lemma>                     |
| <http:\"oi.uchicago.edu/aama/schema/2010#lexlabel>                  |
| <http:\"oi.uchicago.edu/aama/schema/2010#morphClass>                |
| <http:\"oi.uchicago.edu/aama/schema/2010#nonMainForm>               |
| <http:\"oi.uchicago.edu/aama/schema/2010#num>                       |
| <http:\"oi.uchicago.edu/aama/schema/2010#number>                    |
| <http:\"oi.uchicago.edu/aama/schema/2010#pdgmlabel>                 |
| <http:\"oi.uchicago.edu/aama/schema/2010#pdgmnote>                  |
| <http:\"oi.uchicago.edu/aama/schema/2010#pers>                      |
| <http:\"oi.uchicago.edu/aama/schema/2010#person>                    |
| <http:\"oi.uchicago.edu/aama/schema/2010#pid>                       |
| <http:\"oi.uchicago.edu/aama/schema/2010#pol>                       |
| <http:\"oi.uchicago.edu/aama/schema/2010#polarity>                  |
| <http:\"oi.uchicago.edu/aama/schema/2010#pos>                       |
| <http:\"oi.uchicago.edu/aama/schema/2010#proClass>                  |
| <http:\"oi.uchicago.edu/aama/schema/2010#tnsAspMod>                 |
| <http:\"oi.uchicago.edu/aama/schema/2010#token>                     |
| <http:\"oi.uchicago.edu/aama/schema/2010#token-BeachyRef>           |
| <http:\"oi.uchicago.edu/aama/schema/2010#token-baseForm>            |
| <http:\"oi.uchicago.edu/aama/schema/2010#token-baseGloss>           |
| <http:\"oi.uchicago.edu/aama/schema/2010#token-dervForm>            |
| <http:\"oi.uchicago.edu/aama/schema/2010#token-dervGloss>           |
| <http:\"oi.uchicago.edu/aama/schema/2010#token-exA>                 |
| <http:\"oi.uchicago.edu/aama/schema/2010#token-exQ>                 |
| <http:\"oi.uchicago.edu/aama/schema/2010#token-glossExA>            |
| <http:\"oi.uchicago.edu/aama/schema/2010#token-glossExQ>            |
| <http:\"oi.uchicago.edu/aama/schema/2010#token-main>                |
| <http:\"oi.uchicago.edu/aama/schema/2010#token-remark>              |
| <http:\"oi.uchicago.edu/aama/schema/2010#token-structure>           |
| <http:\"oi.uchicago.edu/aama/schema/2010#verbMorphClass>            |
| <http:-/oi.uchicago.edu/aama/schema/2010#affirmationType>           |
| <http:-/oi.uchicago.edu/aama/schema/2010#case>                      |
| <http:-/oi.uchicago.edu/aama/schema/2010#clauseTypeSel>             |
| <http:-/oi.uchicago.edu/aama/schema/2010#deixis>                    |
| <http:-/oi.uchicago.edu/aama/schema/2010#dervStem>                  |
| <http:-/oi.uchicago.edu/aama/schema/2010#genHead>                   |
| <http:-/oi.uchicago.edu/aama/schema/2010#genObj>                    |
| <http:-/oi.uchicago.edu/aama/schema/2010#gender>                    |
| <http:-/oi.uchicago.edu/aama/schema/2010#gloss>                     |
| <http:-/oi.uchicago.edu/aama/schema/2010#gramFunction>              |
| <http:-/oi.uchicago.edu/aama/schema/2010#imprtvComponent>           |
| <http:-/oi.uchicago.edu/aama/schema/2010#lang>                      |
| <http:-/oi.uchicago.edu/aama/schema/2010#lemma>                     |
| <http:-/oi.uchicago.edu/aama/schema/2010#lexlabel>                  |
| <http:-/oi.uchicago.edu/aama/schema/2010#nounClass>                 |
| <http:-/oi.uchicago.edu/aama/schema/2010#numObj>                    |
| <http:-/oi.uchicago.edu/aama/schema/2010#numSubj>                   |
| <http:-/oi.uchicago.edu/aama/schema/2010#number>                    |
| <http:-/oi.uchicago.edu/aama/schema/2010#orientationSel>            |
| <http:-/oi.uchicago.edu/aama/schema/2010#pdgmLexLabel>              |
| <http:-/oi.uchicago.edu/aama/schema/2010#pdgmlabel>                 |
| <http:-/oi.uchicago.edu/aama/schema/2010#pdgmnote>                  |
| <http:-/oi.uchicago.edu/aama/schema/2010#persObj>                   |
| <http:-/oi.uchicago.edu/aama/schema/2010#person>                    |
| <http:-/oi.uchicago.edu/aama/schema/2010#pid>                       |
| <http:-/oi.uchicago.edu/aama/schema/2010#polarity>                  |
| <http:-/oi.uchicago.edu/aama/schema/2010#pos>                       |
| <http:-/oi.uchicago.edu/aama/schema/2010#posSubType>                |
| <http:-/oi.uchicago.edu/aama/schema/2010#predType>                  |
| <http:-/oi.uchicago.edu/aama/schema/2010#proClass>                  |
| <http:-/oi.uchicago.edu/aama/schema/2010#reference>                 |
| <http:-/oi.uchicago.edu/aama/schema/2010#selectorCategory>          |
| <http:-/oi.uchicago.edu/aama/schema/2010#selectorFormant>           |
| <http:-/oi.uchicago.edu/aama/schema/2010#stemClass>                 |
| <http:-/oi.uchicago.edu/aama/schema/2010#stemInflCategory>          |
| <http:-/oi.uchicago.edu/aama/schema/2010#stemInflMorpheme>          |
| <http:-/oi.uchicago.edu/aama/schema/2010#subjTypeSel>               |
| <http:-/oi.uchicago.edu/aama/schema/2010#tenseSel>                  |
| <http:-/oi.uchicago.edu/aama/schema/2010#tnsAspMod>                 |
| <http:-/oi.uchicago.edu/aama/schema/2010#token>                     |
| <http:-/oi.uchicago.edu/aama/schema/2010#token-formant-objShapes>   |
| <http:-/oi.uchicago.edu/aama/schema/2010#token-gloss>               |
| <http:-/oi.uchicago.edu/aama/schema/2010#token-note>                |
| <http:-/oi.uchicago.edu/aama/schema/2010#token-numerals>            |
| <http:-/oi.uchicago.edu/aama/schema/2010#token-selCat1>             |
| <http:-/oi.uchicago.edu/aama/schema/2010#token-selCat2>             |
| <http:-/oi.uchicago.edu/aama/schema/2010#token-selCat3>             |
| <http:-/oi.uchicago.edu/aama/schema/2010#token-selForm1>            |
| <http:-/oi.uchicago.edu/aama/schema/2010#token-selForm2>            |
| <http:-/oi.uchicago.edu/aama/schema/2010#token-selForm3>            |
| <http:-/oi.uchicago.edu/aama/schema/2010#token-subjSuff>            |
| <http:-/oi.uchicago.edu/aama/schema/2010#tokenSel>                  |
| <http:-/oi.uchicago.edu/aama/schema/2010#tokenSel-Negs>             |
| <http:-/oi.uchicago.edu/aama/schema/2010#tokenStemSuff>             |
| <http:-/oi.uchicago.edu/aama/schema/2010#tokenSuff>                 |
| <http:-/oi.uchicago.edu/aama/schema/2010#tokenVerb>                 |
| <http:-/oi.uchicago.edu/aama/schema/2010#type>                      |
| <http:-/oi.uchicago.edu/aama/schema/2010#verbMorphClass>            |
| <http://oi.uchicago.edu/aama/schema/2010#>                          |
| <http://oi.uchicago.edu/aama/schema/2010#VClass>                    |
| <http://oi.uchicago.edu/aama/schema/2010#ablautClass>               |
| <http://oi.uchicago.edu/aama/schema/2010#aspect>                    |
| <http://oi.uchicago.edu/aama/schema/2010#auxAdjunct>                |
| <http://oi.uchicago.edu/aama/schema/2010#case>                      |
| <http://oi.uchicago.edu/aama/schema/2010#caseHead>                  |
| <http://oi.uchicago.edu/aama/schema/2010#cat>                       |
| <http://oi.uchicago.edu/aama/schema/2010#categ>                     |
| <http://oi.uchicago.edu/aama/schema/2010#causSuff>                  |
| <http://oi.uchicago.edu/aama/schema/2010#causative1>                |
| <http://oi.uchicago.edu/aama/schema/2010#causative1Causative2>      |
| <http://oi.uchicago.edu/aama/schema/2010#causativeAllomorph>        |
| <http://oi.uchicago.edu/aama/schema/2010#clause>                    |
| <http://oi.uchicago.edu/aama/schema/2010#clauseCase>                |
| <http://oi.uchicago.edu/aama/schema/2010#clauseConjugation>         |
| <http://oi.uchicago.edu/aama/schema/2010#clauseMarker>              |
| <http://oi.uchicago.edu/aama/schema/2010#clauseType>                |
| <http://oi.uchicago.edu/aama/schema/2010#cliticClass>               |
| <http://oi.uchicago.edu/aama/schema/2010#cliticType>                |
| <http://oi.uchicago.edu/aama/schema/2010#cohesion>                  |
| <http://oi.uchicago.edu/aama/schema/2010#complement>                |
| <http://oi.uchicago.edu/aama/schema/2010#configuration>             |
| <http://oi.uchicago.edu/aama/schema/2010#conjClaspdgmLexs>          |
| <http://oi.uchicago.edu/aama/schema/2010#conjClass>                 |
| <http://oi.uchicago.edu/aama/schema/2010#conjSubClass>              |
| <http://oi.uchicago.edu/aama/schema/2010#conjSubType>               |
| <http://oi.uchicago.edu/aama/schema/2010#conjType>                  |
| <http://oi.uchicago.edu/aama/schema/2010#conjuctive>                |
| <http://oi.uchicago.edu/aama/schema/2010#copForm>                   |
| <http://oi.uchicago.edu/aama/schema/2010#copType>                   |
| <http://oi.uchicago.edu/aama/schema/2010#deAdjClass>                |
| <http://oi.uchicago.edu/aama/schema/2010#defClass>                  |
| <http://oi.uchicago.edu/aama/schema/2010#defMarker>                 |
| <http://oi.uchicago.edu/aama/schema/2010#deixis>                    |
| <http://oi.uchicago.edu/aama/schema/2010#demonstrative>             |
| <http://oi.uchicago.edu/aama/schema/2010#derived>                   |
| <http://oi.uchicago.edu/aama/schema/2010#dervCat>                   |
| <http://oi.uchicago.edu/aama/schema/2010#dervClass>                 |
| <http://oi.uchicago.edu/aama/schema/2010#dervStem>                  |
| <http://oi.uchicago.edu/aama/schema/2010#dervStemAug>               |
| <http://oi.uchicago.edu/aama/schema/2010#dimension>                 |
| <http://oi.uchicago.edu/aama/schema/2010#direction>                 |
| <http://oi.uchicago.edu/aama/schema/2010#emphatic>                  |
| <http://oi.uchicago.edu/aama/schema/2010#example>                   |
| <http://oi.uchicago.edu/aama/schema/2010#extended>                  |
| <http://oi.uchicago.edu/aama/schema/2010#final>                     |
| <http://oi.uchicago.edu/aama/schema/2010#finiteForm>                |
| <http://oi.uchicago.edu/aama/schema/2010#focus>                     |
| <http://oi.uchicago.edu/aama/schema/2010#focusType>                 |
| <http://oi.uchicago.edu/aama/schema/2010#form>                      |
| <http://oi.uchicago.edu/aama/schema/2010#formClass>                 |
| <http://oi.uchicago.edu/aama/schema/2010#gen>                       |
| <http://oi.uchicago.edu/aama/schema/2010#genHead>                   |
| <http://oi.uchicago.edu/aama/schema/2010#genObj>                    |
| <http://oi.uchicago.edu/aama/schema/2010#genPoss>                   |
| <http://oi.uchicago.edu/aama/schema/2010#genRef>                    |
| <http://oi.uchicago.edu/aama/schema/2010#gender>                    |
| <http://oi.uchicago.edu/aama/schema/2010#genderCop>                 |
| <http://oi.uchicago.edu/aama/schema/2010#genderHead>                |
| <http://oi.uchicago.edu/aama/schema/2010#genderHeadRel>             |
| <http://oi.uchicago.edu/aama/schema/2010#genderN1>                  |
| <http://oi.uchicago.edu/aama/schema/2010#genderN2>                  |
| <http://oi.uchicago.edu/aama/schema/2010#genderObj>                 |
| <http://oi.uchicago.edu/aama/schema/2010#genderP1>                  |
| <http://oi.uchicago.edu/aama/schema/2010#gloss>                     |
| <http://oi.uchicago.edu/aama/schema/2010#headGen>                   |
| <http://oi.uchicago.edu/aama/schema/2010#headNoun>                  |
| <http://oi.uchicago.edu/aama/schema/2010#headPosition>              |
| <http://oi.uchicago.edu/aama/schema/2010#imperativeForm>            |
| <http://oi.uchicago.edu/aama/schema/2010#imprtvClass>               |
| <http://oi.uchicago.edu/aama/schema/2010#infinitiveClass>           |
| <http://oi.uchicago.edu/aama/schema/2010#infinitiveForm>            |
| <http://oi.uchicago.edu/aama/schema/2010#infinitiveVar>             |
| <http://oi.uchicago.edu/aama/schema/2010#infinitivetoken>           |
| <http://oi.uchicago.edu/aama/schema/2010#inflClass>                 |
| <http://oi.uchicago.edu/aama/schema/2010#interrClass>               |
| <http://oi.uchicago.edu/aama/schema/2010#lang>                      |
| <http://oi.uchicago.edu/aama/schema/2010#langComp>                  |
| <http://oi.uchicago.edu/aama/schema/2010#langVar>                   |
| <http://oi.uchicago.edu/aama/schema/2010#lemma>                     |
| <http://oi.uchicago.edu/aama/schema/2010#lexlabel>                  |
| <http://oi.uchicago.edu/aama/schema/2010#lexnote>                   |
| <http://oi.uchicago.edu/aama/schema/2010#mainStem>                  |
| <http://oi.uchicago.edu/aama/schema/2010#middleClass>               |
| <http://oi.uchicago.edu/aama/schema/2010#modal>                     |
| <http://oi.uchicago.edu/aama/schema/2010#mood>                      |
| <http://oi.uchicago.edu/aama/schema/2010#morphClass>                |
| <http://oi.uchicago.edu/aama/schema/2010#morphoSynEnv>              |
| <http://oi.uchicago.edu/aama/schema/2010#nomForm>                   |
| <http://oi.uchicago.edu/aama/schema/2010#nonFiniteForm>             |
| <http://oi.uchicago.edu/aama/schema/2010#note>                      |
| <http://oi.uchicago.edu/aama/schema/2010#nounClass>                 |
| <http://oi.uchicago.edu/aama/schema/2010#nounMorphClass>            |
| <http://oi.uchicago.edu/aama/schema/2010#npg>                       |
| <http://oi.uchicago.edu/aama/schema/2010#num>                       |
| <http://oi.uchicago.edu/aama/schema/2010#numClass>                  |
| <http://oi.uchicago.edu/aama/schema/2010#numCop>                    |
| <http://oi.uchicago.edu/aama/schema/2010#numHead>                   |
| <http://oi.uchicago.edu/aama/schema/2010#numHeadRel>                |
| <http://oi.uchicago.edu/aama/schema/2010#numN1>                     |
| <http://oi.uchicago.edu/aama/schema/2010#numObj>                    |
| <http://oi.uchicago.edu/aama/schema/2010#numP1>                     |
| <http://oi.uchicago.edu/aama/schema/2010#numP2>                     |
| <http://oi.uchicago.edu/aama/schema/2010#numPersGender>             |
| <http://oi.uchicago.edu/aama/schema/2010#numPoss>                   |
| <http://oi.uchicago.edu/aama/schema/2010#numRef>                    |
| <http://oi.uchicago.edu/aama/schema/2010#numSubj>                   |
| <http://oi.uchicago.edu/aama/schema/2010#number>                    |
| <http://oi.uchicago.edu/aama/schema/2010#numberGender>              |
| <http://oi.uchicago.edu/aama/schema/2010#numberGenderHead>          |
| <http://oi.uchicago.edu/aama/schema/2010#numberHead>                |
| <http://oi.uchicago.edu/aama/schema/2010#numeralGloss>              |
| <http://oi.uchicago.edu/aama/schema/2010#numgen>                    |
| <http://oi.uchicago.edu/aama/schema/2010#objectGender>              |
| <http://oi.uchicago.edu/aama/schema/2010#objectNumber>              |
| <http://oi.uchicago.edu/aama/schema/2010#objectPerson>              |
| <http://oi.uchicago.edu/aama/schema/2010#objectType>                |
| <http://oi.uchicago.edu/aama/schema/2010#participle>                |
| <http://oi.uchicago.edu/aama/schema/2010#passiveReciprocalClass>    |
| <http://oi.uchicago.edu/aama/schema/2010#patternClass>              |
| <http://oi.uchicago.edu/aama/schema/2010#pdgmClass>                 |
| <http://oi.uchicago.edu/aama/schema/2010#pdgmLexLabel>              |
| <http://oi.uchicago.edu/aama/schema/2010#pdgmSubType>               |
| <http://oi.uchicago.edu/aama/schema/2010#pdgmType>                  |
| <http://oi.uchicago.edu/aama/schema/2010#pdgmlabel>                 |
| <http://oi.uchicago.edu/aama/schema/2010#pdgmnote>                  |
| <http://oi.uchicago.edu/aama/schema/2010#pers>                      |
| <http://oi.uchicago.edu/aama/schema/2010#persCop>                   |
| <http://oi.uchicago.edu/aama/schema/2010#persObj>                   |
| <http://oi.uchicago.edu/aama/schema/2010#persP1>                    |
| <http://oi.uchicago.edu/aama/schema/2010#persP2>                    |
| <http://oi.uchicago.edu/aama/schema/2010#persSubj>                  |
| <http://oi.uchicago.edu/aama/schema/2010#person>                    |
| <http://oi.uchicago.edu/aama/schema/2010#pid>                       |
| <http://oi.uchicago.edu/aama/schema/2010#pluralClass>               |
| <http://oi.uchicago.edu/aama/schema/2010#pngSet>                    |
| <http://oi.uchicago.edu/aama/schema/2010#pngShapeClass>             |
| <http://oi.uchicago.edu/aama/schema/2010#pol>                       |
| <http://oi.uchicago.edu/aama/schema/2010#polaff>                    |
| <http://oi.uchicago.edu/aama/schema/2010#polarity>                  |
| <http://oi.uchicago.edu/aama/schema/2010#pos>                       |
| <http://oi.uchicago.edu/aama/schema/2010#posClass>                  |
| <http://oi.uchicago.edu/aama/schema/2010#posHead>                   |
| <http://oi.uchicago.edu/aama/schema/2010#position>                  |
| <http://oi.uchicago.edu/aama/schema/2010#possType>                  |
| <http://oi.uchicago.edu/aama/schema/2010#postposition>              |
| <http://oi.uchicago.edu/aama/schema/2010#postpositionClass>         |
| <http://oi.uchicago.edu/aama/schema/2010#prefix>                    |
| <http://oi.uchicago.edu/aama/schema/2010#prefixGroup>               |
| <http://oi.uchicago.edu/aama/schema/2010#present>                   |
| <http://oi.uchicago.edu/aama/schema/2010#proClass>                  |
| <http://oi.uchicago.edu/aama/schema/2010#proClasspolarity>          |
| <http://oi.uchicago.edu/aama/schema/2010#proClasspos>               |
| <http://oi.uchicago.edu/aama/schema/2010#proSet>                    |
| <http://oi.uchicago.edu/aama/schema/2010#proType>                   |
| <http://oi.uchicago.edu/aama/schema/2010#pronounClass>              |
| <http://oi.uchicago.edu/aama/schema/2010#rootClass>                 |
| <http://oi.uchicago.edu/aama/schema/2010#rootStructure>             |
| <http://oi.uchicago.edu/aama/schema/2010#selBE>                     |
| <http://oi.uchicago.edu/aama/schema/2010#selCat>                    |
| <http://oi.uchicago.edu/aama/schema/2010#selClass>                  |
| <http://oi.uchicago.edu/aama/schema/2010#selMood>                   |
| <http://oi.uchicago.edu/aama/schema/2010#selTense>                  |
| <http://oi.uchicago.edu/aama/schema/2010#selector>                  |
| <http://oi.uchicago.edu/aama/schema/2010#selectorGroup>             |
| <http://oi.uchicago.edu/aama/schema/2010#selectorPosition>          |
| <http://oi.uchicago.edu/aama/schema/2010#selectorProClass>          |
| <http://oi.uchicago.edu/aama/schema/2010#statClass>                 |
| <http://oi.uchicago.edu/aama/schema/2010#state>                     |
| <http://oi.uchicago.edu/aama/schema/2010#stem>                      |
| <http://oi.uchicago.edu/aama/schema/2010#stemAltClass>              |
| <http://oi.uchicago.edu/aama/schema/2010#stemClass>                 |
| <http://oi.uchicago.edu/aama/schema/2010#stemFin>                   |
| <http://oi.uchicago.edu/aama/schema/2010#stemFinalC>                |
| <http://oi.uchicago.edu/aama/schema/2010#stemPattern>               |
| <http://oi.uchicago.edu/aama/schema/2010#stemShape>                 |
| <http://oi.uchicago.edu/aama/schema/2010#stemType>                  |
| <http://oi.uchicago.edu/aama/schema/2010#strength>                  |
| <http://oi.uchicago.edu/aama/schema/2010#structAux>                 |
| <http://oi.uchicago.edu/aama/schema/2010#structMain>                |
| <http://oi.uchicago.edu/aama/schema/2010#structure>                 |
| <http://oi.uchicago.edu/aama/schema/2010#subConj>                   |
| <http://oi.uchicago.edu/aama/schema/2010#subconjClass>              |
| <http://oi.uchicago.edu/aama/schema/2010#subjIdent>                 |
| <http://oi.uchicago.edu/aama/schema/2010#subjVerbAgr>               |
| <http://oi.uchicago.edu/aama/schema/2010#suffSet>                   |
| <http://oi.uchicago.edu/aama/schema/2010#suffType>                  |
| <http://oi.uchicago.edu/aama/schema/2010#suppletion>                |
| <http://oi.uchicago.edu/aama/schema/2010#synEnv>                    |
| <http://oi.uchicago.edu/aama/schema/2010#tam>                       |
| <http://oi.uchicago.edu/aama/schema/2010#tamStemClass>              |
| <http://oi.uchicago.edu/aama/schema/2010#tamStemForm>               |
| <http://oi.uchicago.edu/aama/schema/2010#tamToken>                  |
| <http://oi.uchicago.edu/aama/schema/2010#templ>                     |
| <http://oi.uchicago.edu/aama/schema/2010#tense>                     |
| <http://oi.uchicago.edu/aama/schema/2010#tense1>                    |
| <http://oi.uchicago.edu/aama/schema/2010#tense2>                    |
| <http://oi.uchicago.edu/aama/schema/2010#tenseHead>                 |
| <http://oi.uchicago.edu/aama/schema/2010#tenseName>                 |
| <http://oi.uchicago.edu/aama/schema/2010#tensefutProx>              |
| <http://oi.uchicago.edu/aama/schema/2010#tnsAspMod>                 |
| <http://oi.uchicago.edu/aama/schema/2010#token>                     |
| <http://oi.uchicago.edu/aama/schema/2010#token-TAVowel1>            |
| <http://oi.uchicago.edu/aama/schema/2010#token-TAVowel2>            |
| <http://oi.uchicago.edu/aama/schema/2010#token-affix>               |
| <http://oi.uchicago.edu/aama/schema/2010#token-aspSuff>             |
| <http://oi.uchicago.edu/aama/schema/2010#token-aspectMarking>       |
| <http://oi.uchicago.edu/aama/schema/2010#token-aux>                 |
| <http://oi.uchicago.edu/aama/schema/2010#token-auxFunction>         |
| <http://oi.uchicago.edu/aama/schema/2010#token-auxGloss>            |
| <http://oi.uchicago.edu/aama/schema/2010#token-baseForm>            |
| <http://oi.uchicago.edu/aama/schema/2010#token-baseGloss>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-baseShape>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-beStem>              |
| <http://oi.uchicago.edu/aama/schema/2010#token-causGloss>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-causShape>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-caushape>            |
| <http://oi.uchicago.edu/aama/schema/2010#token-clauseSuff>          |
| <http://oi.uchicago.edu/aama/schema/2010#token-conjV>               |
| <http://oi.uchicago.edu/aama/schema/2010#token-coopGloss>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-coopShape>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-dervGloss>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-dervShape>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-encliticized>        |
| <http://oi.uchicago.edu/aama/schema/2010#token-environment>         |
| <http://oi.uchicago.edu/aama/schema/2010#token-environmet>          |
| <http://oi.uchicago.edu/aama/schema/2010#token-example>             |
| <http://oi.uchicago.edu/aama/schema/2010#token-final>               |
| <http://oi.uchicago.edu/aama/schema/2010#token-frequency>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-function>            |
| <http://oi.uchicago.edu/aama/schema/2010#token-genF>                |
| <http://oi.uchicago.edu/aama/schema/2010#token-genM>                |
| <http://oi.uchicago.edu/aama/schema/2010#token-gloss>               |
| <http://oi.uchicago.edu/aama/schema/2010#token-glossNote>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-lex>                 |
| <http://oi.uchicago.edu/aama/schema/2010#token-main>                |
| <http://oi.uchicago.edu/aama/schema/2010#token-medialVow>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-note>                |
| <http://oi.uchicago.edu/aama/schema/2010#token-notes>               |
| <http://oi.uchicago.edu/aama/schema/2010#token-numGloss>            |
| <http://oi.uchicago.edu/aama/schema/2010#token-numPers>             |
| <http://oi.uchicago.edu/aama/schema/2010#token-occurrences>         |
| <http://oi.uchicago.edu/aama/schema/2010#token-onlyVerb>            |
| <http://oi.uchicago.edu/aama/schema/2010#token-passGloss>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-passShape>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-pdgmLex>             |
| <http://oi.uchicago.edu/aama/schema/2010#token-pers1>               |
| <http://oi.uchicago.edu/aama/schema/2010#token-pers2>               |
| <http://oi.uchicago.edu/aama/schema/2010#token-pers2Basic>          |
| <http://oi.uchicago.edu/aama/schema/2010#token-pers2Past>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-persObj>             |
| <http://oi.uchicago.edu/aama/schema/2010#token-personMarkingFull>   |
| <http://oi.uchicago.edu/aama/schema/2010#token-personReduced>       |
| <http://oi.uchicago.edu/aama/schema/2010#token-pluralForm>          |
| <http://oi.uchicago.edu/aama/schema/2010#token-pref>                |
| <http://oi.uchicago.edu/aama/schema/2010#token-prefix>              |
| <http://oi.uchicago.edu/aama/schema/2010#token-preverb>             |
| <http://oi.uchicago.edu/aama/schema/2010#token-recipGloss>          |
| <http://oi.uchicago.edu/aama/schema/2010#token-recipShape>          |
| <http://oi.uchicago.edu/aama/schema/2010#token-reflGloss>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-reflShape>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-selBE>               |
| <http://oi.uchicago.edu/aama/schema/2010#token-selMood>             |
| <http://oi.uchicago.edu/aama/schema/2010#token-selTense>            |
| <http://oi.uchicago.edu/aama/schema/2010#token-selector>            |
| <http://oi.uchicago.edu/aama/schema/2010#token-selectorConst>       |
| <http://oi.uchicago.edu/aama/schema/2010#token-singularForm>        |
| <http://oi.uchicago.edu/aama/schema/2010#token-stem>                |
| <http://oi.uchicago.edu/aama/schema/2010#token-stemFinGem>          |
| <http://oi.uchicago.edu/aama/schema/2010#token-stemVowel>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-structure>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-suff>                |
| <http://oi.uchicago.edu/aama/schema/2010#token-suffShape>           |
| <http://oi.uchicago.edu/aama/schema/2010#token-suffix>              |
| <http://oi.uchicago.edu/aama/schema/2010#token-suffixShapes>        |
| <http://oi.uchicago.edu/aama/schema/2010#token-template>            |
| <http://oi.uchicago.edu/aama/schema/2010#token-tense>               |
| <http://oi.uchicago.edu/aama/schema/2010#token-translation>         |
| <http://oi.uchicago.edu/aama/schema/2010#token-vStem>               |
| <http://oi.uchicago.edu/aama/schema/2010#token-varPref>             |
| <http://oi.uchicago.edu/aama/schema/2010#token-verbGloss>           |
| <http://oi.uchicago.edu/aama/schema/2010#token1>                    |
| <http://oi.uchicago.edu/aama/schema/2010#token2>                    |
| <http://oi.uchicago.edu/aama/schema/2010#tokenAux>                  |
| <http://oi.uchicago.edu/aama/schema/2010#tokenMain>                 |
| <http://oi.uchicago.edu/aama/schema/2010#tokenPro>                  |
| <http://oi.uchicago.edu/aama/schema/2010#tokenSuff>                 |
| <http://oi.uchicago.edu/aama/schema/2010#tokenType>                 |
| <http://oi.uchicago.edu/aama/schema/2010#token_IMPRS_HIY>           |
| <http://oi.uchicago.edu/aama/schema/2010#tokentoken-aux1>           |
| <http://oi.uchicago.edu/aama/schema/2010#tokentoken-aux1token-aux2> |
| <http://oi.uchicago.edu/aama/schema/2010#transitivity>              |
| <http://oi.uchicago.edu/aama/schema/2010#transitivizingGloss>       |
| <http://oi.uchicago.edu/aama/schema/2010#type>                      |
| <http://oi.uchicago.edu/aama/schema/2010#vSubjSet>                  |
| <http://oi.uchicago.edu/aama/schema/2010#valence>                   |
| <http://oi.uchicago.edu/aama/schema/2010#varB>                      |
| <http://oi.uchicago.edu/aama/schema/2010#varClass>                  |
| <http://oi.uchicago.edu/aama/schema/2010#verbClass>                 |
| <http://oi.uchicago.edu/aama/schema/2010#verbMorphClass>            |
| <http://oi.uchicago.edu/aama/schema/2010#verbType>                  |
| <http://oi.uchicago.edu/aama/schema/2010#voice>                     |
| <http://www.w3.org/1999/02/22-rdf-syntax-ns#type>                   |
| <http://www.w3.org/2000/01/rdf-schema#label>                        |
-----------------------------------------------------------------------
