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
          "key": "${api_key}",
          "type": "standard"
        }
    }
}