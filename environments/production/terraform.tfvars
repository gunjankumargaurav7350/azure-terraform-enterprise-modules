resource_groups = {
  "rg-enterprise-hub-prod" = {
    location = "centralindia"
    tags = {
      Environment = "Production"
      Owner       = "Platform Engineering"
      ManagedBy   = "Terraform"
    }
  }
  "rg-enterprise-spoke-prod" = {
    location = "centralindia"
    tags = {
      Environment = "Production"
      Workload    = "Core Banking Application"
      ManagedBy   = "Terraform"
    }
  }
}

network_security_groups = {
  "nsg-app-tier-prod" = {
    location           = "centralindia"
    resource_group_key = "rg-enterprise-spoke-prod"
    security_rules = {
      "Allow_HTTP_Inbound" = {
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "10.0.0.0/16"
        destination_address_prefix = "*"
        description                = "Allow internal HTTP from Hub"
      }
      "Allow_HTTPS_Inbound" = {
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "10.0.0.0/16"
        destination_address_prefix = "*"
        description                = "Allow internal HTTPS from Hub"
      }
      "Deny_All_Internet_Inbound" = {
        priority                   = 4096
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
        description                = "Enforce Zero Trust perimeter"
      }
    }
    tags = { Tier = "App", ManagedBy = "Terraform" }
  }
}

virtual_networks = {
  "vnet-spoke-prod-001" = {
    location           = "centralindia"
    resource_group_key = "rg-enterprise-spoke-prod"
    address_space      = ["10.1.0.0/16"]
    subnets = {
      "snet-web-tier" = {
        address_prefixes  = ["10.1.1.0/24"]
        service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
      }
      "snet-app-tier" = {
        address_prefixes  = ["10.1.2.0/24"]
        service_endpoints = ["Microsoft.KeyVault", "Microsoft.Sql"]
      }
      "snet-db-tier" = {
        address_prefixes  = ["10.1.3.0/24"]
        service_endpoints = ["Microsoft.Sql"]
      }
    }
    tags = { Environment = "Production", Topology = "Spoke" }
  }
}

key_vaults = {
  "kv-enterprise-core-prod" = {
    location                  = "centralindia"
    resource_group_key        = "rg-enterprise-hub-prod"
    sku_name                  = "premium"
    enable_rbac_authorization = true
    network_acls = {
      bypass         = "AzureServices"
      default_action = "Deny"
      ip_rules       = ["103.21.244.0/24"]
    }
    tags = { Tier = "Security", Compliance = "CIS-Benchmark" }
  }
}
