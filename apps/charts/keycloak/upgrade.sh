#/bin/bash
BASEDIR=$(dirname "$0")
echo "BASEDIR=${BASEDIR}"
MAAP_ENV_TYPE=${2:-$MAAP_ENV_TYPE}
echo "MAAP_ENV_TYPE=${MAAP_ENV_TYPE}"
NAMESPACE=${1:-keycloak}

helm upgrade -n ${NAMESPACE} keycloak codecentric/keycloak --values ./values-keycloak-${MAAP_ENV_TYPE}.yaml --disable-openapi-validation
