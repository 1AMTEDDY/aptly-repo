provider "azurerm" {

  features {
    virtual_machine_scale_set {
      roll_instances_when_required = false
    }
  }
   subscription_id = ""
}
