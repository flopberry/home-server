terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}


locals {
  config  = yamldecode(file("${path.module}/vars.yaml"))
}


provider "proxmox" {
  pm_api_url = local.config.proxmox.api_url
  pm_api_token_id = local.config.proxmox.api_token_id
  pm_api_token_secret = local.config.proxmox.api_token_secret
  pm_tls_insecure = true
  pm_debug = true
}

module "wireguard" { 
  source = "./2001-wireguard"
  lxc_password = local.config.lxc_password
}
