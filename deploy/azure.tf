# Azure Deployment Configuration for FirePaste

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "firepaste" {
  name     = "rg-firepaste"
  location = "East US"
}

# Container Registry
resource "azurerm_container_registry" "firepaste" {
  name                = "firepasteacr"
  resource_group_name = azurerm_resource_group.firepaste.name
  location            = azurerm_resource_group.firepaste.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Redis Cache (Free tier: Basic C0 - 250MB)
resource "azurerm_redis_cache" "firepaste" {
  name                = "firepaste-redis"
  location            = azurerm_resource_group.firepaste.location
  resource_group_name = azurerm_resource_group.firepaste.name
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  redis_configuration {
    maxmemory_policy = "volatile-lru"
  }
}

# Container App Environment
resource "azurerm_container_app_environment" "firepaste" {
  name                = "firepaste-env"
  location            = azurerm_resource_group.firepaste.location
  resource_group_name = azurerm_resource_group.firepaste.name
}

# Container App for FirePaste
resource "azurerm_container_app" "firepaste" {
  name                         = "firepaste-app"
  container_app_environment_id = azurerm_container_app_environment.firepaste.id
  resource_group_name          = azurerm_resource_group.firepaste.name
  revision_mode                = "Single"

  template {
    container {
      name   = "firepaste"
      image  = "${azurerm_container_registry.firepaste.login_server}/firepaste:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "REDIS_ADDR"
        value = "${azurerm_redis_cache.firepaste.hostname}:${azurerm_redis_cache.firepaste.ssl_port}"
      }

      env {
        name  = "PORT"
        value = "8080"
      }
    }

    min_replicas = 0
    max_replicas = 2
  }

  ingress {
    external_enabled = true
    target_port      = 8080
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  registry {
    server               = azurerm_container_registry.firepaste.login_server
    username             = azurerm_container_registry.firepaste.admin_username
    password_secret_name = "registry-password"
  }

  secret {
    name  = "registry-password"
    value = azurerm_container_registry.firepaste.admin_password
  }
}

# Outputs
output "app_url" {
  value = "https://${azurerm_container_app.firepaste.ingress[0].fqdn}"
}

output "redis_host" {
  value = azurerm_redis_cache.firepaste.hostname
}

output "container_registry" {
  value = azurerm_container_registry.firepaste.login_server
}
