locals {  
  create-license-json     = <<EOF
  {                
    "license": "----- LICENSE START -----\nPotGVc85TIjp4/FlwK7AGRW/xDQebbV59lzhaN09FJsb6wqNheKGFs07mI7R\ncPJGx699VT/3H1gWefSTWEAxJJXVpOnO8qNPfPZFi4vS5LPBZ/7R2eF8GIkv\n86sAD7fQ7v1BSE0KanS6WxeGa9mXWoq77tCt0jAtV6CCpXps9wjbp/xPhjou\nZLYnyydtJaf5UCK/wXqHo9sez4KqEUm7wk/eorO62Ve1dLVdtcTq7DNHXeIA\nycTtR6VjODl/7OTZRZm1iKtPbjPFvlWAvvsbV8ptGsG6nuU8XBaD+d/QrVaN\nvqoaySdb+d614O69GEr4LnVBZyBfZtJe2Z6oTGO/eg==\n----- LICENSE END -----"
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

