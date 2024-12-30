terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

variable "lxc_password" {
  type = string
  sensitive = true
}

resource "tls_private_key" "auth_key" {
  algorithm = "ED25519"
}

resource "local_file" "private_key" {
  content  = tls_private_key.auth_key.private_key_openssh
  filename = "${path.module}/private_key"
}

resource "null_resource" "set_permissions" {
  depends_on = [local_file.private_key]

  provisioner "local-exec" {
    command = "chmod 600 ${path.module}/private_key"
  }
}

resource "proxmox_lxc" "wireguard" {
  vmid                 = 2001 
  target_node          = "pve"
  hostname             = "wireguard"
  ostemplate           = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  password             = var.lxc_password
  ssh_public_keys      = tls_private_key.auth_key.public_key_openssh
  unprivileged         = true
  force                = false 
  ignore_unpack_errors = false
  template             = false
  unique               = false

  memory       = 512
  cores        = 1
  cpulimit     = 1

  rootfs {
    storage   = "local-zfs"
    size      = "1G"
    replicate = false
    ro        = false
    acl       = false
    quota     = false
    shared    = false

  }

  network {
    name     = "eth0"
    bridge   = "vmbr0"
    ip       = "192.168.1.201/24"
    gw       = "192.168.1.1"
    rate     = 0
    mtu      = 0
    firewall = false
  }
  features {
    nesting = true
  }

  onboot   = true
  start    = false 
  restore  = false

  bwlimit  = 0

}

