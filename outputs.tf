# output "vm_state" {
#   value = proxmox_virtual_environment_vm.debian_gitea
# }

# output "host_state" {
#     value = data.proxmox_virtual_environment_hosts.pve2
# }

output "true_nas_vm_username" {
  value     = proxmox_virtual_environment_vm.truenas_nas
  sensitive = true
}

output "postgres_container_info" {
  value     = proxmox_virtual_environment_container.postgres_container
  sensitive = true
}

output "postgres_container_private_key" {
  value     = tls_private_key.postgres_container_key.private_key_openssh
  sensitive = true
}

