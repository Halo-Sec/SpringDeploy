resource "aws_instance" "Jenkins_slave" {
  ami = var.ami_id[1]
  instance_type = local.instance_type
  key_name = local.key_name
  security_groups = [module.instance_security.security_group_name]
  user_data = "${file("user-data-slave.sh")}"
  tags = {
    name = "Jenkins_Slave"
  } 
}