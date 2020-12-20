locals {
    build_command = "./create_service.sh"
    destroy_command = "docker-compose --context ${var.docker_context} down"
}

resource "null_resource" "cfssl_docker" {

    provisioner "local-exec" {
        command = local.build_command

        environment = {
            CN=var.common_name
            ATTRS=var.attributes
            KEY_SETTINGS=var.key_settings
            API_KEY=var.api_key
            CONTEXT=var.docker_context
        }
    }

    provisioner "local-exec" {
        when = "destroy"
        command = local.destroy_command
    }
  
}