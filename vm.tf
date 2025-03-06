resource "proxmox_virtual_environment_vm" "debian_gitea" {
  name        = "Debian-Gitea"
  description = "Managed by Terraform"
  tags        = ["terraform", "debian", "git"]

  node_name = "pve2"
  vm_id     = 102
  scsi_hardware = "virtio-scsi-single"
  agent {
    enabled = true
    type    = "virtio"
  }

  cpu {
    cores   = 2
    sockets = 1
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = 2048
  }

  network_device {
    bridge      = "vmbr0"
    mac_address = "46:FB:F2:BC:20:14"
    model       = "virtio"
    firewall    = true
  }

  operating_system {
    type = "l26"
  }

  serial_device {
    device = "socket"
  }
}

# resource "random_password" "ubuntu_vm_password" {
#   length           = 16
#   override_special = "_%@"
#   special          = true
# }

# resource "tls_private_key" "ubuntu_vm_key" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# output "ubuntu_vm_password" {
#   value     = random_password.ubuntu_vm_password.result
#   sensitive = true
# }

# output "ubuntu_vm_private_key" {
#   value     = tls_private_key.ubuntu_vm_key.private_key_pem
#   sensitive = true
# }

# output "ubuntu_vm_public_key" {
#   value = tls_private_key.ubuntu_vm_key.public_key_openssh
# }


resource "proxmox_virtual_environment_vm" "truenas_nas" {
  name        = "TreuNAS-NAS"
  description = "Managed by Terraform"
  tags        = ["terraform", "truenas", "nas"]

  node_name = "pve4"
  vm_id     = 200

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }
  # if agent is not enabled, the VM may not be able to shutdown properly, and may need to be forced off
  stop_on_destroy = true

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  cpu {
    cores        = 2
    type         = "x86-64-v2-AES"  # recommended for modern CPUs
  }

  memory {
    dedicated = 8192
    floating  = 8192 # set equal to dedicated to enable ballooning
  }

  # cdrom {
  #   file_id      = proxmox_virtual_environment_download_file.truenas_scale.id
  # }

  disk {
        file_format = "qcow2"
        interface = "scsi0"
        datastore_id = "local"
        size = 32
    }
  initialization {
    datastore_id = "local"
    
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      keys     = [trimspace(tls_private_key.truenas_vm_key.public_key_openssh)]
      password = var.instance_username
      username = var.instance_password
    }

    # user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  serial_device {}
}

resource "tls_private_key" "truenas_vm_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# resource "random_password" "ubuntu_vm_password" {
#   length           = 16
#   override_special = "_%@"
#   special          = true
# }

# output "ubuntu_vm_password" {
#   value     = random_password.ubuntu_vm_password.result
#   sensitive = true
# }

# output "ubuntu_vm_private_key" {
#   value     = tls_private_key.ubuntu_vm_key.private_key_pem
#   sensitive = true
# }

# output "ubuntu_vm_public_key" {
#   value = tls_private_key.ubuntu_vm_key.public_key_openssh
# }