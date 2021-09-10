resource "null_resource" "delete_vpcs" {
  provisioner "local-exec" {
    command = "/bin/bash delete_default_vpcs.sh"
  }
}
