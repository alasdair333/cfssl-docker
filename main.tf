
locals {
    ca_config_file = templatefile("${path.module}/cfssl-service/ca-config.json.tpl", {
        api_key = var.api_key,
    })
    ca_csr_file = templatefile("${path.module}/cfssl-service/ca-csr.json.tpl", {
        cn = var.common_name
        key_settings = var.key_settings,
        attrs = var.attributes
    })
}

resource "local_file" "ca-config" {
    content = local.ca_config_file
    filename = "${path.module}/cfssl-service/ca-config.json"
}

resource "local_file" "csr-config" {
    content = local.ca_csr_file
    filename = "${path.module}/cfssl-service/ca-csr.json"
}

resource "null_resource" "cfssl_docker" {
    depends_on = [
    local_file.ca-config,
    local_file.csr-config
    ]

    triggers = {
      "context" = var.docker_context
      "path" = path.module
    }

    provisioner "local-exec" {
        command = "${path.module}/create_service.sh"

        environment = {
            CN=var.common_name
            ATTRS=tostring(jsonencode(var.attributes))
            KEY_SETTINGS=tostring(jsonencode(var.key_settings))
            API_KEY=var.api_key
            CONTEXT=var.docker_context
            MODULE_DIR=path.module
        }
    }

    provisioner "local-exec" {
        when = destroy
        command = "cd ${self.triggers.path} && docker-compose --context ${self.triggers.context} down"
    } 
}