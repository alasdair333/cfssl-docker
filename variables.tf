variable "common_name" {
    description = "name of the service e.g example.com"
    type = string
}

variable "key_settings" {
    description = "encryption key settings"
    type = object
    default = {
        "algo": "rsa",
        "size": 2048
    }
}

variable "attributes" {
    description = "Attributes to add the the certificate"
    type = map
    default = {
            "C": "US",
            "L": "California",
            "ST": "San Francisco"
        }
}

variable "api_key" {
    description = "API key to communicate with CFSSL's REST APIs"
    type = string
}

variable "docker_context" {
    description = "Which docker context to use"
    type = string
}