terraform {
  backend "s3" {
    bucket = "halo-tf-state"
    key = "global/web-app/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform_state_locking"
    encrypt = true
  }
}
provider "aws" {
  region = "us-east-1"
  profile = "Halo_Sec"
}

data "aws_vpc" "default_vpc" {
    default = true
}

module "instance_security" {
  source = "./Instance_security"
}

locals {
  instance_type = "t2.micro"
  key_name = "Spring"
}

resource "aws_instance" "Jenkins_server" {
  ami           = var.ami_id[1]
  instance_type = local.instance_type
  key_name = local.key_name
  security_groups = [aws_security_group.instances_security.name]
  user_data       = "${file("user-datad.sh")}"
  tags = {
    name = "Jenkins_master_server"
  }
}

resource "aws_instance" "Jenkins_slave" {
  ami = var.ami_id[1]
  instance_type = local.instance_type
  key_name = local.key_name
  user_data = "${file("user-data-slave.sh")}"
  tags = {
    name = "Jenkins_Slave"
  } 
}

 



