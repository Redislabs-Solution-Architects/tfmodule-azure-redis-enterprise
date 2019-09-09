# If the download URL is set, download and install the software
locals {
  re-install = (var.re-download-url != null ? var.node-count : 0)
  first_node = "/opt/redislabs/bin/rladmin cluster create name ${var.cluster-name}.${var.cluster-base-domain} username ${var.username} password ${var.password}"
  other_node ="/opt/redislabs/bin/rladmin cluster join nodes ${azurerm_network_interface.nic[0].private_ip_address} username ${var.username} password ${var.password}"
}

# See bug in https://github.com/terraform-providers/terraform-provider-azurerm/issues/310

resource "null_resource" "remote-config" {
  provisioner "remote-exec" {
    connection {
      user        = var.ssh-user
      host        = "${data.azurerm_public_ip.fixedip[0].ip_address}"
      private_key = file(replace(var.ssh-key, ".pub", ""))
      agent       = true
    }
    # TODO: Set up data drives with RAID-1 on the right mount point
    inline = ["cd /var/tmp && wget ${var.re-download-url} && tar -xvf redislabs*.tar && sudo -s ./install.sh -y",
      "${ local.first_node }" ]
    # TODO: Configure the cluster with rladmin to set rack zone awareness properly
  }
}

resource "null_resource" "remote-config-nodes" {
  count = local.re-install - 1
  provisioner "remote-exec" {
    connection {
      user        = var.ssh-user
      host        = "${element(data.azurerm_public_ip.fixedip.*.ip_address, count.index + 1)}"
      private_key = file(replace(var.ssh-key, ".pub", ""))
      agent       = true
    }
    # TODO: Set up data drives with RAID-1 on the right mount point
    inline = ["cd /var/tmp && wget ${var.re-download-url} && tar -xvf redislabs*.tar && sudo -s ./install.sh -y",
      "${ local.other_node }" ]
    # TODO: Configure the cluster with rladmin to set rack zone awareness properly
  }
  depends_on = [ "null_resource.remote-config"]
}