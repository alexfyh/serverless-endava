output "db_instance_endpoint" {
  value = module.db.db_instance_endpoint
}

output "private_subnets"{
  value = [module.vpc.private_subnets]
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}
