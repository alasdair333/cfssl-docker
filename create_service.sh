#!/bin/bash

# Generate JSON configs for our CA. 
cat <<EOF  > ./cfssl-service/ca-config.json
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

cat <<EOF >  ./cfssl-service/ca-csr.json
{
    "CN": "$CN",
    "key": $KEY_SETTINGS
    "names": [
        $ATTRS
    ]
}
EOF

docker-compose --context $CONTEXT up -d