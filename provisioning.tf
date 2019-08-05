# If the download URL is set, download and install the software
locals {
  re-install = (var.re-download-url != null ? var.node-count : 0)
}


resource "null_resource" "remote-config" {
  count = local.re-install
  provisioner "remote-exec" {
    connection {
      user        = var.ssh-user
      host        = "${element(azurerm_public_ip.fixedip.*.ip_address, count.index)}"
      private_key = file(replace(var.ssh-key, ".pub", ""))
      agent       = true
    }
    inline = ["cd /var/tmp && wget ${var.re-download-url}"]
  }
}