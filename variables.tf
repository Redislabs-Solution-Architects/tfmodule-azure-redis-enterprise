variable "location" {
  description = "The location where resources will be created"
  default = "west2us"
}

variable av_zone {
  default = ["1","2"]
}

variable "net-cidr" {
  description = "The CIDR blocks to be used in the network"
  type        = "list"
  default     = ["10.0.1.0/24"]
}

variable "net-name" {
  description = "The name to be associated with the network"
  default = "redisentpoc"
}

variable "cluster-name" {
  default = "redisentpoc"
}

variable "cluster-base-domain" {
  default = "azure.redis.life"
}

variable "cluster-base-resource-group" {
  default = null
}

variable "username" {
  default = "demo@redislabs.com"
}

variable "password" {
  default = "ULTRASECURE"
}

variable "re-license" {
  description = "License Key for non-trial licensing"
  default = null
}

variable "node-size" {
  description = "The Size of the VM to run"
  default     = "Standard_DS1_v2"
}

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

variable "common-tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = "map"

  default = {
    config = "terraform"
  }
}

variable "ssh-user" {
  description = "The SSH User"
  default     = "redislabs"
}

variable "ssh-key" {
  description = "The SSH Public Key path"
  default     = "~/.ssh/id_rsa_azure.pub"
}

variable "re-download-url" {
  description = "The download link for the redis enterprise software"
  default     = null
}
