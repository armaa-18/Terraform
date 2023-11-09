terraform {
  required_providers {
       azurerm = {  
       source = "hashicorp/azurerm"
       version = ">= 0.13"
      }
  }
}
 # This block goes outside of the required_providers block!
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "sample-resource" {
 name = "sampleresource"
 location = "eastus"
}

resource "azurerm_virtual_network" "vnet" {
  name ="sample-vnet"
  address_space = ["10.0.0.0/16"]
  location = "eastus"
  resource_group_name = azurerm_resource_group.sample-resource.name
}

resource "azurerm_subnet" "web_subnet" {
  name = "webb-subnet"
  resource_group_name = azurerm_resource_group.sample-resource.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "web_nic" {
  name = "webb-nic"
  location = "eastus"
  resource_group_name = azurerm_resource_group.sample-resource.name
  
  ip_configuration {
    name = "web"
    subnet_id = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"  
   }
}

resource "azurerm_virtual_machine" "web_vm" {
  name = "webb-vm"
  location = "eastus"
  vm_size = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.web_nic.id]
  resource_group_name = azurerm_resource_group.sample-resource.name

  storage_os_disk {
    name = "web-os"
    create_option = "FromImage"
  }
}

resource "azurerm_subnet" "app_subnet" {
  name = "appl-subnet"
  resource_group_name = azurerm_resource_group.sample-resource.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.0.0/24"]
}
resource "azurerm_network_interface" "app_nic" {
  name = "appl-nic"
  location = "eastus"
  resource_group_name = azurerm_resource_group.sample-resource.name
  
  ip_configuration {
    name = "app"
    subnet_id = azurerm_subnet.app_subnet.id
    private_ip_address_allocation = "Dynamic"  
   }
}

resource "azurerm_virtual_machine" "app_vm" {
  name = "appl-vm"
  location = "eastus"
  vm_size = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.app_nic.id]
  resource_group_name = azurerm_resource_group.sample-resource.name

  storage_os_disk {
    name = "app-os"
    create_option = "FromImage"
  }
}

resource "azurerm_mssql_server" "dblayer" {
  name = "db-layer"
  resource_group_name = azurerm_resource_group.sample-resource.name
  version = "12.0"
  location = "eastus"  
  administrator_login = "adminuser"
  administrator_login_password = "P@ssword123"
}

resource "azurerm_subnet" "dbsubnet" {
  name = "db-subnet"
  resource_group_name = azurerm_resource_group.sample-resource.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.0.0/24"]
}
  



