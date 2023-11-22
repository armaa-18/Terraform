variable "location" {       
    default = "eastus"  
}
variable "resource_group_name" {
    default = "sampleresource"   
}
variable "virtual_network_name" {
    default = "sample-vn" 
}
variable "password" {
    default = "P@ssword123" 
}

variable "vm_size" {
    default = "Standard_B1s"
}
variable "create_option" {
    default = "fromimage"  
}
