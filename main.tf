
resource "null_resource" "cfssl_docker" {
    triggers = {
      "context" = var.docker_context
      "path" = path.module
    }

    provisioner "local-exec" {
        command = "${path.module}/create_service.sh"

        environment = {
            CN=var.common_name
            ATTRS=jsonencode(var.attributes)
            KEY_SETTINGS=jsonencode(var.key_settings)
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