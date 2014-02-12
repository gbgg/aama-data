;; REPL Version
(def bejaedn {
	:lang :beja-arteiga
	:schemata { 									
		  :conjClass [:Prefix, :Suffix] 		
		  :gender [:Common, :Fem, :Masc]
		  }
	:morphemes {
	  :PRO {:gloss "Pronoun", :pos :Pronoun}
	  :SUBJMARK {:gloss "Subject Marker", }
	}
	:lexemes {
	  :dbl {:conjClass :Prefix, :gloss "collect, gather", :pos :Verb, :rootClass :CCC}
	  :dgy {:conjClass :Prefix, :gloss "hear", :pos :Verb, :rootClass :CCY}
	}
	:lxterms #{
	   {:label "beja_H-VPrefAffCCYPres"
		:common {:conjClass :Prefix,
			:lexeme :dgy,
			:polarity :Affirmative,
			:pos :Verb,
			:rootClass :CCY,
			:tam :Present}
		:terms [[:gender, :number, :person, :token]  ;; schema
			[:Masc, :Singular, :Person3, "dangì"],
			[:Common, :Plural, :Person1, "ni-déeg"],
			[:Common, :Plural, :Person2, "ti-deeg-`na"],
			[:Masc, :Singular, :Person2, "dangii-`a"],
			[:Common, :Plural, :Person3, "?i-deeg-`na"],
			[:Common, :Singular, :Person1, "?a-dangì"],
			[:Fem, :Singular, :Person3, "dangì"],
			[:Fem, :Singular, :Person2, "dangii-`"]]
		}
		{:label "beja_H-VPrefAffCCYAor"
		:common {:conjClass :Prefix,
			:lexeme :dgy,
			:polarity :Affirmative,
			:pos :Verb,
			:rootClass :CCY,
			:tam :Aorist}
		:terms [[:gender, :number, :person, :token]  ;; schema
			[:Common, :Plural, :Person3, "?i-diig-`na"],
			[:Common, :Plural, :Person2, "ti-diig-`na"],
			[:Fem, :Singular, :Person2, "ti-diig-`i"],
			[:Common, :Plural, :Person1, "ni-dìig"],
			[:Masc, :Singular, :Person3, "?i-dìig"],
			[:Fem, :Singular, :Person3, "ti-dìig"],
			[:Masc, :Singular, :Person2, "ti-diig-`a"],
			[:Common, :Singular, :Person1, "?a-dìig"]]
		}
		}
	}
)

(def sgpref "bar")
(defn uuid [] (str (java.util.UUID/randomUUID)))

(def lang (name (bejaedn :lang)))
(def Lang (clojure.string/capitalize lang))
(def x ( map println [
		(format "aama:%s a aamas:Language ." Lang)
		(format  "aama:%s rdfs:label \"%s\" ." Lang Lang)
	])
)
(doall x)

(def schemata (bejaedn :schemata))
(doseq [[property valuelist] schemata]
	(def prop (name property))
	;; NB clojure.string/capitalize gives  wrong output with 
	;; terms like conjClass: =>Conjclass rather than ConjClass
	(def Prop (clojure.string/capitalize prop))
	(def x ( map println [
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

(def morphemes (bejaedn :morphemes))
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

(def lexemes (bejaedn :lexemes))
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

(def lexterms (bejaedn :lxterms))
(doseq [ termcluster lexterms]
	(def label (:label termcluster))
	(def x (map println [
		(format "\n%s: %s\n" "TERMCLUSTER" label)])
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
