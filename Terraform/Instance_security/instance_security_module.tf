resource "aws_security_group" "instance_security" {
    name = "instance_security_group"
    description =  "Security group for Jenkins servers"
    vpc_id = data.aws_vpc.default_vpc.id

    ingress{
      description = "HTTP port open"
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{
      description = "SSH port open"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]      

    }

    egress{
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }

}

output "security_group_name" {
  value = aws_security_group.instance_security.name
}
