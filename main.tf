data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"] 

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "ssh_only" {
  name        = "sg"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_key_pair" "main" {
  key_name   = "tf-ec2-key-${var.env}"
  public_key = file(var.public_key_path)
}

# Instancia EC2 (Linux)
resource "aws_instance" "linux" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.ssh_only.id]
  key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = true

  tags = var.tags
}

output "ec2_public_ip"  { value = aws_instance.linux.public_ip }
output "ec2_public_dns" { value = aws_instance.linux.public_dns }

###Dynamo DB
resource "aws_dynamodb_table" "app" {
  name         = var.ddb_table_name
  billing_mode = var.billing_mode  
  hash_key     = var.ddb_pk_name

  attribute {
    name = var.ddb_pk_name
    type = "S"
  }

  tags = var.tags
}
