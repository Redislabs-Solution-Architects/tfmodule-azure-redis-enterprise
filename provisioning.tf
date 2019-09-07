# If the download URL is set, download and install the software
locals {
  re-install = (var.re-download-url != null ? var.node-count : 0)
}

# See bug in https://github.com/terraform-providers/terraform-provider-azurerm/issues/310

resource "null_resource" "remote-config" {
  count = local.re-install
  provisioner "remote-exec" {
    connection {
      user        = var.ssh-user
      host        = "${element(data.azurerm_public_ip.fixedip.*.ip_address, count.index)}"
      private_key = file(replace(var.ssh-key, ".pub", ""))
      agent       = true
    }
    # TODO: Set up data drives with RAID-1 on the right mount point
    inline = ["cd /var/tmp && wget ${var.re-download-url} && tar -xvf redislabs*.tar && sudo -s ./install.sh -y"]
    # TODO: Configure the cluster with rladmin to set rack zone awareness properly
  }
}

# TODO: If statement so the first node does a cluster create, each additional node does a cluster join?

resource "null_resource" "cluster-config" {
    provisioner "remote-exec" {
    connection {
      user        = var.ssh-user
      host        = "${data.azurerm_public_ip.fixedip[0].ip_address}"
      private_key = file(replace(var.ssh-key, ".pub", ""))
      agent       = true
    }
    inline = ["sudo -s rladmin show cluster "]
    # TODO: Configure the cluster with rladmin to set rack zone awareness properly
  }
}