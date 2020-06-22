locals {
  net-name = (var.net-name == null ? split(".", var.cluster-name)[0] : var.net-name)
}
