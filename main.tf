
locals {
    ca_config_file = templatefile("${path.module}/cfssl-service/ca-config.json.tpl", {
        api_key = var.api_key,
    })
    ca_csr_file = templatefile("${path.module}/cfssl-service/ca-csr.json.tpl", {
        cn = var.common_name
        key_settings =  replace(jsonencode(var.key_settings), "/\"([0-9]+\\.?[0-9]*)\"/", "$1")
        #key_settings =  replace(jsonencode(var.key_settings), "/\"([0-9]+\\.?[0-9]*)\"/", "$1"),
        attrs = jsonencode(var.attributes)
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
            CONTEXT=var.docker_context
            MODULE_DIR=path.module
        }
    }

    provisioner "local-exec" {
        when = destroy
        command = "cd ${self.triggers.path} && docker-compose --context ${self.triggers.context} down"
    } 
}