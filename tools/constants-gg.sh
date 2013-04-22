JARDIR=../../../saxon/saxonpe9-3-0-5j
SAXON=saxon9pe.jar
FUSEKIDIR=/cygdrive/c/Fuseki-0.2.4

EYEBALL="../src/eyeball-2.3/lib/*"
RDF2RDF="../../../rdf2rdf/rdf2rdf-1.0.1-2.3.1.jar"

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
