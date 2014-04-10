JARDIR=~/.jar
SAXON=saxon9pe.jar
FUSEKIDIR=/Applications/jena-fuseki-1.0.1/

EYEBALL="~/.jar/eyeball-2.3/lib/*"
RDF2RDF="~/.jar/rdf2rdf-1.0.1-2.3.1.jar"


capitalize_path ()
{
    p=${1/\/\///}
    path=${p%/}
    # printf "Path: %s\n" $path
    OLDFS=${IFS}
    IFS='/'
    tokens=( ${path} )
    # echo "Path tokens: " ${tokens[*]^}
    newpath="${tokens[*]^}"
    IFS=${OLDFS}
}

uncapitalize_path ()
{
    p=${1/\/\///}
    path=${p%/}
    # printf "Path: %s\n" $path
    OLDFS=${IFS}
    IFS='/'
    tokens=( ${path} )
    # echo "Path tokens: " ${tokens[*]^}
    newpath="${tokens[*],}"
    IFS=${OLDFS}
}
