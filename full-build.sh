#!/bin/bash

set -e

echo
echo "====="
echo "===== START CLUSTER"
echo "====="
./install-local.sh custom-images onmshs


echo
echo "====="
echo "===== BUILD EXTERNAL-IT"
echo "====="
cd external-it/
mvn install


echo
echo "====="
echo "===== EXECUTE EXTERNAL-IT"
echo "====="

INGRESS_BASE_URL=https://onmshs
KEYCLOAK_BASE_URL=https://onmshs/auth
KEYCLOAK_REALM=opennms
KEYCLOAK_USERNAME=admin
KEYCLOAK_PASSWORD=admin
KEYCLOAK_CLIENT_ID=horizon-stream

export INGRESS_BASE_URL KEYCLOAK_BASE_URL KEYCLOAK_REALM KEYCLOAK_USERNAME KEYCLOAK_PASSWORD KEYCLOAK_CLIENT_ID

PROJECT_VERSION="$(mvn -Dexec.executable=echo -Dexec.args='${project.version}' --non-recursive -q org.codehaus.mojo:exec-maven-plugin:1.6.0:exec)"
java -jar "external-horizon-stream-it/target/external-horizon-stream-it-${PROJECT_VERSION}.jar"
