output "node-ssh" {
  value = formatlist("ssh -i ${replace(var.ssh-key, ".pub", "")}  -o ForwardAgent=yes -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l ${var.ssh-user} %s", azurerm_public_ip.fixedip.*.ip_address)
}

output "ui-links" {
  value = formatlist("https://%s:8443/", azurerm_public_ip.fixedip.*.ip_address)
}

# TODO: Show this when there are some?
# output "dns-servers" {
#   value = azurerm_dns_zone.base.name_servers
# }

# TODO: Pull the full hostname and generated password for the sample DB here