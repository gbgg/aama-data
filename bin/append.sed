#appending changes to query/display scripts
/constants.sh/a\
ldomain=${1//,/ }\
ldomain=${ldomain//\"/}

$a\
bin/aama-query-display-demo.sh



