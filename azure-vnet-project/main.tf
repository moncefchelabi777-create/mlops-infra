terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 2. Utilisation de la variable pour le nom et la localisation
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# 3. Utilisation de la variable pour la plage IP réseau (Plage CIDR)
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-main-prod"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space
}

# 4. Création d'une IP Publique pour pouvoir se connecter au serveur IA
resource "azurerm_public_ip" "pip" {
  name                = "pip-ai-server"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# 5. Création de la Carte Réseau (NIC) pour brancher la VM dans notre VNet
resource "azurerm_network_interface" "nic" {
  name                = "nic-ai-server"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_virtual_network.vnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# 6. La Machine Virtuelle Spéciale MLOps sécurisée par clé SSH
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-mlops-compute"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2s_v3" # 2 CPU, 8 Go de RAM — Idéal pour Docker !
  admin_username      = "moncefadmin"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  # Sécurité par clé SSH (La méthode des pros !)
  admin_ssh_key {
    username   = "moncefadmin"
    public_key = file("~/.ssh/id_rsa_mlops.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# 7. Création du Pare-feu (Network Security Group)
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-mlops"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Règle de sécurité : On autorise UNIQUEMENT le protocole SSH (Port 22)
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# 8. Liaison du Pare-feu avec la carte réseau du serveur IA
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

