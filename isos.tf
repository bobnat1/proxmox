resource "proxmox_virtual_environment_download_file" "truenas_scale" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve4"
  url          = "https://download.sys.truenas.net/TrueNAS-SCALE-ElectricEel/24.10.2/TrueNAS-SCALE-24.10.2.iso"
}

resource "proxmox_virtual_environment_download_file" "debian_13" {
  content_type = "iso"
  datastore_id = "local"
  file_name    = "debian-13.2.0-amd64-netinst.iso"
  node_name    = "pve3"
  url          = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.2.0-amd64-netinst.iso"
}

