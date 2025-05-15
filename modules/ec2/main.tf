resource "aws_security_group" "default_sg" {
  name        = "${var.agent_identifier_name}-security-group"
  description = "A default security group for ${var.agent_identifier_name} EC2 instances"
  vpc_id      = var.vpc_id  

  # Inbound rule to allow SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # List of allowed IPs or 0.0.0.0/0 for open access
  }

  # Inbound rule to allow HTTP (port 80) - Optional for web servers
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # List of allowed IPs or 0.0.0.0/0 for open access
  }

  # Inbound rule to allow HTTPS (port 443) - Optional for web servers
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # List of allowed IPs or 0.0.0.0/0 for open access
  }

  # Outbound rule to allow all traffic (default)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Default EC2 Security Group"
  }
}

# EC2 Instance

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "${var.agent_identifier_name}-key"
  public_key = tls_private_key.this.public_key_openssh
}

resource "aws_secretsmanager_secret" "key" {
  name        = "${var.agent_identifier_name}-private-key"
  description = "Private key for ${var.agent_identifier_name} EC2 instances"
}

resource "aws_secretsmanager_secret_version" "key_value" {
  secret_id     = aws_secretsmanager_secret.key.id
  secret_string = tls_private_key.this.private_key_pem
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.this.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids        = [aws_security_group.default_sg.id]

  tags = {
    Name = "${var.agent_identifier_name}-ec2"
  }
}
