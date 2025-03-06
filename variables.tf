variable "proxmox_endpoint" {
  description = "Proxmox Endpoint"
  type        = string
  sensitive   = true
}

variable "proxmox_username" {
  description = "Proxmox Username"
  type        = string
  sensitive   = true
}

variable "proxmox_password" {
  description = "Proxmox Password"
  type        = string
  sensitive   = true
}

variable "instance_username" {
  description = "Instance Username"
  type        = string
  sensitive   = true
}

variable "instance_password" {
  description = "Instance Password"
  type        = string
  sensitive   = true
}