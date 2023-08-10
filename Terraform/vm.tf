data "template_file" "cloudconfig" {
  template = file("${path.module}/cloud-init.tpl")
  vars = {

    apt_dir           = "${azurerm_managed_disk.apt.name}"
    user              = "${var.storage_account_name}"
    password          = "${var.password}"
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloudconfig.rendered}"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                   = var.vm_size
  admin_username      = var.admin_user

  network_interface_ids = [
    azurerm_network_interface.nic-pri.id
    ]

  admin_ssh_key {
    username   = var.admin_user
    public_key = file("${path.module}/ssh-keys/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  custom_data = data.template_cloudinit_config.config.rendered

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  tags = {
    role        = var.vm_name
    environment = var.environment
  }
}






resource "azurerm_managed_disk" "apt" {
  name = "apt"
  resource_group_name  = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb = 128

}

resource "azurerm_virtual_machine_data_disk_attachment" "apt-disk-attachment" {
  managed_disk_id = azurerm_managed_disk.apt.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  lun = 0
  caching = "ReadWrite"
}

