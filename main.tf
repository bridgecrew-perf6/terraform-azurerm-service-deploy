resource "azurerm_mysql_firewall_rule" "main" {
  name                = var.service
  resource_group_name = var.resource_group
  server_name         = var.mysql_server
  start_ip_address    = azurerm_container_group.main.ip_address
  end_ip_address      = azurerm_container_group.main.ip_address
}

resource "azurerm_container_group" "main" {
  name                = var.service
  location            = var.location
  resource_group_name = var.resource_group
  ip_address_type     = "Public"
  os_type             = var.container.platform
  dns_name_label      = var.service
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