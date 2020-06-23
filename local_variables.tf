locals {
  net-name     = (var.net-name == null ? split(".", var.cluster-name)[0] : var.net-name)
  subnet-count = (var.subnet-count == null ? length(var.av_zone) : var.subnet-count)
}
