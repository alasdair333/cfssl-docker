#!/bin/bash
pushd $MODULE_DIR
docker-compose --context $CONTEXT up --build -d 
popd