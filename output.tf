output "ip-addrs" {
  value = formatlist("ssh -i ${replace(var.ssh-key, ".pub", "")}  -o ForwardAgent=yes -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l ${var.ssh-user} %s", azurerm_public_ip.fixedip.*.ip_address)
}
