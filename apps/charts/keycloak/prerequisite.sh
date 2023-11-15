#/bin/bash
BASEDIR=$(dirname "$0")
echo "BASEDIR=${BASEDIR}"
MAAP_ENV_TYPE=${2:-$MAAP_ENV_TYPE}
echo "MAAP_ENV_TYPE=${MAAP_ENV_TYPE}"
NAMESPACE=${1:-keycloak}

kubectl create ns ${NAMESPACE}

for ENV_VAR in ADMIN_USER ADMIN_PASSWORD ; do
    if [[ -z "${!ENV_VAR}" ]]; then
        echo "Variable $ENV_VAR not set!"
        exit 1
    fi
done

kubectl create secret generic keycloak-admin-secret -n ${NAMESPACE} --from-literal "KEYCLOAK_USER=${ADMIN_USER}" --from-literal "KEYCLOAK_PASSWORD=${ADMIN_PASSWORD}"

if [ "${MAAP_ENV_TYPE}X" != "DEVX" ]
then
    for ENV_VAR in POSTGRES_DB_VENDOR POSTGRES_DB_ADDR POSTGRES_DB_PORT POSTGRES_DB_DATABASE ; do
        if [[ -z "${!ENV_VAR}" ]]; then
            echo "Variable $ENV_VAR not set!"
            exit 1
        fi
    done

    kubectl create secret generic keycloak-db-secret -n ${NAMESPACE} --from-literal "DB_VENDOR=${POSTGRES_DB_VENDOR}" --from-literal "DB_ADDR=${POSTGRES_DB_ADDR}" --from-literal "DB_PORT=${POSTGRES_DB_PORT}" --from-literal "DB_DATABASE=${POSTGRES_DB_DATABASE}"
fi

kubectl create secret generic realm-secret --from-file=${BASEDIR}/realm.json

kubectl delete secret biomass-ssl-key -n ${NAMESPACE} ; kubectl create secret tls biomass-ssl-key --key ~/esa-maap.org/${MAAP_ENV_TYPE}/privkey.pem --cert ~/esa-maap.org/${MAAP_ENV_TYPE}/fullchain.pem -n ${NAMESPACE}
