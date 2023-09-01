terraform {
  # s3 and dynamo DB already set up
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

module "Jenkins_master" {
  source = "./Master_Server"
}

module "Jenkins_node" {
  source = "./Slave"
}





