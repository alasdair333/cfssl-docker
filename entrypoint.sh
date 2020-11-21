#!/bin/bash
cfssl serve -address 0.0.0.0 -ca-key /certs/ca-key.pem -ca /certs/ca.pem -config /certs/ca-config.json