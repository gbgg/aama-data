(ns edn2ttl2.core
	(require [clojure.edn :as edn])
	(:gen-class))

(defn uuid 
"Generating random UUID for pdgm terms"
[]
(str (java.util.UUID/randomUUID)))

(defn -main
  "Calls the functions that transform the keyed maps of a pdgms.edn to a pdgms.ttl"
  [& file]
	(def inputfile (first file))
	(println "\n#TTL FROM INPUT FILE:\n#" inputfile)
	(def pdgmstring (slurp inputfile))
	(def pdgmmap (edn/read-string pdgmstring))
	(def lang (name (pdgmmap  :lang)))
	(def Lang (clojure.string/capitalize lang))
	(def sgpref (pdgmmap :sgpref))
	(def x ( map println [
			(format "\n#SCHEMATA:\n")
			(format "aama:%s a aamas:Language ." Lang)
			(format  "aama:%s rdfs:label \"%s\" ." Lang Lang)
		])
	)	
	(doall x)
	(def schemata (pdgmmap :schemata))
	(def morphemes (pdgmmap :morphemes))
	(def lexemes (pdgmmap :lexemes))
	(def lexterms (pdgmmap :lxterms))
	(doseq [[property valuelist] schemata]
		(def prop (name property))
		;; NB clojure.string/capitalize gives  wrong output with 
		;; terms like conjClass: =>Conjclass rather than ConjClass
		(def Prop (clojure.string/capitalize prop))
		(def x ( map println [
					(format "\n#SCHEMATA: %s" prop  )
					(format "%s:%s aamas:lang aama:%s ." sgpref prop Lang)
					(format "%s:%s aamas:lang aama:%s ." sgpref Prop Lang)
					(format "%s:%s rdfs:domain aamas:Term ." sgpref prop)
					(format "%s:%s rdfs:label \"%s exponents\" ." sgpref Prop prop)
					(format "%s:%s rdfs:label \"%s\" ." sgpref prop prop)
					(format "%s:%s rdfs:range %s:%s ." sgpref prop sgpref Prop)
					(format "%s:%s rdfs:subClassOf %s:MuExponent ." sgpref Prop sgpref)
					(format "%s:%s rdfs:subPropertyOf %s:muProperty ." sgpref prop sgpref )
			])
		)
		(doall  x)
		(def vallist valuelist)
		(doseq [value vallist] 
			(def valname (name value))
			(def y ( map println [
					(format "%s:%s aamas:lang aama:%s ." sgpref valname Lang)
					(format "%s:%s rdf:type %s:%s ." sgpref valname Lang Prop)
					(format "%s:%s rdfs:label \"%s\"." sgpref valname valname)
				])
			)
			(doall y)
		)
	)
	(println	(format "\n#MORPHEMES:\n"))
	(doseq [[morpheme featurelist] morphemes]
		(def morph (name morpheme))
		(def x ( map println [
				(format "aama:%s-%s a aamas:Muterm ;" Lang morph)
				(format "\taamas:lang aama:%s ;" Lang)
				(format "\trdfs:label \"%s\" ;" morph)
			])
		)
		(doall  x)
		(doseq [[feature value] featurelist] 
			(def mprop (name feature))
			(def mval (name value))
			(def y ( map println [
					(if (= mprop "gloss")
						(format "\trdfs:comment \"%s\" ;" mval)
						(format "\t%s:%s %s:%s ;" sgpref mprop sgpref mval)
					)
				])
			)
			(doall y)
		)
		(println "\t.")
	)
	(println	(format "\n#LEXEMES:\n"))
	(doseq [[lexeme featurelist] lexemes]
		(def lex (name lexeme))
		(def x ( map println [
				(format "aama:%s-%s a aamas:Lexeme ;" Lang lex)
				(format "\taamas:lang aama:%s ;" Lang)
				(format "\trdfs:label \"%s\" ;" lex)
			])
		)
		(doall  x)
		(doseq [[feature value] featurelist] 
			(def lprop (name feature))
			(def lval (name value))
			(def y ( map println [
					(if (= lprop "gloss")
						(format "\taamas:%s \"%s\" ;" lprop lval)
						(format "\t%s:%s %s:%s ;" sgpref lprop sgpref lval)
					)
				])
			)
			(doall y)
		)
		(println "\t.")
	)
	(doseq [ termcluster lexterms]
		(def label (:label termcluster))
		(def x (map println [
			(format "\n#TERMCLUSTER: %s\n"  label)])
		)
		(doall x)
		(def terms (:terms termcluster))
		(def schema (first terms))
		(def data (next terms))
		(def common (:common termcluster))
		;; Need to build up string which can then be println-ed with each term of cluster
		(doseq [term data]
			(def termid (uuid))
			(def w (map println [
				;(format "\n"  )
				(format "aama:ID%s a aamas:Term ;" termid)
				(format "\taamas:lang aama:%s ;" Lang)]))
			(doall w)
			(doseq [[feature value] common]
				(def tprop (name feature))
				(def tval (name value))
				(def x ( map println [
						(if (= tprop "lexeme")
							(format "\taamas:%s aama:%s-%s ;" tprop Lang tval)
							(format "\t%s:%s %s:%s ;" sgpref tprop sgpref tval)
						)
					])
				)
				(doall x)
			)
			(def termmap (apply assoc {}
				(interleave schema term)))
			(doseq [tpropval termmap]
				(def tprop (name (key tpropval)))
				(def tval (name (val tpropval)))
				(def y (map println [
						(if (= tprop "token")
							(format "\t%s:%s \"%s\" ;" sgpref tprop tval )
							(format "\t%s:%s %s:%s ;" sgpref tprop sgpref tval )	
						)
					])
				)
				(doall y)
			)
			(def z (map println [
				(format "\t." )])
			)
			(doall z)
		)
	)
)
 
 

