locals {
    demo-count = (var.demodb-name != null ? 1 : 0)
}

#resource "null_resource" "create-demo" {
#  count = local.demo-count
#  provisioner "remote-exec" {
#    connection {
#      user        = var.ssh-user
#      host        = data.azurerm_public_ip.fixedip[0].ip_address
#      private_key = file(replace(var.ssh-key, ".pub", ""))
#      agent       = true
#    }
#    inline = [
#        "curl -d '{\"name\": \"${var.demodb-name}\", \"type\": \"redis\", \"memory_size\": 1000000, \"replication\": true}' -H 'Content-Type: application/json' https://127.0.0.1:9443/v1/bdbs -k --user \"${var.username}:${var.password}\""
#    ]  
#  }
#  depends_on = [ null_resource.remote-config-nodes ]
#}