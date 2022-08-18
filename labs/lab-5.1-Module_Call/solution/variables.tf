variable "region" {
  type = string
}

variable "bastion_vm_type" {
  description = "Instance type for the bastion VM"
  type = string
  validation {
    condition = var.bastion_vm_type != null && length(var.bastion_vm_type) > 0
    error_message = "bastion_vm_type cannot be null or empty string."
  }
}

variable "cluster_vm_type" {
  description = "Instance type for the cluster VMs"
  type = string
  default = "f1-micro"
}

variable "db_name" {
  description = "Name of database to be created."
  type = string
  default = "lab-database-instance"
}

variable "node_count" {
  description = "Number of Cluster web hosts"
  type = string
  default = null
}

variable "load_level" {
  type = string
  default = ""
}
