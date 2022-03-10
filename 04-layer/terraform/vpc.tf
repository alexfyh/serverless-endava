module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-lambda_with_ddbb"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # enable_nat_gateway = false
  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
    Project = "Serverless example"
  }
}

data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon.id
  instance_type = "t2.micro"
  subnet_id = module.vpc.public_subnets[0]
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "bastion"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "allow_ssh"
  }
}


# module "nat" {
#   source = "int128/nat-instance/aws"

#   name                        = "bastion"
#   vpc_id                      = module.vpc.vpc_id
#   public_subnet               = module.vpc.public_subnets[0]
#   private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
#   private_route_table_ids     = module.vpc.private_route_table_ids
#   key_name = var.key_name
#   tags = {
#     Terraform = "true"
#     Environment = "dev"
#     Project = "Serverless example"
#   }
# }

# resource "aws_eip" "nat" {
#   network_interface = module.nat.eni_id
#   tags = {
#     Terraform = "true"
#     Environment = "dev"
#     Project = "Serverless example"
#   }
# }

# resource "aws_security_group_rule" "bastion-sg" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   ipv6_cidr_blocks  = ["::/0"]
#   security_group_id = module.nat.sg_id
# }