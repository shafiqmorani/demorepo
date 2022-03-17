resource "azurerm_resource_group" "vnet" {
  name     = var.vnet_resource_group_name
  location = var.location
  
}

module "hub_network" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.vnet.name
  location            = var.location
  vnet_name           = var.hub_vnet_name
  address_space       = ["10.80.0.0/23"]
  dns_servers  = ["10.1.0.14", "10.1.0.15"]
  subnets = [
    {
      name : "core-services-subnet"
      address_prefixes : ["10.80.0.0/24"]
    },
    {
      name : "gateway-subnet"
      address_prefixes : ["10.80.1.0/24"]
    }
  ]
  tags                = var.tags
}

module "spoke_network" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.vnet.name
  location            = var.location
  vnet_name           = var.spoke_vnet_name
  address_space       = ["10.100.0.0/22"]
  dns_servers  = ["10.2.0.14", "10.2.0.15"]
  subnets = [
    {
      name : "application-01-subnet"
      address_prefixes : ["10.100.0.0/24"]
    },
    {
      name : "application-02-subnet"
      address_prefixes : ["10.100.1.0/24"]
    }
  ]
  tags                = var.tags
}
