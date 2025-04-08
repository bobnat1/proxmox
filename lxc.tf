resource "proxmox_virtual_environment_container" "monitoring_container" {
  description = "Monitoring services container"

  node_name = "pve"
  vm_id     = 204

  initialization {
    hostname = "monitor-container"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      keys = [
        trimspace(tls_private_key.monitor_container_key.public_key_openssh)
      ]
      password = var.instance_password
    }
  }

  network_interface {
    name = "veth0"
  }

  disk {
    datastore_id = "local"
    size         = 8
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
    # Or you can use a volume ID, as obtained from a "pvesm list <storage>"
    # template_file_id = "local:vztmpl/jammy-server-cloudimg-amd64.tar.gz"
    type             = "debian"
  }

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }
}

resource "tls_private_key" "monitor_container_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
