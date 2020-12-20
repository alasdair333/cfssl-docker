#!/bin/bash

# Generate JSON configs for our CA. 
CA_CONFIG = <<EOF
{
    "signing": {
        "default": {
            "auth_key": "key1",
            "expiry": "8760h",
            "usages": [
                "signing",
                "key encipherment",
                "server auth",
                "client auth"
            ]
        }
    },
    "auth_keys": {
        "key1": {
          "key": "$API_KEY",
          "type": "standard"
        }
    }
}
EOF

CA_CSR = <<EOF
{
    "CN": "$CN",
    "key": $KEY_SETTINGS
    "names": [
        $ATTRS
    ]
}
EOF

echo $CA_CONFIG > cfssl-service/ca-config.json
echo $CA_CSR > cfssl-service/ca-csr.json

docker-compose --context $CONTEXT --build up -d