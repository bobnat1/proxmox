# Proxmox Infrastructure as Code

This repository contains Terraform configurations for managing a Proxmox VE cluster infrastructure, including virtual machines, LXC containers, and associated resources.

## 🏗️ Architecture Overview

The infrastructure is deployed across multiple Proxmox nodes:
- **pve** - Primary node hosting most LXC containers
- **pve2** - Secondary node hosting VMs and containers
- **pve3** - Tertiary node for specialized workloads
- **pve4** - Fourth node for storage and media services

## 📋 Resource Inventory

### Virtual Machines (VMs)
| Name | Node | VM ID | Purpose | OS | Resources |
|------|------|-------|---------|-----|-----------|
| Debian-Gitea | pve2 | 102 | Git repository server | Debian | 2 cores, 2GB RAM |
| TrueNAS-NAS | pve4 | 200 | Network Attached Storage | TrueNAS SCALE | 2 cores, 8GB RAM |
| Debian Template | pve | 105 | VM template | Debian | 1 core, 1GB RAM |
| Debian-Ansible | pve2 | 103 | Automation/configuration management | Debian | 1 core, 1GB RAM |
| Debian-Backup | pve2 | 112 | Backup services | Debian | 1 core, 2GB RAM |
| Debian-Wireguard | pve2 | 110 | VPN server | Debian | 1 core, 1GB RAM |
| Windows-Server-DNS | pve2 | 109 | DNS server | Windows Server | 2 cores, 4GB RAM |
| Kali-Security | pve2 | 116 | Security testing | Kali Linux | 2 cores, 2GB RAM |
| Debian-File | pve3 | 117 | File server | Debian | 2 cores, 2GB RAM |
| Elive-Syncthing | pve3 | 114 | File synchronization | Elive Linux | 2 cores, 2GB RAM |
| Debian-Code | pve3 | 106 | Development environment | Debian | 4 cores, 4GB RAM |

### LXC Containers
| Name | Node | VM ID | Purpose | Storage | Memory |
|------|------|-------|---------|---------|--------|
| Monitoring Container | pve | 204 | System monitoring | 8GB | Default |
| Torrent Container | pve | 205 | Torrenting services | 32GB | Default |
| Game Manager Container | pve | 206 | Game management | 32GB | Default |
| AI Container | pve | 208 | Machine learning/AI workloads | 32GB | 2GB |
| PostgreSQL Container | pve | 209 | Database services | 16GB | 2GB |
| Debian Container 104 | pve | 104 | General purpose | 8GB | 512MB |
| Debian Container Template | pve | 107 | LXC template | 8GB | 512MB |
| Project Container | pve | 115 | Development projects | 8GB | 512MB |
| Wiki Container | pve | 113 | Documentation/wiki | 8GB | 512MB |
| BH Container | pve | 111 | General purpose | 8GB | 512MB |
| Dev Database Container | pve | 108 | Development database | 8GB | 512MB |
| Log Container | pve | 100 | Centralized logging | 40GB | 512MB |
| Proxy Container | pve | 101 | Reverse proxy/load balancing | 8GB | 512MB |
| File Container | pve4 | 203 | File storage | 8GB | 1GB |
| Jellyfin Media | pve4 | 202 | Media streaming | 8GB | 2GB |

## 🚀 Quick Start

### Prerequisites

1. **Terraform** (>= 0.15)
2. **Proxmox VE cluster** with API access
3. **AWS credentials** for S3 backend (optional)

### Setup

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd terraform/proxmox
   ```

2. Configure variables:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. Edit `terraform.tfvars` with your Proxmox credentials:
   ```hcl
   proxmox_endpoint = "https://your-proxmox-host:8006"
   proxmox_username = "your-username"
   proxmox_password = "your-password"
   instance_username = "vm-username"
   instance_password = "vm-password"
   ```

4. Initialize Terraform:
   ```bash
   terraform init
   ```

5. Plan and apply:
   ```bash
   terraform plan
   terraform apply
   ```

## 📁 Project Structure

```
.
├── backend.tf              # S3 backend configuration
├── provider.tf             # Proxmox provider configuration
├── variables.tf             # Variable definitions
├── terraform.tfvars.example # Example variables file
├── vm.tf                   # Virtual machine definitions
├── lxc.tf                  # LXC container definitions
├── isos.tf                 # ISO download resources
├── vm_status.tf            # VM status data sources
├── outputs.tf              # Output definitions
├── import_commands.sh      # Helper script for importing existing resources
└── install_postgresql.sh   # PostgreSQL installation script
```

## 🔧 Configuration Details

### Provider Configuration
- Uses the `bpg/proxmox` provider for Terraform
- Configured for self-signed certificates (`insecure = true`)
- Supports both password and API token authentication
- SSH agent integration for secure access

### State Management
- Remote state stored in AWS S3 bucket (`nh-home-infra`)
- State file location: `proxmox/terraform.tfstate`
- Region: `us-east-1`

### Security Features
- All sensitive variables marked as `sensitive = true`
- Automatically generated SSH key pairs for VMs/containers
- Firewall configuration for network interfaces where applicable
- Template-based deployments for consistency

## 🛠️ Management Scripts

### Import Existing Resources
```bash
./import_commands.sh
```
This script contains Terraform import commands for bringing existing Proxmox resources under Terraform management.

### PostgreSQL Installation
```bash
./install_postgresql.sh
```
Automated PostgreSQL installation script for database containers.

## 📊 Resource Tagging

All resources are consistently tagged for easy identification:
- `terraform` - Indicates Terraform management
- Service-specific tags (e.g., `database`, `monitoring`, `vpn`)
- OS tags (e.g., `debian`, `windows`, `kali`)
- Type tags (e.g., `vm`, `lxc`, `template`)

## 🔄 Lifecycle Management

### Ignored Changes
Many resources include `lifecycle` blocks to ignore changes that are managed outside of Terraform:
- Network configurations managed by Proxmox
- Disk modifications after initial creation
- User accounts and SSH keys
- Agent configurations

### Startup Sequences
VMs and containers are configured with startup orders and delays for proper boot sequencing.

## 🌐 Network Configuration

- Primary bridge: `vmbr0`
- DHCP-based IP assignment for most resources
- Firewall enabled on containers where security is critical
- VPN services provided via Debian-Wireguard VM

## 💾 Storage Configuration

- Primary datastore: `local`
- Template storage for both VMs and containers
- Dedicated storage allocations based on service requirements
- Lifecycle rules to prevent accidental disk modifications

## 🔐 Security Considerations

- Credentials stored in `terraform.tfvars` (excluded from version control)
- SSH key-based authentication for all Linux resources
- Firewall rules applied to sensitive containers
- Unprivileged containers where possible

## 📝 Outputs

The configuration provides several outputs for integration with other systems:
- TrueNAS VM information
- PostgreSQL container details
- SSH private keys for secure access

## 🤝 Contributing

1. Follow the existing naming conventions
2. Add appropriate tags to new resources
3. Include lifecycle management rules where appropriate
4. Update this README when adding new resources
5. Test changes in a non-production environment first

## 📞 Support

For issues related to:
- **Terraform configuration**: Check the official Terraform documentation
- **Proxmox provider**: Refer to the `bpg/proxmox` provider documentation
- **Proxmox VE**: Consult the Proxmox VE administration guide

## 📜 License

This project is licensed under the terms specified in the repository license file.

---

*Last updated: $(date)*