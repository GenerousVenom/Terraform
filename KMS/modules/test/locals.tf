locals {
  tf-sub = {
    name_of_sub = "sea-test-snet-ns-01"
    sub_address_space = "10.11.0.0/16"
    name_of_nsg = "sea-test-nsg-ns-01"
  }
  tf-blb = {
    name_of_storage = "seateststrns01"
    name_of_blob = "sea-test-blb-ns-01"
  }
  tf-winvm = {
    name_of_int = "sea-test-int-vm-01"
    name_of_winvm = "sea-test-vm-01"
    size = "Standard_DS1_v2"
    admin_username = "thinhphung"
    admin_password = "123qwe!@#QWE"
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}