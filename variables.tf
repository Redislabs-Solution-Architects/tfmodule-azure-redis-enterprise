variable "location" {
  description = "The location where resources will be created"
  default     = null
}

variable av_zone {
  description = "A list of availability zones to use. Make sure they're valid for this location."
  default     = ["1", "2"]
}

variable "net-cidr" {
  description = "The CIDR blocks to be used in the network"
  type        = list
  default     = ["10.0.11.0/24"]
}

variable "net-name" {
  description = "The name to be associated with the network"
  default     = null
}

variable "cluster-name" {
  description = "The domain name for the cluster (in front of the cluster-base-domain)."
}

variable "cluster-base-domain" {
  description = "A base domain name you own. Helpful if it's managed by a zone file in Azure."
  default     = "azure.redis.life"
}

variable "cluster-base-resource-group" {
  description = "The resource group that contains the zone file for the cluster-base-domain."
  default     = null
}

variable "node-size" {
  description = "The Size of the VM to run for nodes."
  default     = "Standard_DS1_v2"
}

# NOTE that you can't change this without changing parts of the provisioning scripts.
variable "node-publisher" {
  description = "The owner of the image"
  default     = "RedHat"
}

variable "node-offer" {
  description = "The type of the image"
  default     = "RHEL"
}

variable "node-sku" {
  description = "The SKU of the image"
  default     = "7-RAW"
}

variable "node-version" {
  description = "The version of the image"
  default     = "latest"
}

variable "subnet-count" {
  description = "The number of subnets to spin up"
  default     = null
}

variable "node-count" {
  description = "The number of nodes to spin up"
  default     = 3
}

variable "common-tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = map
}

variable "ssh-user" {
  description = "The SSH User"
  default     = "redislabs"
}

variable "ssh-key" {
  description = "The SSH Public Key path"
  default     = "~/.ssh/id_rsa_azure.pub"
}

variable "accelerated-networking" {
  description = "Enable Accelerated networking"
  default     = false
}

# Use this to determine what version of the software gets installed
variable "re-download-url" {
  description = "The download link for the redis enterprise software"
  default     = null
}

variable "allow-public-ssh" {
  description = "Allow SSH to be open to the public - disabled by default"
  default     = "0"
}

variable "open-nets" {
  type        = list
  description = "CIDRs that will have access to everything"
  default     = []
}

