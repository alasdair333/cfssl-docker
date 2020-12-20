
resource "null_resource" "cfssl_docker" {
    triggers = {
      "context" = var.docker_context
    }

    provisioner "local-exec" {
        command = "./create_service.sh"

        environment = {
            CN=var.common_name
            ATTRS=tostring(var.attributes)
            KEY_SETTINGS=tostring(var.key_settings)
            API_KEY=var.api_key
            CONTEXT=var.docker_context
        }
    }

    provisioner "local-exec" {
        when = destroy
        command = "docker-compose --context ${self.triggers.docker_context} down"
    }
  
}