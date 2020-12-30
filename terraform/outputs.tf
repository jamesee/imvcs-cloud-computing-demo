### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
 content = templatefile("inventory.tmpl",
 {
  public_ip = module.ec2_cluster.public_ip,
  instance_id = module.ec2_cluster.id,
 }
 )
 filename = "../ansible/inventory"
}
