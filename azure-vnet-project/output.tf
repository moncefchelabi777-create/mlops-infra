output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "L'ID unique de notre réseau virtuel Azure pour connecter Kubernetes"
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Le nom officiel du réseau déployé"
}
