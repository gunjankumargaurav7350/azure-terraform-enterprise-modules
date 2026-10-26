output "id" { value = azurerm_kubernetes_cluster.this.id }
output "name" { value = azurerm_kubernetes_cluster.this.name }
output "oidc_issuer_url" { value = try(azurerm_kubernetes_cluster.this.oidc_issuer_url, null) }
