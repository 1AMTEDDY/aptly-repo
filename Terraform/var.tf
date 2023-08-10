variable "project_name" {
  default = ""
}

variable "vm_name" {
  default = ""
}

variable "location" {
  default = "westus2"
}

variable "vm_size" {
  default = "Standard_B2s"
}

variable "vm_count" {
  default = 1
}

variable "admin_user" {
  default = "teddy"
}

variable "vnet_rg" {
  default = ""
}
variable "vnet" {
  default = ""
}

variable "subnet" {
  default = ""
}

variable "inbound_allow_prefix" {
  default = ""
}

variable "storage_account_name" {
  default = ""
}
variable "password" {
  default = "teddy"
}

variable "environment" {
  default = "Production"
}
