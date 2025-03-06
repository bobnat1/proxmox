resource "proxmox_virtual_environment_download_file" "truenas_scale" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve4"
  url          = "https://download.sys.truenas.net/TrueNAS-SCALE-ElectricEel/24.10.2/TrueNAS-SCALE-24.10.2.iso"
}