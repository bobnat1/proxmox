#!/bin/bash

echo "Starting Terraform import of missing VMs and containers..."
echo "============================================================"

# VMs to import
echo "Importing VMs..."
terraform import 'proxmox_virtual_environment_vm.debian_template' pve/105
terraform import 'proxmox_virtual_environment_vm.debian_ansible' pve2/103
terraform import 'proxmox_virtual_environment_vm.debian_backup' pve2/112
terraform import 'proxmox_virtual_environment_vm.debian_wireguard' pve2/110
terraform import 'proxmox_virtual_environment_vm.windows_server_dns' pve2/109
terraform import 'proxmox_virtual_environment_vm.kali_security' pve2/116
terraform import 'proxmox_virtual_environment_vm.debian_file' pve3/117
terraform import 'proxmox_virtual_environment_vm.elive_syncthing' pve3/114
terraform import 'proxmox_virtual_environment_vm.debian_code' pve3/106

echo "Importing LXC containers..."
# LXC containers to import
terraform import 'proxmox_virtual_environment_container.debian_container_104' pve/104
terraform import 'proxmox_virtual_environment_container.debian_container_template' pve/107
terraform import 'proxmox_virtual_environment_container.project_container' pve/115
terraform import 'proxmox_virtual_environment_container.wiki_container' pve/113
terraform import 'proxmox_virtual_environment_container.bh_container' pve/111
terraform import 'proxmox_virtual_environment_container.dev_db' pve/108
terraform import 'proxmox_virtual_environment_container.log_container' pve/100
terraform import 'proxmox_virtual_environment_container.proxy_container' pve/101
terraform import 'proxmox_virtual_environment_container.file_container' pve4/203
terraform import 'proxmox_virtual_environment_container.jellyfin_media' pve4/202

# Note: TLS private keys cannot be imported - Terraform will generate new ones
echo "Note: New TLS private keys will be generated for containers"

echo "============================================================"
echo "Import commands completed!"
echo "Next steps:"
echo "1. Run 'terraform plan' to see what changes need to be made"
echo "2. Adjust the resource configurations to match the actual state"
echo "3. Run 'terraform apply' to sync any remaining differences"