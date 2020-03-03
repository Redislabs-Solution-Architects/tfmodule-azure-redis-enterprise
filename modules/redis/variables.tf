variable "location" {
  description = "Identity: The location where resources will be created"
  default = "west2us"
}

variable "cluster-name" {
  description = "Identity: The domain name for the cluster (in front of the cluster-base-domain)."
  default = "redisentpoc"
}

variable "cluster-base-domain" {
  description = "Identity: A base domain name you own. Helpful if it's managed by a zone file in Azure."
  default = "azure.redis.life"
}

variable "cluster-base-resource-group" {
  description = "Identity: The resource group that contains the zone file for the cluster-base-domain."
  default = null
}

variable "cluster-resource-group" {
  description = "Identity: Resource group for the cluster."
  default = null
}

variable av_zone {
  description = "Network: A list of availability zones to use. Make sure they're valid for this location."
  default = ["1","2"]
}

variable "net-cidr" {
  description = "Network: The CIDR blocks to be used in the network"
  type        = list
  default     = ["10.0.1.0/24"]
}

variable "subnet-count" {
  description = "Networking: The number of subnets to spin up"
  default     = 1
}

variable "net-name" {
  description = "Network: The name to be associated with the network"
  default = "redisentpoc"
}

variable "username" {
  description = "Demo: The username to use for the cluster adminstrator"  
}

variable "password" {
  description = "Demo: The password to use as the cluster administrator"
}

variable "demodb-name" {
  default = null
  description = "Demo: The name of a demo database to create after cluster setup."
}

variable "node-size" {
  description = "Provisioning: The Size of the VM to run for nodes."
  default     = "Standard_DS_v2"
}

variable "node-publisher" {
  description = "Provisioning: The owner of the image"
  default     = "RedHat"
}

variable "node-offer" {
  description = "Provisioning: The type of the image"
  default     = "RHEL"
}

variable "node-sku" {
  description = "Provisioning: The SKU of the image"
  default     = "7-RAW"
}

variable "node-version" {
  description = "Provisioning: The version of the image"
  default     = "latest"
}

variable "ssh-user" {
  description = "Provisioning: The SSH user used to deploy software to the nodes"
  default     = "redislabs"
}

variable "ssh-key" {
  description = "Provisioning: The SSH public key path used to deploy software to the nodes"
  default     = "~/.ssh/id_rsa_azure.pub"
}

variable "ssh-allowip" {
  description = "Provisioning: IP Addresses from which to allow SSH traffic"  
  //type        = list
}

variable "node-count" {
  description = "Provisioning: The number of nodes to spin up"
  default     = 3
}

variable "re-download-url" {
  description = "Provisioning: The download link for the redis enterprise software"
  default     = null
}

variable "cost_center" {
    description = "Tag: Required by InComm Cloud Governance"
    type = string
}

variable "business_unit" {
    description = "Tag: Required by InComm Cloud Governance"
    type = string	
}

variable "owner" {
    description = "Tag: Required by InComm Cloud Governance"
    type = string
}

variable "platform_application" {
    description = "Tag: Required by InComm Cloud Governance"
    type = string
}

variable "compliance_data_profile" {
    description = "Tag: Required by InComm Cloud Governance"
    type = string	
}

variable "data_sovereignty_location" {
    description = "Tag: Required by InComm Cloud Governance"
    type = string	
}

variable "environment" {
    description = "Tag: Required by InComm Cloud Governance"
    type = string	
}

variable "client-count" {    
    type    = string	
    default = 2
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