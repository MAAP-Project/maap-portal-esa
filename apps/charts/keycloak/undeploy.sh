#/bin/bash
BASEDIR=$(dirname "$0")
echo "BASEDIR=${BASEDIR}"
MAAP_ENV_TYPE=${2:-$MAAP_ENV_TYPE}
echo "MAAP_ENV_TYPE=${MAAP_ENV_TYPE}"
NAMESPACE=${1:-keycloak}

helm uninstall -n ${NAMESPACE} keycloak

kubectl delete secret -n ${NAMESPACE} biomass-ssl-key

kubectl delete namespace ${NAMESPACE}

