
locals {
  # flash_enabled 
    # TODO: Set up data drives with RAID-1 on the right mount point
  re-install = (var.re-download-url != null ? var.node-count : 0)
  # TODO: fdisk and partition some flash drives, then RAID and mount them.
  # flash_mount = "mkdir -p /mnt/flash && "
  # If the download URL is set, download and install the software
  install_step = "[ ! -f '/var/tmp/install.sh' ] && cd /var/tmp && wget ${var.re-download-url} && tar -xvf redislabs*.tar && sudo -s ./install.sh -y"
  license-install = (var.re-license != null ? ""  : "echo 'trial license time.'")
  short_pause = "sleep 10"
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
    # flash_enabled flash_path /mnt/flash 
    inline = ["set -x",
              "${ local.install_step}",
              "/opt/redislabs/bin/rladmin cluster create name ${var.cluster-name}.${var.cluster-base-domain} username ${var.username} password ${var.password} rack_aware rack_id rack-1 external_addr ['${data.azurerm_public_ip.fixedip[0].ip_address}']",
              "${ local.short_pause }" ]
    # TODO: Configure the cluster with rladmin to set rack zone awareness properly
  }
  depends_on = [ "azurerm_dns_ns_record.fixedip"]
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
    inline = ["set -x",
              "${ local.install_step}",
              "${ local.other_node } rack_id rack-${ (count.index + 1) % length(var.av_zone) + 1  } external_addr ['${element(data.azurerm_public_ip.fixedip.*.ip_address, count.index + 1)}']" ]
  }
  depends_on = [ "null_resource.remote-config"]
}