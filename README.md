## cfssl-docker
Docker version of the cfssl serve from [Cloudflare SSL](https://github.com/cloudflare/cfssl) it aims to dockerize 
the process of generating some CA certs and getting to the point of having an API endpoint configured for your
own PKI setup!

## Motivation
I have a homelab and like to deploy various services to try them out. More and more services require HTTPs (quite rightly)
and I was getting fed up with the unverified host warnings in chrome. 

I am also developing this as hopefully a way I can provide a way for my Terraform / Ansible scripts to request certs 
and install them on the OS. 

## Frameworks used

<b>Built with</b>
- [Docker](https://www.docker.com/)
- [Cloudflare CFSSL](https://github.com/cloudflare/cfssl)

## Setup
Following the [How to build yourt own public key infrastructure](https://blog.cloudflare.com/how-to-build-your-own-public-key-infrastructure/)

You'll need to edit the ca-config.json file and add an auth key: 

```javascript
{
    "signing": {
        "profiles": {
            "web-servers": {
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ],
                "expiry": "8760h"
            }
        }
    },
    "auth_keys": {
        "key1": {
          "key": <16 byte hex API key here>,
          "type": "standard"
        }
    }
}
```

and edit the ca-csr.json file to add your domain common name: 
```javascript
{
    "CN": "change.me",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "US",
            "L": "California",
            "ST": "San Francisco"
        }
    ]
}
```

## Building

Once you've configured the above you can simply do: 

```bash
docker build .
```

This will create the docker image ready to be used in whatever way you feel. 

## Using

Once the image has been deployed you can make requests to generate certs for other services 
within your infra. 

```javascript
{
  "signing": {
    "default": {
      "remote": "caserver"
    }
  },
  "remotes": {
    "caserver": "caserver.change.me:8888"
  }
}
```

```javascript
{
    "CN": "service",
    "hosts": [
        "service.change.me"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "US",
            "L": "California",
            "ST": "San Francisco"
        }
    ]
}
```

then run 

```bash
cfssl gencert -config config_client.json csr_client.json | cfssljson -bare db
```

this will generate a key, cert and CSR file ready for installing onto your service. 


## TODO
Learn more. 