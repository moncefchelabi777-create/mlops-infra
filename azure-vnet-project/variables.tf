variable "resource_group_name" {
  type        = string
  default     = "rg-vienna-project"
  description = "Nom du conteneur de ressources Azure"
}

variable "location" {
  type        = string
  default     = "West Europe"
  description = "Région Cloud ciblée pour le projet"
}

variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "Plage IP principale de notre réseau virtuel"
}

