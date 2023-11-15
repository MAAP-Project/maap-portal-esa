#/bin/bash
BASEDIR=$(dirname "$0")
echo "BASEDIR=${BASEDIR}"
MAAP_ENV_TYPE=${2:-$MAAP_ENV_TYPE}
echo "MAAP_ENV_TYPE=${MAAP_ENV_TYPE}"
NAMESPACE=${1:-portal}

kubectl create ns ${NAMESPACE}

kubectl delete secret biomass-ssl-key -n ${NAMESPACE} ; kubectl create secret tls biomass-ssl-key --key ~/esa-maap.org/${MAAP_ENV_TYPE}/privkey.pem --cert ~/esa-maap.org/${MAAP_ENV_TYPE}/fullchain.pem -n ${NAMESPACE}
