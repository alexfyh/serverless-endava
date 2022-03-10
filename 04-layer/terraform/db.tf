module "db" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = "serverless-example"

  engine            = "mysql"
  engine_version    = "8.0.28"
  instance_class    = "db.t2.micro"
  allocated_storage = 5
  storage_encrypted = false

  db_name  = "sakila"
  username = var.username
  password = var.password
  port     = "3306"
  create_random_password = false

  # vpc_security_group_ids = ["sg-12345678"]

  tags = {
    Terraform = "true"
    Environment = "dev"
    Project = "Serverless example"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_protection = false
  skip_final_snapshot = true

  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
  vpc_security_group_ids = [aws_security_group.allow_mysql.id]
}

resource "aws_security_group" "allow_mysql" {
  name        = "allow_mysql"
  description = "Allow MYSQL inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "MYSQL from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_mysql"
  }
}

# Engine version	5.7.25	8.0.28
# DB parameter group	serverless-example-20220306051946318600000003	default.mysql8.0
# Option group	serverless-example-20220306051946317200000001	default:mysql-8-0