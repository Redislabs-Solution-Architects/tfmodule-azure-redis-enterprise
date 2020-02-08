locals {  
  create-license-json     = <<EOF
  {
    "license": "----- LICENSE START -----\nQ4KVocZjD3/FBc3Q8s8xMt6+aRmPsLyp4VV4uC6fNFvxLjc4bhaPJOVK8AeU\nV1G7QZJu0byxnDYMLbRQs3q3ptq9+IYiUrQxuhwfh8q/mhscbsEokNNMJKrH\nQBdr5w4YyzOJnT71OZ7wizxkCv0DO3FBQzONd+F3w84+Kg9yABrdTYVTzrXn\nVpDa5tCfJJ1Bf98hIqVeOAJTCdofvbYAh86H1TKN4wqi0y7NHs7xrwdYXeWf\nYbp2EHmpQ1kDPsc10uODcOWQweLXd+Mw00FhWOQVpzKbBjh1sfz5eyYMjCll\nMtV60Z4ecimA/i6Asclfj+56UP5dWMJ+HsU1VQZ/tw==\n----- LICENSE END -----"
  }
  EOF
  create-demo-json        = <<EOF
  {
	  "name": "${var.demodb-name}",
	  "type": "redis",
	  "memory_size": 2000000000,
	  "replication": true
  }
  EOF
  create-license-script   = "curl -v -k -u ${var.username}:${var.password} --location-trusted -H 'Content-Type: application/json' -X PUT  https://127.0.0.1:9443/v1/license -d '${jsonencode(jsondecode(replace(replace(local.create-license-json, "\r", ""),"\n","")))}'"     
  create-demo-script      = "curl -v -k -u ${var.username}:${var.password} --location-trusted -H 'Content-Type: application/json' -X POST https://127.0.0.1:9443/v1/bdbs -d '${jsonencode(jsondecode(replace(replace(local.create-demo-json, "\r", ""),"\n","")))}'"     
  #-H 'Authorization: Basic dGVzdEByZWRpc2xhYnMuY29tOnJlZGlzbGFicw==' -H 'Content-Type: application/json' 
}

resource "null_resource" "create-license" {  
  provisioner "remote-exec" {
    connection {
      user        = var.ssh-user
      host        = data.azurerm_public_ip.fixedip[0].ip_address
      private_key = file(replace(var.ssh-key, ".pub", ""))
      agent       = false
    }
    inline = [        
        "${chomp(local.create-license-script)}"        
    ]  
  }
  depends_on = [ null_resource.remote-config-nodes ]
}

resource "null_resource" "create-demo" {  
  provisioner "remote-exec" {
    connection {
      user        = var.ssh-user
      host        = data.azurerm_public_ip.fixedip[0].ip_address
      private_key = file(replace(var.ssh-key, ".pub", ""))
      agent       = false
    }
    inline = [
        "${chomp(local.create-demo-script)}"
    ]  
  }
  # Add A Destroy Provisioner...
  depends_on = [ null_resource.remote-config-nodes ]
}

