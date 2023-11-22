terraform {
  required_providers {
       azurerm = {  
       source = "hashicorp/azurerm"
       version = "=3.81.0"
      }
  }
}

provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "sample-resource" {
 name = "sampleresource"
 location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name ="sample-vn"
  address_space = ["10.0.0.0/16"]
  location = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "web_subnet" {
  name = "webb-sub"
  resource_group_name = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "web_nic" {
  name = "webb-nic"
  location = var.location
  resource_group_name = var.resource_group_name
  
  ip_configuration {
    name = "web"
    subnet_id = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"  
   }
}

resource "azurerm_virtual_machine" "web_vm" {
  name = "webb-vm"
  location = var.location
  vm_size = var.vm_size
  network_interface_ids = [azurerm_network_interface.web_nic.id]
  resource_group_name = var.resource_group_name

  storage_os_disk {
   name = "web-os"
   create_option = var.create_option  
  }

 storage_image_reference { 
   publisher= "MicrosoftWindowsServer"         
   offer= "WindowsServer"           
   sku="2019-Datacenter"        
   version= "latest"
 }

 os_profile {
    computer_name  = "webbvm"
    admin_username = "testadmin"
    admin_password = var.password
  }

  os_profile_windows_config {
    provision_vm_agent =  "false"  
}

}

resource "azurerm_subnet" "app_subnet" {
  name = "appl-sub"
  resource_group_name = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes = ["10.0.2.0/24"]
}
resource "azurerm_network_interface" "app_nic" {
  name = "appl-nic"
  location = var.location
  resource_group_name = var.resource_group_name
  
  ip_configuration {
    name = "app"
    subnet_id = azurerm_subnet.app_subnet.id
    private_ip_address_allocation = "Dynamic"  
   }
}

resource "azurerm_virtual_machine" "app_vm" {
  name = "appl-vm"
  location = var.location
  vm_size = var.vm_size
  network_interface_ids = [azurerm_network_interface.app_nic.id]
  resource_group_name = var.resource_group_name

  storage_os_disk {
    name = "app-os"
    create_option = var.create_option
    
  }

   storage_image_reference { 
   publisher= "MicrosoftWindowsServer"         
   offer= "WindowsServer"           
   sku="2019-Datacenter"        
   version= "latest"
 }

  os_profile {
    computer_name  = "applvm"
    admin_username = "testadmin"
    admin_password = var.password
  }

  os_profile_windows_config {
     provision_vm_agent =  "false"  
}
}

resource "azurerm_mssql_server" "dblayer" {
  name = "database-layer"
  resource_group_name = var.resource_group_name
  version = "12.0"
  location = var.location
  administrator_login = "adminuser"
  administrator_login_password = var.password
}

resource "azurerm_subnet" "dbsubnet" {
  name = "db-sub"
  resource_group_name = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes = ["10.0.3.0/24"]
}
  



