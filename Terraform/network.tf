data "azurerm_subnet" "subnet" {
  name                 = var.subnet
  virtual_network_name = var.vnet
  resource_group_name  = var.vnet_rg
}

resource "azurerm_public_ip" "apt_pub_ip" {
  name                = "apt-pub-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb" {
  name                = "${var.vm_name}-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = ""
    public_ip_address_id = azurerm_public_ip.apt_pub_ip.id
  }
}
resource "azurerm_network_interface" "nic-1" {
  name = "nic-1"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name


    ip_configuration {
      name      = "primary"
      primary   = true
      subnet_id = data.azurerm_subnet.subnet.id
      private_ip_address_allocation = "Dynamic"
    }

}

resource "azurerm_lb_backend_address_pool" "apt_pool" {
  name                = "apt-pool"
 # resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb.id
}

resource "azurerm_lb_rule" "http_rule" {
  name                           = "http-rule"
 # resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  frontend_ip_configuration_name = ""
 # backend_address_pool_id        = azurerm_lb_backend_address_pool.apt_pool.id
  frontend_port                  = 80
  backend_port                   = 80
  protocol                       = "Tcp"
}

resource "azurerm_lb_rule" "https_rule" {
  name                           = "https-rule"
 # resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  frontend_ip_configuration_name = ""
 # backend_address_pool_id        = azurerm_lb_backend_address_pool.apt_pool.id
  frontend_port                  = 443
  backend_port                   = 443
  protocol                       = "Tcp"
}

resource "azurerm_network_security_group" "apt_nsg" {
  name                = "apt-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "inbound_allow_rule" {
  name                        = "inbound-allow-rule"
  priority                    = 2000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.inbound_allow_prefix
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.apt_nsg.name
}

