variable "location" {
  description = "The location where resources will be created"
  default = "west2us"
}

variable av_zone {
  description = "A list of availability zones to use. Make sure they're valid for this location."
  default = ["1","2"]
}

variable "net-cidr" {
  description = "The CIDR blocks to be used in the network"
  type        = list
  default     = ["10.0.1.0/24"]
}

variable "net-name" {
  description = "The name to be associated with the network"
  default = "redisentpoc"
}

variable "cluster-name" {
  description = "The domain name for the cluster (in front of the cluster-base-domain)."
  default = "redisentpoc"
}

variable "cluster-base-domain" {
  description = "A base domain name you own. Helpful if it's managed by a zone file in Azure."
  default = "azure.redis.life"
}

variable "cluster-base-resource-group" {
  description = "The resource group that contains the zone file for the cluster-base-domain."
  default = null
}

variable "cluster-resource-group" {
  description = "Resource group for the cluster."
  default = null
}

variable "username" {
  default = "demo@redislabs.com"
}

# TODO: Use a random password resource instead here.
variable "password" {
  default = "ULTRASECURE"
}

# TODO: Make this work. Currently unused.
variable "re-license" {
  description = "License Key for non-trial licensing"
  default = null
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
  default     = 2
}

variable "node-count" {
  description = "The number of nodes to spin up"
  default     = 3
}

variable "ssh-user" {
  description = "The SSH User"
  default     = "redislabs"
}

variable "ssh-key" {
  description = "The SSH Public Key path"
  default     = "~/.ssh/id_rsa_azure.pub"
}

# Use this to determine what version of the software gets installed
variable "re-download-url" {
  description = "The download link for the redis enterprise software"
  default     = null
}

# TODO: Make this take a list or a map of db and properties?
variable "demodb-name" {
  default = null
  description = "The name of a demo database to create after cluster setup."
}

variable "cost_center" {
    type = string
}

variable "business_unit" {
    type = string	
}

variable "owner" {
    type = string
}

variable "platform_application" {
    type = string
}

variable "compliance_data_profile" {
    type = string	
}

variable "data_sovereignty_location" {
    type = string	
}

variable "environment" {
    type = string	
}

locals {
  tags = {
		cost-center = "${var.cost_center}"
		business-unit = "${var.business_unit}"
		owner = "${var.owner}"
		environment = "${var.environment}"
		platform-application = "${var.platform_application}"
		compliance-data-profile = "${var.compliance_data_profile}"
		data-sovereignty-location = "${var.data_sovereignty_location}"
	}
}