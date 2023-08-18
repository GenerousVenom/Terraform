locals {
  tf-lgw = {
    name_of_lgw = "sea-mgnt-lgw-ns-01"
    lgw_address = "125.212.208.58"
    lgw_address_space = "192.168.149.0/24"
  }

  tf-vgw = {
    name_of_pubip = "sea-mgnt-pubip-vgw-01"
    name_of_vgw = "sea-mgnt-vgw-ns-01"
    vgw_address_space = "10.10.0.0/24"
    type     = "Vpn"
    vpn_type = "RouteBased"
    connection_type = "IPsec"
    sku = "VpnGw1"
    shared_key = "svtech-kms-poc"
    name_of_connection = "sea-mgnt-con-ns-01"
  }

  tf-vgw-con = {
    connection_protocol = "IKEv2"
    dpd_timeout_seconds = "45"        # Dead peer detection timeout
    enable_bgp = false

    ipsec_policy = {
      dh_group = "DHGroup14"
      ike_encryption = "AES256"
      ike_integrity = "SHA384"          # Default IKE SA = 8 hours (can't change)
      ipsec_encryption = "AES256"
      ipsec_integrity = "SHA256"
      pfs_group = "PFS2048"
      sa_datasize = 102400000
      sa_lifetime = 36000               # IPSEC SA = 1 hours 
    }
  }

  tf-bas = {
    bas_address_space = "10.10.1.0/24"
    name_of_pubip = "sea-mgnt-pubip-bas-01"
    name_of_bas = "sea-mgnt-bas-ns-01"
  }
}