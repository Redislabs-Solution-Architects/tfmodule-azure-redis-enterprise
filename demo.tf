locals {
  create-crdb-json =<<EOF
    {
      "default_db_config": {
        "name": "cluster-crdb",
        "bigstore": false,
        "replication": true,        
        "memory_size": 4294967296,
        "snapshot_policy": [],
        "shards_count": 2,
        "shard_key_regex": [{          
          "regex": ".*\\{(?<tag>.*)\\}.*"
        },
        {
          "regex": "(?<tag>.*)"
        }],
        "port": 12000
      },
      "instances": [{
        "cluster": {
          "url": "https://${element(var.locations, 0).cluster-name}.${var.cluster-base-domain}:9443",
          "credentials": {
            "username": "${var.username}",
            "password": "${var.password}"
          },
          "name": "${element(var.locations, 0).cluster-name}.${var.cluster-base-domain}"
        },
        "compression": 6
      },
      {
        "cluster": {
          "url": "https://${element(var.locations, 1).cluster-name}.${var.cluster-base-domain}:9443",
          "credentials": {
            "username": "${var.username}",
            "password": "${var.password}"
          },
          "name": "${element(var.locations, 1).cluster-name}.${var.cluster-base-domain}"
        },
        "compression": 6
      }],
      "name": "cluster-crdb"
    }
  EOF
  create-crdb-script = "curl -v -k -u ${var.username}:${var.password} --location-trusted -H 'Content-Type: application/json' -X POST https://localhost:9443/v1/crdbs -d '${jsonencode(jsondecode(replace(replace(local.create-crdb-json, "\r", ""),"\n","")))}'" 
}

resource "null_resource" "create-CRDB" {  
  provisioner "remote-exec" {
    connection {
      user        = var.ssh-user
      host        = "${element(var.locations, 1).cluster-name}.${var.cluster-base-domain}"
      private_key = file(replace(var.ssh-key, ".pub", ""))
      agent       = false
    }
    inline = [ 
      "${chomp(local.create-crdb-script)}"      
    ]  
  }
  depends_on = [ azurerm_virtual_network_peering.peering-uswest2, azurerm_virtual_network_peering.peering-useast2, module.redis_cluster-useast2 ]
}


