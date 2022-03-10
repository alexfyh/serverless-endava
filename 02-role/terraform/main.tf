## La primera vez ejecutar:
## terraform init

## Luego:
## terraform apply

## Finalizada la prueba:
## terraform destroy


data "aws_ami" "amazon2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "web" {
  count = 2
  ami           = data.aws_ami.amazon2.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
    Project = "Serverless"
  }
}