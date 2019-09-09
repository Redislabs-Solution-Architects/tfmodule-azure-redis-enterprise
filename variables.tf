variable "location" {
  description = "The location where resources will be created"
}

variable "net-cidr" {
  description = "The CIDR blocks to be used in the network"
  type        = "list"
}

variable "net-name" {
  description = "The name to be associated with the network"
}

variable "cluster-name" {
  default = "redisentpoc"
}

variable "cluster-base-domain" {

  default = "redis.life"
}

variable "username" {
  default = "demo@redislabs.com"
}

variable "password" {
  default = "ULTRASECURE"
}

variable "node-size" {
  description = "The Size of the VM to run"
  default     = "Standard_DS1_v2"
}

variable "node-publisher" {
  description = "The owner of the image"
  default     = "Canonical"
}

variable "node-offer" {
  description = "The type of the image"
  default     = "UbuntuServer"
}

variable "node-sku" {
  description = "The SKU of the image"
  default     = "16.04.0-LTS"
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
  default     = 2
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
  # default     = null
}
