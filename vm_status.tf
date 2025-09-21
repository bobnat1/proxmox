data "proxmox_virtual_environment_vm" "debian_gitea" {
  node_name = "pve2"
  vm_id     = 110
}

data "proxmox_virtual_environment_hosts" "pve2" {
  node_name = "pve2"
}