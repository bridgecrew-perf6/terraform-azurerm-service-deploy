resource "azurerm_network_profile" "main" {
  name                = "${var.service}-network-profile"
  location            = var.location
  resource_group_name = var.resource_group

  container_network_interface {
    name = "${var.service}-network-interface"

    ip_configuration {
      name      = "${var.service}-ip-configuration"
      subnet_id = var.subnet
    }
  }
}

resource "azurerm_container_group" "main" {
  name                = var.service
  location            = var.location
  resource_group_name = var.resource_group
  ip_address_type     = "private"
  os_type             = var.container.platform
  network_profile_id  = azurerm_network_profile.main.id
  exposed_port {
    port     = var.container.port
    protocol = "TCP"
  }
  image_registry_credential {
    username = var.registry.username
    password = var.registry.password
    server   = var.registry.server
  }
  container {
    name   = var.service
    image  = var.container.image
    cpu    = var.container.cpu
    memory = var.container.memory
    ports {
      port     = var.container.port
      protocol = "TCP"
    }
    readiness_probe {
      initial_delay_seconds = 30
      period_seconds        = 30
      timeout_seconds       = 30
      http_get {
        path   = var.container.health_path
        port   = 80
        scheme = "Http"
      }
    }
    liveness_probe {
      initial_delay_seconds = 30
      period_seconds        = 30
      timeout_seconds       = 30
      http_get {
        path   = var.container.health_path
        port   = 80
        scheme = "Http"
      }
    }
    environment_variables = var.container.environment
  }
}