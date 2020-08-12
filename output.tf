output "node-ssh" {
  value = formatlist("ssh -i ${replace(var.ssh-key, ".pub", "")}  -o ForwardAgent=yes -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l ${var.ssh-user} %s", azurerm_public_ip.fixedip.*.ip_address)
}

output "ui-links" {
  value = formatlist("https://%s:8443/", azurerm_public_ip.fixedip.*.ip_address)
}

output "node-external-ips" {
  value = azurerm_public_ip.fixedip.*.ip_address
}
