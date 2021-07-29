#!/bin/bash
set -euxo pipefail

##############################################################################
##
##  GH actions CI test script
##
##############################################################################

# LMP 3.0+ goals are listed here: https://github.com/OpenLiberty/ci.maven#goals
export HOSTNAME=localhost

## Rebuild the application
mvn -Dhttp.keepAlive=false \
    -Dmaven.wagon.http.pool=false \
    -Dmaven.wagon.httpconnectionManager.ttlSeconds=120 \
    -q clean package
mvn -pl system liberty:create 
mvn -pl system liberty:install-feature 
mvn -pl system liberty:deploy

mvn -pl inventory liberty:create 
mvn -pl inventory liberty:install-feature 
mvn -pl inventory liberty:deploy

## Run the tests
mvn -pl system liberty:start
mvn -pl inventory liberty:start
mvn verify -Dsystem.ip=localhost:9080 -Dinventory.ip=localhost:8080 
mvn -pl system liberty:stop 
mvn -pl inventory liberty:stop
