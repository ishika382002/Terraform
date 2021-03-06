terraform {

    required_providers {
  
      azurerm = {
  
        source  = "hashicorp/azurerm"
  
        version = "2.97.0"
        
  
        
  
      }
  
    }
  
  }
  
  
  
  // Configure the Microsoft Azure Provider
  
  provider "azurerm" {
  
    features {}
  
  }
  #Create Resource Group
  resource "azurerm_resource_group" "Megh" {
  
    name     = "Megh"
  
    location = "EastUS"
  
  }
  
  #Create Virtual Network
  resource "azurerm_virtual_network" "MeghVnet" {
  
    name                = "MeghVnet"
  
    location            = azurerm_resource_group.Megh.location
  
    resource_group_name = azurerm_resource_group.Megh.name
  
    address_space       = ["10.20.0.0/16"]
  
  }
  #Create Virtual Network Gateway
  resource "azurerm_subnet" "GatewaySubnet" {
    name                 = "GatewaySubnet"
    resource_group_name  = azurerm_resource_group.Megh.name
    virtual_network_name = azurerm_virtual_network.MeghVnet.name
    address_prefixes     = ["10.20.0.0/27"]
  }
  resource "azurerm_public_ip" "MeghVnetGateway_IP" {
    name                = "MeghVnetGateway_IP"
    location            = azurerm_resource_group.Megh.location
    resource_group_name = azurerm_resource_group.Megh.name
  
    allocation_method = "Dynamic"
  }
  resource "azurerm_virtual_network_gateway" "MeghVnetGateway" {
    name                = "MeghVnetGateway"
    location            = azurerm_resource_group.Megh.location
    resource_group_name = azurerm_resource_group.Megh.name
  
    type     = "ExpressRoute"
    sku =  "Standard"
  
    ip_configuration {
      name                          = "MeghVnetGateway_IP"
      public_ip_address_id          = azurerm_public_ip.MeghVnetGateway_IP.id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = azurerm_subnet.GatewaySubnet.id
      
    }
  }
  