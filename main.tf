# This block tells Terraform the "azurerm" provider for Azure.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# This block configures the Azure provider.
# Terraform will use your Azure CLI login automatically.
provider "azurerm" {
  features {}
}

# This is our first resource!
# We are creating an Azure Resource Group named "tf-lab-rg".
resource "azurerm_resource_group" "rg" {
  name     = "tf-lab-rg"
  location = "East US" # You can change this to a region near you.
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = "tf-lab-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a subnet within the virtual network
resource "azurerm_subnet" "subnet" {
  name                 = "tf-lab-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a Public IP address for our VM
resource "azurerm_public_ip" "pip" {
  name                = "tf-lab-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
}

# Create a Network Security Group (Firewall)
resource "azurerm_network_security_group" "nsg" {
  name                = "tf-lab-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # This rule allows SSH traffic (port 22) from the internet
  security_rule {
    name                       = "SSH"
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

# Create the Network Interface for our VM
resource "azurerm_network_interface" "nic" {
  name                = "tf-lab-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# Associate our NSG with our NIC
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# This is the Virtual Machine resource itself
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "tf-lab-vm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B1s"
  admin_username        = "labadmin"
  
  # Connects this VM to the network interface you created earlier
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  # Best practice is to use SSH keys, but for this lab, we'll use a password.
admin_ssh_key {
    username   = "labadmin"
    public_key = "PUBLIC_KEY_HERE"
  }

 os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS" # Options: Standard_LRS, Premium_LRS, StandardSSD_LRS
  }

  # This section defines the OS image to use for the VM
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

# This output block will print the Public IP address after you apply
output "public_ip_address" {
  value = azurerm_public_ip.pip.ip_address
}
